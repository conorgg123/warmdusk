# Compatibility matrix

Community-maintained results for **Warm Dusk Preview** (`com.warmdusk.tv.preview` · `v0.1.0-preview`).

Every row comes from a real device report. If you try the APK, please [open a device report](../../issues/new?template=device-report.yml) — even a “didn’t work” row helps the next person.

## Results

| Device | OS | ABI | Install | Overlay (DRM) | Mute-hold | Short mute | Reboot | Setup | Reporter | Date |
|---|---|---|---|---|---|---|---|---|---|---|
| Sony Bravia XR 77″ OLED (`BRAVIA 4K VH2`) | Google TV / Android 12 | armeabi-v7a | ✅ | ✅ Netflix | ✅ | ✅ | ✅ auto-return ~90 s | deploy script | maintainer | 2026-07-14 |

*Maintainer row: replacement artifact `D2966E50...3644`; full 8-point couch test over Netflix + adb service verification (overlay grant in use, accessibility entries appended with pre-existing ones preserved, filter service auto-returned after reboot without opening the app). Community rows append below.*

## Column meanings

| Column | Pass means |
|---|---|
| **Install** | APK installed (storage fallback OK if needed) |
| **Overlay (DRM)** | Warm tint visible over Netflix or another DRM app |
| **Mute-hold** | Hold MUTE ~1 s opens the panel over playing content |
| **Short mute** | Tap MUTE still mutes normally |
| **Reboot** | Filter returns after reboot without opening the app |
| **Setup** | How grants were applied (script / manual ADB / other) |

## Field notes (measured, not guessed)

- Some “4K flagship” TVs (including Bravia XR) are **32-bit** userspace — this APK is universal / no native libs, so ABI is not a blocker.
- TV `/data` partitions are often nearly full. The deploy script’s trim → uninstall-keep-data → clean-install chain is intentional.
- Fire TV remotes may lack MUTE or use different keycodes — report what you tried; learn-mode is planned for the store build.
- DRM apps black out screenshots; film the TV with a phone if you need proof of overlay.

## How to add a row

1. File a [device report](../../issues/new?template=device-report.yml), **or**
2. Comment on the seed thread with brand / model / OS + the five yes/no results above.

Maintainers fold confirmed reports into this table within a day or two during the seeding window.
