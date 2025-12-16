import 'package:flutter/material.dart';
import 'package:flutter_overlay_window/flutter_overlay_window.dart';
import 'package:flutter_volume_controller/flutter_volume_controller.dart';

void main() {
  runApp(const MyApp());
}

// =====================
// MAIN APP - This is what runs when you tap the app icon
// =====================
class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      debugShowCheckedModeBanner: false,
      home: HomePage(),
    );
  }
}

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  bool running = false;

  Future<void> startOverlay() async {
    // Step 1: Check if we have permission to show overlay
    final granted = await FlutterOverlayWindow.isPermissionGranted();
    if (!granted) {
      await FlutterOverlayWindow.requestPermission();
      return;
    }

    // Step 2: Show the floating button overlay
    await FlutterOverlayWindow.showOverlay(
      enableDrag: true,
      width: 300, // Wide enough for both small and expanded view
      height: 300,
      overlayTitle: "Volume Control",
      overlayContent: "Floating volume button",
      alignment: OverlayAlignment.centerRight,
      flag: OverlayFlag.defaultFlag,
      visibility: NotificationVisibility.visibilityPublic,
    );

    setState(() => running = true);
  }

  Future<void> stopOverlay() async {
    await FlutterOverlayWindow.closeOverlay();
    setState(() => running = false);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Volume Control"),
        backgroundColor: Colors.deepOrange,
        centerTitle: true,
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(Icons.volume_up, size: 80, color: Colors.deepOrange),
            const SizedBox(height: 20),
            const Text(
              "Floating Volume Control",
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 40),
            ElevatedButton(
              onPressed: running ? stopOverlay : startOverlay,
              style: ElevatedButton.styleFrom(
                backgroundColor: running ? Colors.red : Colors.deepOrange,
                padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 16),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(30),
                ),
              ),
              child: Text(
                running ? "Stop Floating Button" : "Start Floating Button",
                style: const TextStyle(fontSize: 16, color: Colors.white),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// =====================
// OVERLAY ENTRY POINT - This runs in the overlay window
// =====================
@pragma("vm:entry-point")
void overlayMain() {
  runApp(const OverlayApp());
}

class OverlayApp extends StatelessWidget {
  const OverlayApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      debugShowCheckedModeBanner: false,
      home: FloatingBubble(),
    );
  }
}

// =====================
// FLOATING BUBBLE - The draggable button and volume panel
// =====================
class FloatingBubble extends StatefulWidget {
  const FloatingBubble({super.key});

  @override
  State<FloatingBubble> createState() => _FloatingBubbleState();
}

class _FloatingBubbleState extends State<FloatingBubble> {
  bool expanded = false; // Are we showing the volume panel?
  double volume = 0.5; // Current volume level (0.0 to 1.0)

  @override
  void initState() {
    super.initState();
    loadVolume();
  }

  // Load the current system volume
  Future<void> loadVolume() async {
    final v = await FlutterVolumeController.getVolume();
    setState(() => volume = v ?? 0.5);
  }

  // Update the system volume
  Future<void> setVolume(double v) async {
    setState(() => volume = v);
    await FlutterVolumeController.setVolume(v);
  }

  @override
  Widget build(BuildContext context) {
    // Show expanded panel or collapsed button
    return expanded ? buildExpandedPanel() : buildCollapsedButton();
  }

  // Small circular button
  Widget buildCollapsedButton() {
    return Material(
      color: Colors.transparent,
      child: Container(
        width: 300,
        height: 300,
        alignment: Alignment.center,
        child: GestureDetector(
          onTap: () {
            // When tapped, show the volume panel
            setState(() => expanded = true);
          },
          child: Container(
            width: 70,
            height: 70,
            decoration: BoxDecoration(
              color: Colors.deepOrange,
              shape: BoxShape.circle,
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.3),
                  blurRadius: 10,
                  spreadRadius: 2,
                ),
              ],
            ),
            child: const Icon(
              Icons.volume_up,
              color: Colors.white,
              size: 36,
            ),
          ),
        ),
      ),
    );
  }

  // Volume control panel
  Widget buildExpandedPanel() {
    return Material(
      color: Colors.transparent,
      child: Container(
        width: 300,
        height: 300,
        alignment: Alignment.center,
        child: Container(
          width: 280,
          padding: const EdgeInsets.all(20),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(20),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.3),
                blurRadius: 15,
              ),
            ],
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              // Title
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text(
                    "Volume Control",
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: Colors.deepOrange,
                    ),
                  ),
                  IconButton(
                    onPressed: () {
                      // Close the panel, show button again
                      setState(() => expanded = false);
                    },
                    icon: const Icon(Icons.close),
                    color: Colors.deepOrange,
                  ),
                ],
              ),
              const SizedBox(height: 20),
              
              // Volume icon
              const Icon(
                Icons.volume_up,
                size: 48,
                color: Colors.deepOrange,
              ),
              const SizedBox(height: 10),
              
              // Volume percentage
              Text(
                "${(volume * 100).round()}%",
                style: const TextStyle(
                  fontSize: 32,
                  fontWeight: FontWeight.bold,
                  color: Colors.deepOrange,
                ),
              ),
              const SizedBox(height: 20),
              
              // Volume slider
              SliderTheme(
                data: SliderTheme.of(context).copyWith(
                  activeTrackColor: Colors.deepOrange,
                  inactiveTrackColor: Colors.deepOrange.withOpacity(0.3),
                  thumbColor: Colors.deepOrange,
                  thumbShape: const RoundSliderThumbShape(enabledThumbRadius: 12),
                  overlayColor: Colors.deepOrange.withOpacity(0.2),
                ),
                child: Slider(
                  value: volume,
                  min: 0.0,
                  max: 1.0,
                  onChanged: setVolume,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
