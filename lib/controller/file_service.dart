import 'dart:convert';
import 'dart:io';
import 'package:dio/dio.dart' as dio;
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart' hide Response, FormData, MultipartFile;
import 'package:graphql_flutter/graphql_flutter.dart';
import 'package:image_picker/image_picker.dart';
import 'package:http_parser/http_parser.dart';
import '../controller/constant.dart'; // Import đường dẫn chính xác

class FileService {
  final Dio _dio = Dio();

  /// Hàm chọn file image từ thư viện ảnh
  Future<File?> pickFileFromLibrary() async {
    final picker = ImagePicker();
    final pickedFile = await picker.pickImage(source: ImageSource.gallery);
    if (pickedFile != null) {
      return File(pickedFile.path);
    } else {
      debugPrint("No file selected.");
      return null;
    }
  }

  /// Hàm upload file image
  Future<void> uploadFile({
    required String projectId,
    required File selectedFile,
    required String token,
  }) async {
    try {
      dio.MultipartFile data = await dio.MultipartFile.fromFile(
        selectedFile.path,
        contentType: MediaType('image', 'png'),
      );

      dio.FormData formData = dio.FormData.fromMap({
        "file": data,
      });

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
        // Xử lý phản hồi JSON
        final parsedData = response.data is String
            ? json.decode(response.data)
            : response.data;

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

        print("File upload success");
      } else {
        print("Fail to upload file");
      }
    } catch (e) {
      debugPrint("Error uploading file: $e");
    }
  }
}
