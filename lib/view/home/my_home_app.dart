import 'package:flutter/material.dart';
import 'package:flutter_overlay_window/flutter_overlay_window.dart';
import 'package:get/get.dart';
import 'package:touch_full_screenshot/controller/permission_conflig.dart';
import 'package:touch_full_screenshot/view/project/list_project.dart';
import 'package:touch_full_screenshot/view/record/recording_screen.dart';

class MyHomeApp extends StatefulWidget {
  const MyHomeApp({super.key});
  @override
  State<MyHomeApp> createState() => _MyHomeAppState();
}

class _MyHomeAppState extends State<MyHomeApp> {
  @override
  Widget build(BuildContext context) {
    final String? projectId = Get.arguments;
    return Scaffold(
      appBar: AppBar(title: const Text('HOME')),
      body: Center(
        child: Wrap(
          direction: Axis.vertical,
          children: [
            Text('Id: $projectId'),
            ElevatedButton(
                onPressed: () {
                  Get.to(() => const ListProject());
                },
                child: const Text('SETTING')),
            const SizedBox(height: 10.0),
            ElevatedButton(
              onPressed: () async {
                if (await FlutterOverlayWindow.isActive()) return;
                await FlutterOverlayWindow.showOverlay(
                  enableDrag: true,
                  flag: OverlayFlag.defaultFlag,
                  visibility: NotificationVisibility.visibilityPublic,
                  positionGravity: PositionGravity.none,
                  height: (MediaQuery.of(context).size.height * 0.2).toInt(),
                  startPosition: const OverlayPosition(-150, -150),
                );
              },
              child: const Text("Show Overlay"),
            ),
            ElevatedButton(
                onPressed: () async {
                  await FlutterOverlayWindow.closeOverlay();
                },
                child: Text('stopOverlay')),
            ElevatedButton(
                onPressed: () => Get.to(RecordingScreen()),
                child: const Text('Recording screen')),
            ElevatedButton(
                onPressed: () => takeScreenshot(), child: Text('screenshot'))
          ],
        ),
      ),
    );
  }
}
