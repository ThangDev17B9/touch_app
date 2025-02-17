import 'dart:convert';
import 'dart:io';

import 'package:dio/dio.dart' as dio;
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart' hide Response, FormData, MultipartFile;
import 'package:graphql_flutter/graphql_flutter.dart';
import 'package:image_picker/image_picker.dart';
import 'package:http_parser/http_parser.dart';
import 'package:touch_full_screenshot/controller/constant.dart';

class UploadFilePage extends StatefulWidget {
  const UploadFilePage({super.key});

  @override
  _UploadFilePageState createState() => _UploadFilePageState();
}

class _UploadFilePageState extends State<UploadFilePage> {
  final Dio _dio = Dio();
  File? _selectedFile;

  Future<void> pickFileFromLibrary() async {
    final picker = ImagePicker();
    final pickedFile = await picker.pickImage(source: ImageSource.gallery);
    if (pickedFile != null) {
      setState(() {
        _selectedFile = File(pickedFile.path);
      });
    } else {
      debugPrint("No file selected.");
    }
  }

  Future<void> uploadFile() async {
    String projectId = Get.arguments;
    if (_selectedFile == null) {
      print("Please select a file first");
      return;
    }

    try {
      String token = Constant.token;
      dio.MultipartFile data = await dio.MultipartFile.fromFile(
          _selectedFile!.path,
          contentType: MediaType('image', 'png'));
      dio.FormData formData = dio.FormData.fromMap({"file": data});

      dio.Response response = await _dio.post(
        Constant.postFile,
        data: formData,
        options: dio.Options(
          headers: {
            "Authorization": "Bearer $token",
          },
        ),
      );

      if (response.statusCode == 200 || response.statusCode == 201) {
        try {
          // convert JSON thành Map
          final parsedData = response.data is String
              ? json.decode(response.data)
              : response.data;

          // Lấy id, storage, filenameDownload từ key "data"
          final data = parsedData['data'];
          final String id = data['id'];
          final String storage = data['storage'];
          final String filenameDownload = data['filename_download'];
          String query = """
          mutation CreateProjectsFilesItem(\$projectId: String!, \$id: ID!, \$storage: String!, \$filenameDownload: String!) {
          create_projects_files_item(
            data: {
              projects_id: \$projectId,
              directus_files_id: {
                id: \$id,
                storage: \$storage,
                filename_download: \$filenameDownload
              }
            }) {
              id
          }
        }
          """;
          print('Project ID: $projectId');
          print('ID: $id');
          print('Storage: $storage');
          print('Filename Download: $filenameDownload');
          final MutationOptions options = MutationOptions(
            document: gql(query),
            variables: {
              "projectId": projectId,
              "id": id,
              "storage": storage,
              "filenameDownload": filenameDownload,
            },
          );
          final HttpLink apiPostInforFile = HttpLink(Constant.postInforFile);
          final AuthLink authLink =
              AuthLink(getToken: () => 'Bearer ${Constant.token}');
          final Link link = authLink.concat(apiPostInforFile);
          final GraphQLClient client =
              GraphQLClient(link: link, cache: GraphQLCache());
          final QueryResult result = await client.mutate(options);

          if (result.hasException) {
            print('GraphQL Error: ${result.exception.toString()}');
          } else {
            print('Mutation success: ${result.data}');
          }
        } catch (e) {
          print('Error parsing JSON: $e');
        }
        print("File upload success");
      } else {
        print("fail to upload file");
      }
    } catch (e) {
      debugPrint("Error uploading file: $e");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Upload File"),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            ElevatedButton(
              onPressed: pickFileFromLibrary,
              child: const Text("Pick File from Library"),
            ),
            if (_selectedFile != null)
              Text("Selected File: ${_selectedFile!.path.split('/').last}"),
            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: uploadFile,
              child: const Text("Upload File"),
            ),
          ],
        ),
      ),
    );
  }
}
