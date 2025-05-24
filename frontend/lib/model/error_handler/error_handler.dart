import 'dart:async';

import 'package:dio/dio.dart';
import 'package:frontend/model/response/error_response.dart';

final String unknownErr = "Unknown Error";
final String jwtExpired = "Session expired";
final String userDeleted = "User has been deleted, please create a new account";

sealed class Result<T> {
  const Result();

  factory Result.ok(T? value) => Ok(value);
  factory Result.unauthorized(String error) => UnauthorizedError(error);
  factory Result.parseErr() => ParseError();
  factory Result.badRequestErr(String error) => BadRequestError(error);
  factory Result.forbiddenErr(String error) => ForbiddenError(error);
  factory Result.internalServerErr(String error) => InternalServerError(error);
  factory Result.notFoundErr(String error) => NotFoundError(error);
  factory Result.timeoutErr() => TimeoutError();

  factory Result.networkErr(String error) => NetworkError(error);

  factory Result.err(String error) => Error(error);
}

final class Ok<T> extends Result<T> {
  const Ok(this.value);

  final T? value;
}

final class Error<T> extends Result<T> {
  const Error(this.error);

  final String error;
}

final class TimeoutError<T> extends Error<T> {
  TimeoutError() : super("Timeout");
}

final class NotFoundError<T> extends Error<T> {
  NotFoundError(super.error);
}

final class ForbiddenError<T> extends Error<T> {
  ForbiddenError(super.error);
}

final class ParseError<T> extends Error<T> {
  ParseError() : super("Parse error");
}

final class BadRequestError<T> extends Error<T> {
  BadRequestError(super.error);
}

final class UnauthorizedError<T> extends Error<T> {
  UnauthorizedError(super.error);
}

final class InternalServerError<T> extends Error<T> {
  InternalServerError(super.error);
}

final class NetworkError<T> extends Error<T> {
  const NetworkError(super.error);
}

Future<Result<T>> makeRequest<T>(
    int successStatusCode, Future<Response> Function() reqFunc,
    [T Function(dynamic)? parse]) async {
  try {
    final res = await reqFunc();
    if (res.statusCode == successStatusCode) {
      T? resp;
      if (parse != null) {
        resp = parse(res.data);
      }

      return Result.ok(resp);
    } else {
      switch (res.statusCode) {
        case 400:
          ErrorResponse errorRes = ErrorResponse.fromJson(res.data);

          return Result.badRequestErr(errorRes.error);
        case 401:
          return Result.unauthorized("Invalid email or password");
        case 403:
          if (res.data != null) {
            ErrorResponse errorRes = ErrorResponse.fromJson(res.data);

            return Result.forbiddenErr(errorRes.error);
          }
          return Result.forbiddenErr("Session expired");
        case 404:
          return Result.notFoundErr("URL doesn't exists");
        case 500:
          if (res.data != null) {
            ErrorResponse errorRes = ErrorResponse.fromJson(res.data);
            return Result.internalServerErr(errorRes.message);
          } else {
            return Result.internalServerErr(
                "Something's wrong, please try again later");
          }
        default:
          return Result.err(unknownErr);
      }
    }
  } on DioException catch (e) {
    return switch (e.type) {
      DioExceptionType.connectionTimeout => Result.timeoutErr(),
      DioExceptionType.sendTimeout => Result.timeoutErr(),
      DioExceptionType.receiveTimeout => Result.timeoutErr(),
      DioExceptionType.connectionError =>
        Result.networkErr("Failed to connect to server"),
      _ => Result.err(e.message ?? "Unknown error")
    };
  }
}
