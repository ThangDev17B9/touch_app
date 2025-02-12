import 'dart:io';

import 'package:dash_bubble/dash_bubble.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:touch_full_screenshot/view/project/list_project.dart';
import 'package:touch_full_screenshot/view/record/recording_screen.dart';
import 'package:touch_full_screenshot/view/upload/upload_file_page.dart';

class MyHomeApp extends StatelessWidget {
  const MyHomeApp({super.key});

  static const platform = MethodChannel('screenshot_channel');

  Future<void> takeScreenshot() async {
    try {
      await platform.invokeMethod('startScreenshot');
    } on PlatformException catch (e) {
      print("Failed to take screenshot: '${e.message}'.");
    }
  }
  Future<bool> requestManageExternalStoragePermission() async {
    if (Platform.isAndroid && await Permission.manageExternalStorage.isDenied) {
      return await Permission.manageExternalStorage.request().isGranted;
    }
    return true;
  }
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
            ElevatedButton(
                onPressed: () {
                  DashBubble.instance.requestOverlayPermission();
                  DashBubble.instance.startBubble(
                    onTap: () {
                      requestManageExternalStoragePermission();
                      takeScreenshot();
                    },
                  );
                },
                child: const Text('MODE ON')),
            ElevatedButton(
                onPressed: () {
                  DashBubble.instance.stopBubble();
                },
                child: const Text('MODE OFF')),
            ElevatedButton(
                onPressed: () async {
                  requestManageExternalStoragePermission();
                  takeScreenshot();
                  },
                child: const Text('SCREENSHOT')),
            ElevatedButton(
                onPressed: () => Get.to(RecordingScreen()),
                child: const Text('Recording screen')),
            ElevatedButton(
                onPressed: () => Get.to(UploadFilePage(), arguments: projectId),
                child: const Text('UploadFile')),
          ],
        ),
      ),
    );
  }
}
