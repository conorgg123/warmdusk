# install.ps1 - install and set up Warm Dusk Preview on a Google TV / Android TV.
# Includes a storage-fallback install chain and accessibility APPEND
# (read-modify-write - it never clobbers services you already have).
#
# Usage (APK downloaded from the same release, in the same folder):
#   .\install.ps1 -Ip 10.0.0.42
#   .\install.ps1 -Ip 10.0.0.42 -Apk C:\Downloads\warmdusk-v0.1.0-preview.apk
#
# Requires adb (Android platform-tools) on PATH or in the default SDK spot.
param(
    [Parameter(Mandatory = $true)][string]$Ip,
    [string]$Apk = (Join-Path $PSScriptRoot 'warmdusk-v0.1.0-preview.apk')
)

$ErrorActionPreference = 'Continue'
$pkg = 'com.warmdusk.tv.preview'
$svc = "$pkg/com.warmdusk.tv.PanelService"

if (-not (Test-Path $Apk)) {
    Write-Error "APK not found at $Apk - download warmdusk-v0.1.0-preview.apk from the release into this folder (or pass -Apk)."
    exit 1
}

$adb = Join-Path $env:LOCALAPPDATA 'Android\Sdk\platform-tools\adb.exe'
if (-not (Test-Path $adb)) { $adb = 'adb' }

Write-Output '-- APK checksum (compare with the release notes) --'
(Get-FileHash -Algorithm SHA256 $Apk).Hash

Write-Output "-- Connecting to $Ip --"
& $adb connect "${Ip}:5555"

Write-Output '-- Installing (with storage fallback chain) --'
& $adb -s "${Ip}:5555" install -r $Apk 2>&1 | Tee-Object -Variable out
if ("$out" -match 'INSUFFICIENT_STORAGE') {
    Write-Output 'Storage full -> trimming caches...'
    & $adb -s "${Ip}:5555" shell pm trim-caches 99999999999
    & $adb -s "${Ip}:5555" install -r $Apk 2>&1 | Tee-Object -Variable out
    if ("$out" -match 'INSUFFICIENT_STORAGE') {
        Write-Output 'Still full -> uninstall keeping data, clean install...'
        & $adb -s "${Ip}:5555" shell cmd package uninstall -k $pkg
        & $adb -s "${Ip}:5555" install $Apk
    }
}

Write-Output '-- Granting overlay permission --'
& $adb -s "${Ip}:5555" shell appops set $pkg SYSTEM_ALERT_WINDOW allow
& $adb -s "${Ip}:5555" shell appops get $pkg SYSTEM_ALERT_WINDOW

Write-Output '-- Enabling quick panel (accessibility service, APPEND not clobber) --'
$cur = (& $adb -s "${Ip}:5555" shell settings get secure enabled_accessibility_services 2>&1 | Out-String).Trim()
if ($cur -eq 'null' -or $cur -eq '') {
    & $adb -s "${Ip}:5555" shell settings put secure enabled_accessibility_services $svc
} elseif ($cur -notlike "*$svc*") {
    & $adb -s "${Ip}:5555" shell settings put secure enabled_accessibility_services ($cur + ':' + $svc)
} else {
    Write-Output 'Already enabled.'
}
& $adb -s "${Ip}:5555" shell settings put secure accessibility_enabled 1

Write-Output '-- Verify --'
& $adb -s "${Ip}:5555" shell settings get secure enabled_accessibility_services
& $adb -s "${Ip}:5555" shell monkey -p $pkg -c android.intent.category.LEANBACK_LAUNCHER 1 | Out-Null
Write-Output 'Done. Warm Dusk should be on screen - hold MUTE over any app to test the panel.'
