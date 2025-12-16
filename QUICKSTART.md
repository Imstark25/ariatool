# Quick Start Guide 🚀

## Run the App (5 Simple Steps)

### 1. Connect Your Android Phone
- Enable **Developer Options** on your phone
- Enable **USB Debugging**
- Connect to your computer via USB

### 2. Check Device Connection
```bash
flutter devices
```
You should see your device listed.

### 3. Run the App
```bash
flutter run
```

### 4. Grant Permission
When the app opens:
1. Tap **"Start Floating Button"**
2. Phone will ask for **"Display over other apps"** permission
3. **Allow** the permission
4. Go back to the app
5. Tap **"Start Floating Button"** again

### 5. Use the Floating Control
- ✅ **Floating button appears** on your screen
- 👆 **Tap it** to expand the volume control
- 🎚️ **Drag the slider** to adjust volume
- 📍 **Drag the button** anywhere when collapsed
- 🔽 **Tap collapse icon** to minimize

## Features Overview

| Feature | Description |
|---------|-------------|
| 🎯 Draggable | Move button anywhere on screen |
| 🎵 Volume Control | Vertical slider with MAX/MIN labels |
| ✨ Glass Design | Beautiful modern UI |
| 🔄 Expand/Collapse | Smooth animations |
| 📱 System-wide | Works in any app |

## Important Notes

⚠️ **Permissions Required:**
- Display over other apps (required for overlay)
- The app will request this automatically

📱 **Device Requirements:**
- Android 6.0 or higher
- Physical Android device (emulators may not support overlays)

🔧 **Troubleshooting:**

**Button not showing?**
- Check permissions in: Settings → Apps → Aria → Display over other apps

**Can't drag?**
- Button is only draggable when collapsed (small circle)
- When expanded, tap the collapse icon first

**Volume not changing?**
- Make sure you're on a real Android device
- Some system volume restrictions may apply

## Build APK for Installation

```bash
flutter build apk --release
```

APK location: `build/app/outputs/flutter-apk/app-release.apk`

Transfer this file to your phone and install it!

---

**Need help?** Check the full [README.md](README.md) for detailed information.
