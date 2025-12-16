# Aria Volume Control 🎵

A beautiful Flutter application that provides a floating volume control overlay for Android devices. Perfect for devices with broken physical volume buttons!

## Features ✨

- **Draggable Floating Button**: Move the volume control anywhere on your screen
- **Beautiful Glass Morphism UI**: Modern, elegant design matching your reference image
- **Vertical Volume Slider**: Intuitive MAX/MIN labeled slider
- **System-wide Access**: Control volume from any app
- **Multiple Volume Types**: Supports media, call, notification, and touch control sounds
- **Smooth Animations**: Elegant expand/collapse transitions
- **Always Accessible**: Overlay stays on top of all apps

## Screenshots 📱

The app features:
- A circular floating button with orange gradient
- Expandable glass-morphism panel with vertical slider
- Large background volume percentage display
- Expand/collapse action buttons

## Installation 🚀

### Prerequisites
- Flutter SDK (3.10.0 or higher)
- Android device (API level 23+)
- Android Studio or VS Code with Flutter extension

### Setup Steps

1. **Clone or navigate to the project**
   ```bash
   cd c:\Users\subas\OneDrive\Desktop\volume
   ```

2. **Get dependencies**
   ```bash
   flutter pub get
   ```

3. **Connect your Android device**
   - Enable USB debugging
   - Connect via USB

4. **Run the app**
   ```bash
   flutter run
   ```

## Usage 📖

1. **Grant Permissions**
   - On first launch, the app will request "Display over other apps" permission
   - This is required for the floating overlay to work
   - Go to Settings → Apps → Aria → Display over other apps → Allow

2. **Start the Overlay**
   - Tap "Start Floating Button" in the main app
   - A circular orange button will appear on your screen

3. **Control Volume**
   - **Tap** the floating button to expand the volume control panel
   - **Drag** the vertical slider to adjust volume
   - **Tap collapse icon** to minimize back to floating button
   - **Drag** the button anywhere on screen while collapsed

4. **Stop the Overlay**
   - Open the Aria app from your launcher
   - Tap "Stop Floating Button"

## Technical Details 🔧

### Dependencies
- `flutter_overlay_window`: System overlay functionality
- `flutter_volume_controller`: Volume control API
- `glass_kit`: Glass morphism effects

### Key Features Implementation
- **Draggable overlay** with `enableDrag: true`
- **Dynamic resizing** between collapsed (65x65) and expanded (280x520) states
- **Custom slider thumb** with orange indicator dot
- **Vertical slider** using `RotatedBox` widget
- **Fade animations** for smooth transitions

## Permissions Required 📋

The app requires the following Android permissions:
- `SYSTEM_ALERT_WINDOW`: Display overlay on top of other apps
- `FOREGROUND_SERVICE`: Keep the overlay service running

These are automatically declared in AndroidManifest.xml.

## Troubleshooting 🔍

### Overlay not showing
1. Check if "Display over other apps" permission is granted
2. Try restarting the app
3. Make sure you tapped "Start Floating Button"

### Can't drag the button
- The button is draggable only when collapsed (small circular button)
- When expanded, use the collapse icon to minimize first

### Volume not changing
1. Ensure your device allows apps to control volume
2. Check if the app has necessary permissions
3. Try adjusting volume manually first to initialize the system

## Project Structure 📁

```
lib/
├── main.dart           # Main app with controls
├── overlay_entry.dart  # Floating overlay UI
android/
└── app/src/main/
    └── AndroidManifest.xml  # Permissions configuration
```

## Customization 🎨

You can customize the appearance in `overlay_entry.dart`:

- **Colors**: Modify the gradient colors for button and panel
- **Size**: Adjust overlay dimensions in resize calls
- **Blur**: Change the `blur` parameter in GlassContainer
- **Animation**: Modify animation duration in AnimationController

## Building for Release 📦

```bash
flutter build apk --release
```

The APK will be available at:
`build/app/outputs/flutter-apk/app-release.apk`

## Known Limitations ⚠️

- Android only (iOS doesn't support system overlays)
- Requires API level 23+ (Android 6.0+)
- Some launchers may restrict overlay functionality
- Battery optimization may affect the overlay on some devices

## Support 💬

If you encounter any issues:
1. Check permissions in Android settings
2. Ensure you're running on a physical Android device (not emulator)
3. Restart the app and try again

## License 📄

This project is created for personal use to solve the broken volume button issue.

---

**Developed with ❤️ using Flutter**
