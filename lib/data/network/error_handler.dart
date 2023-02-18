import 'package:complete_advanced_flutter/data/network/failure.dart';
import 'package:dio/dio.dart';

enum ResponseStatus {
  success,
  noContent,
  badRequest,
  forbidden,
  unauthorised,
  notFound,
  internalServerError,
  unknown,
  connectTimeout,
  cancel,
  receiveTimeout,
  sendTimeout,
  cacheError,
  noInternetConnection,
  defaultError,
}

class ErrorHandler implements Exception {
  late Failure failure;

  ErrorHandler.handle(dynamic error) {
    if (error is DioError) {
      //Dio error so its error from response of the API
      failure = _handleError(error);
    } else {
      //Default error
      failure = ResponseStatus.defaultError.getFailure();
    }
  }

  Failure _handleError(DioError error) {
    print("Dio message: ${error.message}");
    print("Dio type: ${error.type}");
    print("Dio toString: ${error.toString()}");
    switch (error.type) {
      case DioErrorType.connectionTimeout:
        return ResponseStatus.connectTimeout.getFailure();
      case DioErrorType.sendTimeout:
        return ResponseStatus.sendTimeout.getFailure();
      case DioErrorType.receiveTimeout:
        return ResponseStatus.receiveTimeout.getFailure();
      case DioErrorType.badResponse:
        {
          int code = error.response!.statusCode as int;
          if (code == ResponseStatus.badRequest.statusCode) {
            return ResponseStatus.badRequest.getFailure();
          } else if (code == ResponseStatus.forbidden.statusCode) {
            return ResponseStatus.forbidden.getFailure();
          } else if (code == ResponseStatus.unauthorised.statusCode) {
            return ResponseStatus.unauthorised.getFailure();
          } else if (code == ResponseStatus.internalServerError.statusCode) {
            return ResponseStatus.internalServerError.getFailure();
          } else {
            return ResponseStatus.defaultError.getFailure();
          }
        }
      case DioErrorType.cancel:
        return ResponseStatus.cancel.getFailure();
      case DioErrorType.connectionError:
        return ResponseStatus.connectTimeout.getFailure();
      case DioErrorType.unknown:
        return ResponseStatus.unknown.getFailure();
      default:
        return ResponseStatus.defaultError.getFailure();
    }
  }
}

extension Code on ResponseStatus {
  int get statusCode {
    switch (this) {
      case ResponseStatus.success:
        return 200;
      case ResponseStatus.noContent:
        return 201;
      case ResponseStatus.badRequest:
        return 400;
      case ResponseStatus.forbidden:
        return 403;
      case ResponseStatus.unauthorised:
        return 401;
      case ResponseStatus.notFound:
        return 404;
      case ResponseStatus.internalServerError:
        return 500;
      case ResponseStatus.unknown:
        return -1;
      case ResponseStatus.connectTimeout:
        return -2;
      case ResponseStatus.cancel:
        return -3;
      case ResponseStatus.receiveTimeout:
        return -4;
      case ResponseStatus.sendTimeout:
        return -5;
      case ResponseStatus.cacheError:
        return -6;
      case ResponseStatus.noInternetConnection:
        return -7;
      default:
        return -1;
    }
  }
}

extension Message on ResponseStatus {
  String get message {
    switch (this) {
      case ResponseStatus.success:
        return "Success";
      case ResponseStatus.noContent:
        return "Success with no content";
      case ResponseStatus.badRequest:
        return "Failure. API rejected request";
      case ResponseStatus.forbidden:
        return "Failure. API rejected request";
      case ResponseStatus.unauthorised:
        return "Failure, user is not authorised";
      case ResponseStatus.notFound:
        return "Failure, API is not correct and not found";
      case ResponseStatus.internalServerError:
        return "Failure, crash happen in server side";
      case ResponseStatus.unknown:
        return "Something went wrong. Try again later!";
      case ResponseStatus.connectTimeout:
        return "Time out error. Try again later!";
      case ResponseStatus.cancel:
        return "Request was cancelled. Try again later!";
      case ResponseStatus.receiveTimeout:
        return "Time out error. Try again later!";
      case ResponseStatus.sendTimeout:
        return "Time out error. Try again later!";
      case ResponseStatus.cacheError:
        return "Cache error. Try again later!";
      case ResponseStatus.noInternetConnection:
        return "Please check your connection";
      default:
        return "Something went wrong. Try again later!";
    }
  }
}

extension GetFailure on ResponseStatus {
  Failure getFailure() => Failure(code: statusCode, message: message);
}
abstract class ApiInternalStatus {
  static const int success = 0;
  static const int failure = 1;
}