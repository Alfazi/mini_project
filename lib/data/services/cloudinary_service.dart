import 'dart:io';
import 'package:cloudinary_flutter/cloudinary_context.dart';
import 'package:cloudinary_url_gen/cloudinary.dart';
import 'package:dio/dio.dart';

class CloudinaryService {
  static const String cloudName = 'dedzd8pts';
  static const String uploadPreset = 'profile_pictures';

  final Dio _dio = Dio();

  static void initialize() {
    CloudinaryContext.cloudinary = Cloudinary.fromCloudName(
      cloudName: cloudName,
    );
  }

  Future<String> uploadImage(File imageFile) async {
    try {
      final formData = FormData.fromMap({
        'file': await MultipartFile.fromFile(
          imageFile.path,
          filename: imageFile.path.split('/').last,
        ),
        'upload_preset': uploadPreset,
        'folder': 'profile_pictures',
      });

      final response = await _dio.post(
        'https://api.cloudinary.com/v1_1/$cloudName/image/upload',
        data: formData,
      );

      if (response.statusCode == 200) {
        return response.data['secure_url'];
      } else {
        throw Exception('Upload failed with status: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Failed to upload image: $e');
    }
  }
}
