import 'dart:io';

import 'package:dio/dio.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:frontend/model/error_handler/error_handler.dart';
import 'package:frontend/model/pagination_query_params.dart';
import 'package:frontend/model/response/list_response.dart';
import 'package:frontend/model/transaction.dart';

abstract interface class ITransactionService {
  Future<Result<ListData<Transaction>>> getTransactions(
      String token, OffsetPaginationQueryParams pagination);
}

class TransactionService implements ITransactionService {
  @override
  Future<Result<ListData<Transaction>>> getTransactions(
      String token, OffsetPaginationQueryParams pagination) {
    return makeRequest(200, () async {
      await dotenv.load();
      final String host = dotenv.env["HOST"]!;

      final dio = Dio(BaseOptions(
        validateStatus: (status) {
          return status != null; // Accept all HTTP status codes
        },
      ));

      var res = await dio.get(
        "$host/transaction",
        options: Options(
          headers: {
            HttpHeaders.authorizationHeader: "Bearer $token",
          },
        ),
      );

      return res;
    }, (res) => ListData.fromJson(res, Transaction.fromJson));
  }
}
