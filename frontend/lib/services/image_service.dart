import 'dart:io';

import 'package:dio/dio.dart';
import 'package:firebase_remote_config/firebase_remote_config.dart';
import 'package:frontend/model/error_handler/error_handler.dart';
import 'package:frontend/model/response/upload_image_response.dart';

abstract interface class IImageService {
  Future<Result<UploadImageResponse>> upload(String token, File image);
}

class ImageService implements IImageService {
  @override
  Future<Result<UploadImageResponse>> upload(String token, File image) {
    return makeRequest(201, () async {
      final String host =
          FirebaseRemoteConfig.instance.getString("backend_host");

      final dio = Dio(BaseOptions(
        validateStatus: (status) {
          return status != null; // Accept all HTTP status codes
        },
      ));

      FormData formData = FormData.fromMap({
        "image": await MultipartFile.fromFile(
          image.path,
          filename: image.path.split("/").last,
        )
      });

      final res = await dio.post(
        "http://$host/image",
        options: Options(
          headers: {
            HttpHeaders.authorizationHeader: "Bearer $token",
            Headers.contentTypeHeader: Headers.multipartFormDataContentType,
          },
        ),
        data: formData,
      );

      return res;
    }, (res) => UploadImageResponse.fromJson(res));
  }
}
