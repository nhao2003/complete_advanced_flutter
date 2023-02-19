import 'package:complete_advanced_flutter/data/network/error_handler.dart';

class Failure {
  late int code;
  late String message;

  Failure({required this.code, required this.message});
}

class DefaultFailure extends Failure {
  DefaultFailure()
      : super(
            code: ResponseStatus.defaultError.statusCode,
            message: ResponseStatus.defaultError.message);
}
