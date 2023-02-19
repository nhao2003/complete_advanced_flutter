import 'package:complete_advanced_flutter/app/functions.dart';
import 'package:complete_advanced_flutter/data/network/failure.dart';
import 'package:complete_advanced_flutter/data/request/request.dart';
import 'package:complete_advanced_flutter/domain/model/model.dart';
import 'package:complete_advanced_flutter/domain/repository/repository.dart';
import 'package:complete_advanced_flutter/domain/usecase/base_use_case.dart';
import 'package:dartz/dartz.dart';

class LoginUseCase implements BaseUseCase<LoginUseCaseInput, Authentication> {
  late Repository _repository;

  LoginUseCase(this._repository);

  @override
  Future<Either<Failure, Authentication>> execute(
      LoginUseCaseInput input) async {
    DeviceInfo deviceInfo = await getDeviceDetails();
    return await _repository.login(
      LoginRequest(
        email: input.email,
        password: input.password,
        imei: deviceInfo.identifier,
        deviceType: deviceInfo.name,
      ),
    );
  }
}

class LoginUseCaseInput {
  late String email;
  late String password;

  LoginUseCaseInput({
    required this.email,
    required this.password,
  });
}
