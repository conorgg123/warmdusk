# Warm Dusk v0.1.0-preview

**The night mode your TV forgot** — free validation build for Google TV / Android TV.

This release exists to answer one question: do enough people want this that a polished Play Store version is worth building?

---

## Download

Attached: `warmdusk-v0.1.0-preview.apk` and `install.ps1`

| Field | Value |
|---|---|
| Package | `com.warmdusk.tv.preview` |
| Version | `0.1.0-preview` (versionCode 1) |
| Size | **661,384 bytes** (0.63 MB) |
| SHA-256 | `D2966E50F8FA13B619816A3A1FD8D01C786036EED83BAD10FF01CF3368C3644D` |

```powershell
Get-FileHash -Algorithm SHA256 .\warmdusk-v0.1.0-preview.apk
```

**No `INTERNET` permission.** Confirm it from the binary itself:

```text
aapt2 dump badging warmdusk-v0.1.0-preview.apk | findstr uses-permission
```

You should see overlay / FGS / boot / notifications — and nothing named `INTERNET`.

---

## What’s included

- Warm + dim overlay over all apps (including DRM / Netflix)
- Evening auto schedule (ramp → night shield → morning fade)
- Hold **MUTE** ~1 s → quick panel (Off / Auto / Soft / Medium / Strong / Candle)
- Short MUTE still mutes normally
- Boot persistence
- Status screen with live setup indicators
- Pure Kotlin, **zero dependencies**, ~0.63 MB

---

## Setup (~3 minutes)

TV and PC on the same Wi‑Fi. Enable wireless debugging on the TV. Download both assets into one folder, then:

```powershell
.\install.ps1 -Ip YOUR_TV_IP
```

Or follow the manual ADB steps in [README.md](../../blob/main/README.md).

**Accessibility:** required for mute-hold *over other apps*. The script **appends** to your existing services — it does not replace them. Prefer not to? Use the **Warm Dusk Panel** home-row entry instead.

---

## Known limitations (preview on purpose)

| Limitation | Status |
|---|---|
| ADB setup required | Guided web installer is post-gate |
| No solar / custom colors | Pro / store scope |
| Mute keycodes vary by remote | Device reports welcome; learn-mode planned |
| Fire TV | Same APK should sideload; mute behavior unconfirmed |

---

## Tested so far

| Device | Overlay | Mute-hold | Reboot | Notes |
|---|---|---|---|---|
| Sony Bravia XR 77″ OLED (Google TV) | ✅ Netflix | ✅ | ✅ auto-return <90 s | Full 8-point test passed 2026-07-09; 32-bit userspace |

Full matrix → [COMPATIBILITY.md](../../blob/main/COMPATIBILITY.md)

---

## Report your device

Please report failures **and** successes. The app has no network permission and never phones home; these channels exist because reporting is the only way we hear you.

- Failure → [setup-failure form](../../issues/new?template=setup-fail.yml)
- Success → [device report](../../issues/new?template=device-report.yml)
- Private email → `feedback@warmdusk.com` · [prefilled `SETUP FAIL — <your TV model>` email](mailto:feedback@warmdusk.com?subject=SETUP%20FAIL%20%E2%80%94%20%3Cyour%20TV%20model%3E&body=TV%20brand%2Fmodel%3A%0AAndroid%2FGoogle%20TV%20version%3A%0AStep%20reached%3A%0AExact%20error%20%28paste%20verbatim%29%3A%0ANetwork%20notes%20%28optional%29%3A)

---

## Privacy

No network permission. No analytics. No accounts. No ads.
The accessibility service reads only the trigger key and D-pad presses while the panel is open — and has nowhere to send anything.
