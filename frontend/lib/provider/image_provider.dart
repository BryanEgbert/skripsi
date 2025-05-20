import 'dart:io';

import 'package:frontend/model/error_handler/error_handler.dart';
import 'package:frontend/model/response/token_response.dart';
import 'package:frontend/model/response/upload_image_response.dart';
import 'package:frontend/services/image_service.dart';
import 'package:frontend/utils/refresh_token.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'image_provider.g.dart';

@riverpod
class ImageState extends _$ImageState {
  @override
  Future<UploadImageResponse?> build() {
    return Future.value(null);
  }

  Future<void> upload(File image) async {
    state = AsyncLoading();

    TokenResponse? token;
    try {
      token = await refreshToken();
    } catch (e) {
      return Future.error(jwtExpired, StackTrace.current);
    }

    final service = ImageService();
    final res = await service.upload(token.accessToken, image);

    switch (res) {
      case Ok():
        state = AsyncData(res.value);
      case Error():
        return Future.error(res.error);
    }
  }
}
