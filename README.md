# Bing Daily Wallpaper for CleanYourTV

An ultra-lightweight Android TV companion app that automatically streams Microsoft Bing's official Daily Wallpaper into the [CleanYourTV](https://github.com/Gathin23/cleanyourtv) launcher.

Features a CleanYourTV **module card** ("Bing", caption "Daily Wallpaper" with an azure glow), where OK opens a photo preview with location/photographer credits and a manual **"Refresh Now"** button.

---

## Highlights

- **Direct Stream (Zero disk accumulation)**: Streams today's 1920x1080 JPEG directly into CleanYourTV's `wallpaper.jpg` in-place, generating 0 temporary files.
- **TV Boot Time Protection**: Does not execute on boot. It registers with Android's system `JobScheduler` and defers initial check until 10 minutes post-boot (0% CPU impact at startup).
- **Background Hot-Reloading**: CleanYourTV updates its background texture smoothly without needing a TV reboot or Home restart.
- **Zero Third-Party Dependencies**: Pure Android framework Java, compiled release APK is only **17 KB**.

---

## Permissions

| Permission | Why |
|---|---|
| `INTERNET` | Fetch today's image archive and 1080p photo from `bing.com`. |
| `RECEIVE_BOOT_COMPLETED` | Registers the periodic 24-hour JobScheduler task on device power-on. |
| `WRITE_SECURE_SETTINGS` | Write access to CleanYourTV's wallpaper content provider (`content://com.gathin.tvhome.theme/wallpaper.jpg`). |

*No telemetry, no tracking, no background services, no user accounts.*

---

## Quick Install (Prebuilt APK)

1. Download `app-release.apk` from [Releases](https://github.com/MdAsimKhan/bing-googletv-wallpaper/releases/latest).
2. Install over ADB:
   ```bash
   adb install -r app-release.apk
   adb shell pm grant com.gathin.bingwallpaper android.permission.WRITE_SECURE_SETTINGS
   ```
3. Open CleanYourTV Home. When prompted with **Show card**, select **Show**.

---

## Build from Source

Requirements: JDK 17 and Android SDK 34.

```bash
# Clone
git clone https://github.com/MdAsimKhan/bing-googletv-wallpaper.git
cd bing-googletv-wallpaper

# Windows
.\build-and-install.ps1 -TvHost <tv-ip>

# macOS / Linux
./build-and-install.sh <tv-ip>
```

---

## License

MIT License. Open source for the CleanYourTV community.
