import 'dart:io';

import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screen_recording/flutter_screen_recording.dart';
import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';

class RecordingScreen extends StatefulWidget {
  const RecordingScreen({Key? key}) : super(key: key);

  @override
  _RecordingScreenState createState() => _RecordingScreenState();
}

class _RecordingScreenState extends State<RecordingScreen> {
  bool isRecording = false;

  Future<void> startRecording() async {
    bool started = await FlutterScreenRecording.startRecordScreen("test");
    if (started) {
      setState(() {
        isRecording = true;
      });
    }
  }

  Future<void> stopRecording() async {
    // Dừng ghi màn hình và lấy đường dẫn video
    String videoPath = await FlutterScreenRecording.stopRecordScreen;

    if (videoPath != null && videoPath.isNotEmpty) {
      setState(() {
        isRecording = false;
      });

      try {
        // Đường dẫn mặc định nơi video được lưu
        Directory appDocDir = await getApplicationDocumentsDirectory();
        String recordedFilePath = "${appDocDir.path}/test.mp4";

        // Hiển thị trình chọn thư mục hoặc đường dẫn để lưu
        String? selectedPath = await FilePicker.platform.getDirectoryPath();

        if (selectedPath != null) {
          // Tạo đường dẫn mới tại vị trí mà người dùng đã chọn
          String newFilePath = join(selectedPath, "recorded_video.mp4");

          // Di chuyển file đến vị trí mới
          File recordedFile = File(recordedFilePath);
          if (await recordedFile.exists()) {
            await recordedFile.copy(newFilePath);

            // Thông báo thành công
            ScaffoldMessenger.of(context as BuildContext).showSnackBar(SnackBar(
              content: Text("Video saved to $newFilePath"),
            ));
          } else {
            ScaffoldMessenger.of(context as BuildContext).showSnackBar(SnackBar(
              content: Text("Recorded file not found!"),
            ));
          }
        } else {
          // Người dùng hủy chọn thư mục
          ScaffoldMessenger.of(context as BuildContext).showSnackBar(SnackBar(
            content: Text("No directory selected!"),
          ));
        }
      } catch (e) {
        // Xử lý lỗi
        ScaffoldMessenger.of(context as BuildContext).showSnackBar(SnackBar(
          content: Text("An error occurred: $e"),
        ));
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Screen Recorder')),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            ElevatedButton(
              onPressed: isRecording ? null : startRecording,
              child: const Text('Start Recording'),
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: isRecording ? stopRecording : null,
              child: const Text('Stop Recording'),
            ),
          ],
        ),
      ),
    );
  }
}
