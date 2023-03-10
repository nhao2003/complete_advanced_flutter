import 'package:complete_advanced_flutter/app/app_prefs.dart';
import 'package:complete_advanced_flutter/data/data_source/local_data_source.dart';
import 'package:complete_advanced_flutter/data/data_source/remote_data_source.dart';
import 'package:complete_advanced_flutter/data/network/app_api.dart';
import 'package:complete_advanced_flutter/data/network/dio_factory.dart';
import 'package:complete_advanced_flutter/data/network/network_info.dart';
import 'package:complete_advanced_flutter/data/repository/repository_impl.dart';
import 'package:complete_advanced_flutter/domain/usecase/register_use_case.dart';
import 'package:complete_advanced_flutter/presentation/register/register_viewmodel.dart';
import 'package:get_it/get_it.dart';
import 'package:image_picker/image_picker.dart';
import 'package:internet_connection_checker/internet_connection_checker.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../domain/usecase/forgot_password_usecase.dart';
import '../domain/usecase/home_usecase.dart';
import '../domain/usecase/login_use_case.dart';
import '../domain/usecase/store_details_usecase.dart';
import '../presentation/forgot_password/forgot_password_viewmodel.dart';
import '../presentation/login/login_viewmodel.dart';
import '../presentation/main/home/home_viewmodel.dart';
import '../presentation/store_details/store_details_viewmodel.dart';

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

  //Local Datasource
  instance.registerLazySingleton<LocalDataSourceImplementer>(
      () => LocalDataSourceImplementer());

  //Repository instance
  instance.registerLazySingleton<RepositoryImpl>(() => RepositoryImpl(
        instance<RemoteDataSourceImplementer>(),
        instance<LocalDataSourceImplementer>(),
        instance<NetworkInfoImpl>(),
      ));
}

initLoginModule() {
  //Check initLoginModule
  if (!GetIt.I.isRegistered<LoginUseCase>()) {
    //LoginUseCase instance
    instance.registerLazySingleton<LoginUseCase>(
        () => LoginUseCase(instance<RepositoryImpl>()));

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

initRegisterModule() {
  if (!GetIt.I.isRegistered<RegisterUseCase>()) {
    instance.registerFactory<RegisterUseCase>(
        () => RegisterUseCase(instance<RepositoryImpl>()));
    instance.registerFactory<RegisterViewModel>(
        () => RegisterViewModel(instance<RegisterUseCase>()));
    instance.registerFactory<ImagePicker>(() => ImagePicker());
  }
}

initHomeModule() {
  if (!GetIt.I.isRegistered<HomeUseCase>()) {
    instance.registerFactory<HomeUseCase>(
        () => HomeUseCase(instance<RepositoryImpl>()));
    instance.registerFactory<HomeViewModel>(
        () => HomeViewModel(instance<HomeUseCase>()));
  }
}
initStoreDetailsModule() {
  if (!GetIt.I.isRegistered<StoreDetailsUseCase>()) {
    instance.registerFactory<StoreDetailsUseCase>(
            () => StoreDetailsUseCase(instance<RepositoryImpl>()));
    instance.registerFactory<StoreDetailsViewModel>(
            () => StoreDetailsViewModel(instance<StoreDetailsUseCase>()));
  }
}
resetModules() {
  instance.reset(dispose: false);
  initAppModule();
  initHomeModule();
  initLoginModule();
  initRegisterModule();
  initForgotPasswordModule();
  initStoreDetailsModule();
}
