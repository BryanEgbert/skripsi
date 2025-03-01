import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:frontend/model/response/error_response.dart';
import 'package:http/http.dart';

final Exception unknownException = Exception("Unknown Error");

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

  factory Result.networkErr(SocketException error) =>
      NetworkError(error.message);

  factory Result.err(Exception error) => Error(error.toString());
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
        resp = parse(jsonDecode(res.body) as Map<String, dynamic>);
      }

      return Result.ok(resp);
    } else {
      switch (res.statusCode) {
        case 400:
          ErrorResponse errorRes = ErrorResponse.fromJson(
              jsonDecode(res.body) as Map<String, dynamic>);

          return Result.badRequestErr(errorRes.message);
        case 401:
          return Result.unauthorized("Invalid email or password");
        case 403:
          return Result.forbiddenErr("Session expired");
        case 404:
          return Result.notFoundErr("URL doesn't exists");
        case 500:
          ErrorResponse errorRes = ErrorResponse.fromJson(
              jsonDecode(res.body) as Map<String, dynamic>);
          return Result.internalServerErr(errorRes.message);
        default:
          return Result.err(unknownException);
      }
    }
  } on SocketException catch (e) {
    return Result.networkErr(e);
  } on TimeoutException catch (_) {
    return Result.timeoutErr();
  } on Exception catch (e) {
    return Result.err(e);
  }
}
