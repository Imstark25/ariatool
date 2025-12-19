import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_volume_controller/flutter_volume_controller.dart';
import 'package:permission_handler/permission_handler.dart';

// Note: Ensure you have permission_handler in pubspec.yaml for easy permission management
// or use a MethodChannel to check, but permission_handler is standard.
// If not present, I can use a simple intent to open settings or assume the user granted it.
// The previous code used flutter_overlay_window which handled permissions.
// Native overlay requires SYSTEM_ALERT_WINDOW.

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
  static const platform = MethodChannel('volume_overlay');
  bool running = false;

  Future<void> startOverlay() async {
    // Check overlay permission using permission_handler
    var status = await Permission.systemAlertWindow.status;
    if (!status.isGranted) {
      status = await Permission.systemAlertWindow.request();
      if (!status.isGranted) {
        print("Overlay permission denied");
        // Optionally show a dialog or snackbar
        return;
      }
    }

    try {
      await platform.invokeMethod('showOverlay');
      setState(() => running = true);
    } on PlatformException catch (e) {
      print("Failed to show overlay: '${e.message}'.");
    }
  }

  Future<void> stopOverlay() async {
    try {
      await platform.invokeMethod('hideOverlay');
      setState(() => running = false);
    } on PlatformException catch (e) {
      print("Failed to hide overlay: '${e.message}'.");
    }
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
             const Text(
              "Native Volume Overlay",
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 20),
            const Padding(
              padding: EdgeInsets.symmetric(horizontal: 32.0),
              child: Text(
                "Make sure 'Display over other apps' permission is granted for this app in Settings.",
                textAlign: TextAlign.center,
                style: TextStyle(color: Colors.grey),
              ),
            ),
             const SizedBox(height: 40),
            ElevatedButton(
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
          ],
        ),
      ),
    );
  }
}
