import 'package:frontend/model/error_handler/error_handler.dart';
import 'package:frontend/model/request/create_review_request.dart';
import 'package:frontend/model/response/token_response.dart';
import 'package:frontend/provider/list_data_provider.dart';
import 'package:frontend/services/review_service.dart';
import 'package:frontend/utils/refresh_token.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'review_provider.g.dart';

@riverpod
class ReviewState extends _$ReviewState {
  @override
  Future<int> build() async {
    return Future.value(0);
  }

  Future<void> reset() async {
    state = AsyncData(0);
  }

  Future<void> addReview(int petDaycareId, CreateReviewRequest req) async {
    state = AsyncLoading();
    TokenResponse? token;
    try {
      token = await refreshToken();
    } catch (e) {
      state = AsyncError(jwtExpired, StackTrace.current);
      return;
    }

    final service = ReviewService();
    final res =
        await service.createReview(token!.accessToken, petDaycareId, req);

    switch (res) {
      case Ok():
        state = AsyncData(204);
        ref.invalidate(getReviewsProvider(petDaycareId));
      case Error():
        state = AsyncError(res.error, StackTrace.current);
    }
  }
}
