import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:frontend/model/error_handler/error_handler.dart';
import 'package:frontend/model/pagination_query_params.dart';
import 'package:frontend/model/request/create_review_request.dart';
import 'package:frontend/model/response/list_response.dart';
import 'package:frontend/model/reviews.dart';
import 'package:http/http.dart' as http;

abstract interface class IReviewService {
  Future<Result<ListData<Reviews>>> getReviews(
      String token, int petDaycareId, PaginationQueryParams pagination);
  Future<void> createReview(
      String token, int petDaycareId, CreateReviewRequest reqBody);
  Future<void> deleteReview(String token, int petDaycareId);
}

class ReviewService implements IReviewService {
  @override
  Future<void> createReview(
      String token, int petDaycareId, CreateReviewRequest reqBody) {
    return makeRequest(201, () async {
      await dotenv.load();
      final String host = dotenv.env["HOST"]!;
      var res = await http.post(
        Uri.parse("$host/$petDaycareId/reviews"),
        headers: {
          "Content-Type": "application/json; charset=UTF-8",
          "Authorization": "Bearer $token",
        },
        body: reqBody.toJson(),
      );

      return res;
    });
  }

  @override
  Future<void> deleteReview(String token, int petDaycareId) {
    return makeRequest(204, () async {
      await dotenv.load();
      final String host = dotenv.env["HOST"]!;
      var res = await http.delete(
        Uri.parse("$host/$petDaycareId/reviews"),
        headers: {"Authorization": "Bearer $token"},
      );

      return res;
    });
  }

  @override
  Future<Result<ListData<Reviews>>> getReviews(
      String token, int petDaycareId, PaginationQueryParams pagination) {
    return makeRequest(200, () async {
      await dotenv.load();
      final String host = dotenv.env["HOST"]!;
      var res = await http.delete(
        Uri.parse("$host/$petDaycareId/reviews")
            .replace(queryParameters: pagination.toMap()),
        headers: {"Authorization": "Bearer $token"},
      );

      return res;
    }, (res) => ListData.fromJson(res, Reviews.fromJson));
  }
}
