import 'package:complete_advanced_flutter/data/data_source/remote_data_source.dart';
import 'package:complete_advanced_flutter/data/mapper/mapper.dart';
import 'package:complete_advanced_flutter/data/network/error_handler.dart';
import 'package:complete_advanced_flutter/data/network/failure.dart';
import 'package:complete_advanced_flutter/data/network/network_info.dart';
import 'package:complete_advanced_flutter/data/request/request.dart';
import 'package:complete_advanced_flutter/data/responses/responses.dart';
import 'package:complete_advanced_flutter/domain/model/model.dart';
import 'package:complete_advanced_flutter/domain/repository/repository.dart';
import 'package:dartz/dartz.dart';

class RepositoryImpl extends Repository {
  late RemoteDataSource _remoteDataSource;
  late NetworkInfo _networkInfo;

  RepositoryImpl(this._remoteDataSource, this._networkInfo);

  @override
  Future<Either<Failure, Authentication>> login(
      LoginRequest loginRequest) async {
    if (await _networkInfo.isConnected) {
      try {
        //Its safe to call the API
        final AuthenticationResponse response =
            await _remoteDataSource.login(loginRequest);
        if (response.status != null &&
            response.status == ApiInternalStatus.success) {
          // Return data
          // Return right
          return Right(response.toDomain());
        }

        // Return business error
        // Return left
        return Left(Failure(
          code: response.status ?? ApiInternalStatus.failure,
          message: response.message ?? ResponseStatus.defaultError.message,
        ));
      } catch (error) {
        return Left(ErrorHandler.handle(error).failure);
      }
    } else {
      //Return connection error
      // Return left
      return Left(ResponseStatus.noInternetConnection.getFailure());
    }
  }

  @override
  Future<Either<Failure, String>> forgotPassword(String email) async {
    if (await _networkInfo.isConnected) {
      try {
        // its safe to call API
        final response = await _remoteDataSource.forgotPassword(email);
        if (response.status == ApiInternalStatus.success) {
          // success
          // return right
          return Right(response.toDomain());
        } else {
          // failure
          // return left
          return Left(Failure(
            code: response.status ?? ResponseStatus.defaultError.statusCode,
            message: response.message ?? ResponseStatus.defaultError.message,
          ));
        }
      } catch (error) {
        return Left(ErrorHandler.handle(error).failure);
      }
    } else {
      // return network connection error
      // return left
      return Left(ResponseStatus.noInternetConnection.getFailure());
    }
  }
}
