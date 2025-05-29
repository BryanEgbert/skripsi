import 'dart:io';

import 'package:dio/dio.dart';
import 'package:firebase_remote_config/firebase_remote_config.dart';
import 'package:frontend/model/error_handler/error_handler.dart';
import 'package:frontend/model/pagination_query_params.dart';
import 'package:frontend/model/response/list_response.dart';
import 'package:frontend/model/transaction.dart';

abstract interface class ITransactionService {
  Future<Result<Transaction>> getTransaction(String token, int transactionId);
  Future<Result<ListData<Transaction>>> getTransactions(
      String token, OffsetPaginationQueryParams pagination);
}

class TransactionService implements ITransactionService {
  @override
  Future<Result<ListData<Transaction>>> getTransactions(
      String token, OffsetPaginationQueryParams pagination) {
    return makeRequest(200, () async {
      final String host =
          FirebaseRemoteConfig.instance.getString("backend_host");

      final dio = Dio(BaseOptions(
        validateStatus: (status) {
          return status != null; // Accept all HTTP status codes
        },
      ));

      var res = await dio.get(
        "http://$host/transaction",
        queryParameters: pagination.toMap(),
        options: Options(
          headers: {
            HttpHeaders.authorizationHeader: "Bearer $token",
          },
        ),
      );

      return res;
    }, (res) => ListData.fromJson(res, Transaction.fromJson));
  }

  @override
  Future<Result<Transaction>> getTransaction(String token, int transactionId) {
    return makeRequest(200, () async {
      final String host =
          FirebaseRemoteConfig.instance.getString("backend_host");

      final dio = Dio(BaseOptions(
        validateStatus: (status) {
          return status != null; // Accept all HTTP status codes
        },
      ));

      var res = await dio.get(
        "http://$host/transaction/$transactionId",
        options: Options(
          headers: {
            HttpHeaders.authorizationHeader: "Bearer $token",
          },
        ),
      );

      return res;
    }, (res) => Transaction.fromJson(res));
  }
}
