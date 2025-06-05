import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:frontend/model/response/token_response.dart';
import 'package:frontend/services/database_service.dart';
import 'package:frontend/utils/refresh_token.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'database_provider.g.dart';

@riverpod
Future<TokenResponse> getToken(Ref ref) async {
  try {
    await refreshAccessToken();
  } catch (e) {
    return Future.error(e.toString());
  }
  final dbService = DatabaseService();
  final res = await dbService.getToken();

  return res;
}
