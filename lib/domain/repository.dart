import 'package:complete_advanced_flutter/data/network/failure.dart';
import 'package:complete_advanced_flutter/domain/model.dart';
import 'package:dartz/dartz.dart';
import '../data/request/request.dart';

abstract class Repository{

 Future<Either<Failure, Authentication>> login(LoginRequest loginRequest);
}