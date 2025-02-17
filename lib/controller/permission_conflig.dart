import 'dart:io';

import 'package:flutter/services.dart';
import 'package:flutter_overlay_window/flutter_overlay_window.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:touch_full_screenshot/view/home/bubble/custom_bubble.dart';

Future<void> checkOverlayPermission() async {
  if (await Permission.systemAlertWindow.isDenied) {
    await Permission.systemAlertWindow.request();
  }
}

Future<void> requestNotificationPermission() async {
  // Kiểm tra quyền thông báo
  if (await Permission.notification.isGranted) {
    print("Quyền thông báo đã được cấp.");
  } else {
    // Yêu cầu quyền thông báo
    PermissionStatus status = await Permission.notification.request();
    if (status.isGranted) {
      print("Quyền thông báo đã được cấp.");
    } else if (status.isDenied) {
      print("Quyền thông báo đã bị từ chối.");
    } else if (status.isPermanentlyDenied) {
      print(
          "Quyền thông báo bị từ chối vĩnh viễn. Hướng dẫn người dùng cấp quyền trong cài đặt.");
      await openAppSettings();
    }
  }
}

Future<void> requestOverlayPermission() async {
  if (!await FlutterOverlayWindow.isPermissionGranted()) {
    await FlutterOverlayWindow.requestPermission();
  }
}

Future<bool> requestManageExternalStoragePermission() async {
  if (Platform.isAndroid && await Permission.manageExternalStorage.isDenied) {
    return await Permission.manageExternalStorage.request().isGranted;
  }
  return true;
}

const platform = MethodChannel('screenshot_channel');
Future<void> takeScreenshot() async {
  try {
    await platform.invokeMethod('startScreenshot');
  } catch (e) {
    print("Failed to take screenshot: '${e}'.");
  }
}
