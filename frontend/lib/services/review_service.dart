import 'dart:io';

import 'package:dio/dio.dart';
import 'package:firebase_remote_config/firebase_remote_config.dart';
import 'package:frontend/model/error_handler/error_handler.dart';
import 'package:frontend/model/pagination_query_params.dart';
import 'package:frontend/model/request/create_review_request.dart';
import 'package:frontend/model/response/list_response.dart';
import 'package:frontend/model/reviews.dart';

abstract interface class IReviewService {
  Future<Result<ListData<Reviews>>> getReviews(
      String token, int petDaycareId, OffsetPaginationQueryParams pagination);
  Future<Result<void>> createReview(
      String token, int petDaycareId, CreateReviewRequest reqBody);
  Future<void> deleteReview(String token, int petDaycareId);
}

class ReviewService implements IReviewService {
  @override
  Future<Result<void>> createReview(
      String token, int petDaycareId, CreateReviewRequest reqBody) {
    return makeRequest(201, () async {
      final String host =
          FirebaseRemoteConfig.instance.getString("backend_host");

      final dio = Dio(BaseOptions(
        validateStatus: (status) {
          return status != null; // Accept all HTTP status codes
        },
      ));

      var res = await dio.post(
        "http://$host/$petDaycareId/reviews",
        options: Options(
          headers: {
            "Content-Type": "application/json; charset=UTF-8",
            "Authorization": "Bearer $token",
          },
        ),
        data: reqBody.toJson(),
      );

      return res;
    });
  }

  @override
  Future<void> deleteReview(String token, int petDaycareId) {
    return makeRequest(204, () async {
      final String host =
          FirebaseRemoteConfig.instance.getString("backend_host");

      final dio = Dio(BaseOptions(
        validateStatus: (status) {
          return status != null; // Accept all HTTP status codes
        },
      ));

      var res = await dio.delete(
        "http://$host/$petDaycareId/reviews",
        options: Options(
          headers: {"Authorization": "Bearer $token"},
        ),
      );

      return res;
    });
  }

  @override
  Future<Result<ListData<Reviews>>> getReviews(
      String token, int petDaycareId, OffsetPaginationQueryParams pagination) {
    return makeRequest(200, () async {
      final String host =
          FirebaseRemoteConfig.instance.getString("backend_host");

      var dio = Dio(BaseOptions(
        validateStatus: (status) {
          return status != null; // Accept all HTTP status codes
        },
      ));

      final res = await dio.get(
        "http://$host/daycare/$petDaycareId/review",
        options: Options(
          headers: {
            HttpHeaders.authorizationHeader: "Bearer $token",
          },
        ),
      );

      return res;
    }, (res) => ListData.fromJson(res, Reviews.fromJson));
  }
}
