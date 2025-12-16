import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_overlay_window/flutter_overlay_window.dart';
import 'package:flutter_volume_controller/flutter_volume_controller.dart';

void main() {
  runApp(const MyApp());
}

/// =====================
/// MAIN APP
/// =====================
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
    if (!await FlutterOverlayWindow.isPermissionGranted()) {
      await FlutterOverlayWindow.requestPermission();
      return;
    }

    await FlutterOverlayWindow.showOverlay(
      enableDrag: true,
      width: 48,
      height: 48,
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
        child: ElevatedButton(
          onPressed: running ? stopOverlay : startOverlay,
          style: ElevatedButton.styleFrom(
            backgroundColor: running ? Colors.redAccent : Colors.deepOrange,
            padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 16),
          ),
          child: Text(
            running ? "Stop Floating Button" : "Start Floating Button",
            style: const TextStyle(color: Colors.white),
          ),
        ),
      ),
    );
  }
}

/// =====================
/// OVERLAY ENTRY
/// =====================
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
      home: FloatingOverlay(),
    );
  }
}

/// =====================
/// FLOATING OVERLAY
/// =====================
class FloatingOverlay extends StatefulWidget {
  const FloatingOverlay({super.key});

  @override
  State<FloatingOverlay> createState() => _FloatingOverlayState();
}

class _FloatingOverlayState extends State<FloatingOverlay> {
  bool expanded = false;
  double volume = 0.5;
  Timer? autoHideTimer;

  @override
  void initState() {
    super.initState();
    FlutterVolumeController.getVolume()
        .then((v) => setState(() => volume = v ?? 0.5));
  }

  void startAutoHideTimer() {
    autoHideTimer?.cancel();
    autoHideTimer = Timer(const Duration(seconds: 5), collapseAndSnap);
  }

  @override
  Widget build(BuildContext context) {
    return expanded ? expandedPanel() : collapsedBubble();
  }

  /// 🟠 TINY CHAT-HEAD STYLE BUTTON
  Widget collapsedBubble() {
    return Material(
      color: Colors.transparent,
      child: Center(
        child: GestureDetector(
          onTap: () async {
            await FlutterOverlayWindow.resizeOverlay(300, 240, false);
            startAutoHideTimer();
            setState(() => expanded = true);
          },
          child: Container(
            width: 48,
            height: 48,
            decoration: BoxDecoration(
              color: Colors.deepOrange,
              shape: BoxShape.circle,
              boxShadow: const [
                BoxShadow(color: Colors.black26, blurRadius: 8),
              ],
            ),
            child: const Icon(
              Icons.volume_up,
              size: 22,
              color: Colors.white,
            ),
          ),
        ),
      ),
    );
  }

  /// 🫧 GLASS-LIKE STATIC PANEL
  Widget expandedPanel() {
    return Material(
      color: Colors.transparent,
      child: Stack(
        children: [
          // Tap anywhere outside
          GestureDetector(
            onTap: collapseAndSnap,
            child: Container(color: Colors.transparent),
          ),

          Center(
            child: Container(
              width: 300,
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: Colors.white.withOpacity(0.92),
                borderRadius: BorderRadius.circular(24),
                boxShadow: const [
                  BoxShadow(color: Colors.black26, blurRadius: 20),
                ],
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text(
                        "Volume Control",
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          color: Colors.deepOrange,
                        ),
                      ),
                      GestureDetector(
                        onTap: collapseAndSnap,
                        child: const Icon(Icons.close,
                            color: Colors.deepOrange),
                      ),
                    ],
                  ),
                  const SizedBox(height: 20),
                  Icon(Icons.volume_up,
                      size: 36, color: Colors.deepOrange),
                  const SizedBox(height: 10),
                  Text(
                    "${(volume * 100).round()}%",
                    style: const TextStyle(
                        fontSize: 26, fontWeight: FontWeight.bold),
                  ),
                  Slider(
                    value: volume,
                    onChanged: (v) {
                      startAutoHideTimer();
                      setState(() => volume = v);
                      FlutterVolumeController.setVolume(v);
                    },
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  /// 📍 COLLAPSE + SNAP TO EDGE
  Future<void> collapseAndSnap() async {
    autoHideTimer?.cancel();
    await FlutterOverlayWindow.resizeOverlay(48, 48, true);
    await FlutterOverlayWindow.updateOverlayAlignment(
      OverlayAlignment.centerRight,
    );
    setState(() => expanded = false);
  }
}
