import 'package:complete_advanced_flutter/data/data_source/local_data_source.dart';
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
  late LocalDataSourceImplementer _localDataSource;
  late NetworkInfo _networkInfo;
  RepositoryImpl(this._remoteDataSource,this._localDataSource, this._networkInfo);

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

  @override
  Future<Either<Failure, Authentication>> register(RegisterRequest registerRequest) async {
    if (await _networkInfo.isConnected) {
      try {
        // its safe to call API
        final response = await _remoteDataSource.register(registerRequest);
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


  @override
  Future<Either<Failure, HomeObject>> getHome() async {
    try {
      // get from cache
      print("Get home data from cache");
      final response = await _localDataSource.getHome();
      return Right(response.toDomain());
    } catch (cacheError) {
      // we have cache error so we should call API

      if (await _networkInfo.isConnected) {
        try {
          print("Get home data from API");
          // its safe to call the API
          final response = await _remoteDataSource.getHome();

          if (response.status == ApiInternalStatus.success) // success
              {
            // return data (success)
            // return right
            // save response to local data source
            _localDataSource.saveHomeToCache(response);
            return Right(response.toDomain());
          } else {
            print("Error when Get home data from cache");
            // return biz logic error
            // return left
            return Left(
                Failure(code: response.status ?? ApiInternalStatus.failure,
                    message: response.message ??
                        ResponseStatus.defaultError.message));
          }
        } catch (error) {
          return (Left(ErrorHandler
              .handle(error)
              .failure));
        }
      } else {
        // return connection error
        return Left(ResponseStatus.noInternetConnection.getFailure());
      }
    }
  }

  @override
  Future<Either<Failure, StoreDetails>> getStoreDetails() {
    // TODO: implement getStoreDetails
    throw UnimplementedError();
  }

  // @override
  // Future<Either<Failure, StoreDetails>> getStoreDetails() async {
  //   try {
  //     // get data from cache
  //
  //     final response = await _localDataSource.getStoreDetails();
  //     return Right(response.toDomain());
  //   } catch (cacheError) {
  //     if (await _networkInfo.isConnected) {
  //       try {
  //         final response = await _remoteDataSource.getStoreDetails();
  //         if (response.status == ApiInternalStatus.success) {
  //           _localDataSource.saveStoreDetailsToCache(response);
  //           return Right(response.toDomain());
  //         } else {
  //           return Left(Failure(
  //               code: response.status ?? ResponseStatus.defaultError.statusCode,
  //               message: response.message ??
  //                   ResponseStatus.defaultError.message));
  //         }
  //       } catch (error) {
  //         return Left(ErrorHandler
  //             .handle(error)
  //             .failure);
  //       }
  //     } else {
  //       ResponseStatus.noInternetConnection.getFailure();
  //     }
  //   }
  }
