import 'package:complete_advanced_flutter/app/app_prefs.dart';
import 'package:complete_advanced_flutter/data/data_source/remote_data_source.dart';
import 'package:complete_advanced_flutter/data/network/app_api.dart';
import 'package:complete_advanced_flutter/data/network/dio_factory.dart';
import 'package:complete_advanced_flutter/data/network/network_info.dart';
import 'package:complete_advanced_flutter/data/repository/repository_impl.dart';
import 'package:get_it/get_it.dart';
import 'package:internet_connection_checker/internet_connection_checker.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../domain/usecase/forgot_password_usecase.dart';
import '../domain/usecase/login_use_case.dart';
import '../presentation/forgot_password/forgot_password_viewmodel.dart';
import '../presentation/login/login_viewmodel.dart';

final GetIt instance = GetIt.instance;

//Dependency injection Instance
Future<void> initAppModule() async {
  final sharedPrefs = await SharedPreferences.getInstance();
  // Shared Preferences instance
  instance.registerLazySingleton<SharedPreferences>(() => sharedPrefs);

  //AppPreferences instance
  instance.registerLazySingleton<AppPreferences>(
      () => AppPreferences(instance<SharedPreferences>()));
  //instance.resetLazySingleton(instance: ()=> AppPreferences(instance<SharedPreferences>()));

  //NetworkInfoImpl instance
  instance.registerLazySingleton<NetworkInfoImpl>(
      () => NetworkInfoImpl(InternetConnectionChecker()));

  //Dio factory
  instance.registerLazySingleton<DioFactory>(
      () => DioFactory(instance<AppPreferences>()));

  //AppServiceClient
  final dio = await instance<DioFactory>().getDio();
  instance.registerLazySingleton<AppServiceClient>(() => AppServiceClient(dio));

  //Remote Datasource
  instance.registerLazySingleton<RemoteDataSourceImplementer>(
      () => RemoteDataSourceImplementer(instance<AppServiceClient>()));

  //Repository instance
  instance.registerLazySingleton<RepositoryImpl>(() => RepositoryImpl(
      instance<RemoteDataSourceImplementer>(), instance<NetworkInfoImpl>()));
}

initLoginModule() {
  //Check initLoginModule
  if (!GetIt.I.isRegistered<LoginUseCase>()) {
    //LoginUseCase instance
    instance
        .registerLazySingleton<LoginUseCase>(() => LoginUseCase(instance<RepositoryImpl>()));

    //LoginViewModel instance
    instance.registerLazySingleton<LoginViewModel>(
        () => LoginViewModel(instance<LoginUseCase>()));
  }
}

initForgotPasswordModule() {
  if (!GetIt.I.isRegistered<ForgotPasswordUseCase>()) {
    instance.registerFactory<ForgotPasswordUseCase>(
            () => ForgotPasswordUseCase(instance<RepositoryImpl>()));
    instance.registerFactory<ForgotPasswordViewModel>(
            () => ForgotPasswordViewModel(instance<ForgotPasswordUseCase>()));
  }
}