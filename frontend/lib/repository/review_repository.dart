import 'package:frontend/model/request/create_review_request.dart';
import 'package:frontend/model/reviews.dart';

abstract interface class IReviewRepository {
  Future<List<Reviews>> getReviews(int petDaycareId, int lastId, int pageSize);
  Future<void> createReview(
      String token, int petDaycareId, CreateReviewRequest reqBody);
  Future<void> deleteReview(String token, int petDaycareId);
}

class ReviewRepository implements IReviewRepository {
  @override
  Future<void> createReview(
      String token, int petDaycareId, CreateReviewRequest reqBody) {
    // TODO: implement createReview
    throw UnimplementedError();
  }

  @override
  Future<void> deleteReview(String token, int petDaycareId) {
    // TODO: implement deleteReview
    throw UnimplementedError();
  }

  @override
  Future<List<Reviews>> getReviews(int petDaycareId, int lastId, int pageSize) {
    // TODO: implement getReviews
    throw UnimplementedError();
  }
}
