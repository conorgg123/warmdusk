# Warm Dusk

**The night mode your TV forgot.**

Google TV runs on hundreds of millions of devices and ships with no night mode. Phone blue-light apps do not run on TV. OEM “eye care” picture modes are buried, unscheduled, and vanish per input.

Warm Dusk is a warm, dimmable filter over **everything** on your TV — Netflix included — on an automatic evening schedule, with one signature interaction:

> **Hold MUTE for about one second.** A warmth panel appears over whatever is playing.

This repository distributes the free **Phase 0 preview**: the APK, the install script, release notes, and the community compatibility table. If enough people want it, a polished Play Store build with guided setup and Pro features follows.

---

## Why this is different

| | Warm Dusk | OEM eye-care modes | Phone filter apps |
|---|---|---|---|
| Covers Netflix / DRM apps | Yes | Often no / per-input | Not on TV |
| Scheduled evenings | Yes | Rarely | N/A |
| In-content control | Hold MUTE → panel | Buried menus | Touch UI |
| Ads / accounts / tracking | None | — | Usually yes |
| Network permission | **None** | — | Usually yes |

The privacy claim is not marketing copy. The APK has **no `INTERNET` permission** — it physically cannot phone home. You don't have to take our word for it: [verify the download](#verify-the-download) below shows how to check the binary yourself in one command.

---

## What’s in the preview

- Global warm overlay (amber tint + black dim) over every app, including DRM
- Auto schedule: ramp 7:30–9:30 PM → night shield → morning fade after wake (default 7:00)
- Quick panel: Off · Auto · Soft · Medium · Strong · Candle — D-pad adjust live
- Boot persistence (filter returns after reboot without opening the app)
- Status screen with live grant indicators and exact fix commands
- Fallback: **Warm Dusk Panel** home-row entry if you skip the accessibility grant

**Not in the preview** (store / Pro scope): solar sunset schedule, custom colors, guided browser installer.

---

## Install (~3 minutes, one time)

**You need:** TV and PC on the same Wi‑Fi · wireless debugging (or ADB over network) enabled on the TV.

1. Download `warmdusk-v0.1.0-preview.apk` and `install.ps1` from the [latest release](../../releases/latest).
2. Put them in the same folder.

### Option A — script (recommended)

```powershell
.\install.ps1 -Ip YOUR_TV_IP
```

The script installs the APK, grants overlay permission, **appends** the accessibility service (does not clobber services you already have), and launches Warm Dusk. If the TV is storage-starved, it runs a proven fallback chain automatically.

### Option B — manual ADB

```text
adb connect YOUR_TV_IP:5555
adb install -r warmdusk-v0.1.0-preview.apk

adb shell appops set com.warmdusk.tv.preview SYSTEM_ALERT_WINDOW allow

# Append — do not replace your existing accessibility services:
adb shell settings put secure enabled_accessibility_services \
  EXISTING:com.warmdusk.tv.preview/com.warmdusk.tv.PanelService
adb shell settings put secure accessibility_enabled 1
```

Replace `EXISTING` with whatever `settings get secure enabled_accessibility_services` already returns (or omit the prefix if empty).

### Try it

1. Open Netflix (or any app).
2. Hold **MUTE** ~1 second → panel appears.
3. Short MUTE still mutes normally.
4. Open Warm Dusk from the apps row → status screen should show three green indicators.

---

## Verify the download

| | |
|---|---|
| Package | `com.warmdusk.tv.preview` |
| Version | `0.1.0-preview` |
| Size | 661,384 bytes (0.63 MB) |
| SHA-256 | `D2966E50F8FA13B619816A3A1FD8D01C786036EED83BAD10FF01CF3368C3644D` |

```powershell
Get-FileHash -Algorithm SHA256 .\warmdusk-v0.1.0-preview.apk
```

Check the permissions in the binary itself (aapt2 ships with the Android SDK build-tools):

```text
aapt2 dump badging warmdusk-v0.1.0-preview.apk | findstr uses-permission
```

Permissions present: overlay, foreground service, boot, notifications.
Permission **absent**: `android.permission.INTERNET`.

---

## Privacy & permissions

| Permission | Why |
|---|---|
| `SYSTEM_ALERT_WINDOW` | Draw the warm filter over other apps |
| Foreground service | Keep the schedule ticking while other apps are open |
| `RECEIVE_BOOT_COMPLETED` | Restore the filter after reboot |
| Accessibility (optional) | Detect MUTE long-press over other apps; read D-pad **only while the panel is open** |

The accessibility service does **not** read screen content, does **not** log keys, and has nowhere to send data. If you prefer not to enable it, use the **Warm Dusk Panel** home-row entry instead — same panel, no mute-hold.

**Why isn’t the source public?** The polished store version will be a paid product, so the code stays private. The claims that matter are about the binary you actually run — and every one of them (no INTERNET permission, 0.63 MB, exact hash) is verifiable from the APK itself with the commands above.

---

## Compatibility

| Device | Result |
|---|---|
| Sony Bravia XR (Google TV) | Primary test device — see [COMPATIBILITY.md](COMPATIBILITY.md) |

**Help wanted:** Chromecast / Google TV Streamer, Fire TV, TCL, Hisense, onn.
[Open a device report →](../../issues/new?template=device-report.yml)

---

## Roadmap (if demand is real)

1. Guided browser installer (pairing code, no ADB knowledge)
2. Play Store build — solar schedule, tuned color presets, Pro one-time unlock
3. Public compatibility matrix maintained from your reports

The filter and the hold-mute panel stay free. No ads. Ever.

---

## Support

- Bugs → [bug report](../../issues/new?template=bug.yml)
- Setup stopped → [setup-failure report](../../issues/new?template=setup-fail.yml)
- Setup worked → [device report](../../issues/new?template=device-report.yml)
- Prefer private email → `feedback@warmdusk.com` · [open a prefilled setup-failure email](mailto:feedback@warmdusk.com?subject=SETUP%20FAIL%20%E2%80%94%20%3Cyour%20TV%20model%3E&body=TV%20brand%2Fmodel%3A%0AAndroid%2FGoogle%20TV%20version%3A%0AStep%20reached%3A%0AExact%20error%20%28paste%20verbatim%29%3A%0ANetwork%20notes%20%28optional%29%3A)
- Site → [warmdusk.com](https://warmdusk.com)

Email subject: `SETUP FAIL — <your TV model>`. Include TV brand/model, Android/Google TV version, furthest step reached, exact error text pasted verbatim, and optional network notes.

---

*Warm Dusk is independent software. Not affiliated with Google, Sony, Netflix, Amazon, or any streaming service.*
