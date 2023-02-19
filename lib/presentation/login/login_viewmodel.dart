import 'dart:async';
import 'package:complete_advanced_flutter/domain/usecase/login_use_case.dart';
import 'package:complete_advanced_flutter/presentation/base/baseviewmodel.dart';
import 'package:complete_advanced_flutter/presentation/common/state_render/state_render_impl.dart';
import 'package:complete_advanced_flutter/presentation/common/state_render/state_renderer.dart';
import '../common/freezed_data_classes.dart';

class LoginViewModel extends BaseViewModel
    with LoginViewModelInputs, LoginViewModelOutputs {
  LoginObject loginObject = LoginObject("", "");

  final StreamController _userNameStreamController =
      StreamController<String>.broadcast();
  final StreamController _passwordStreamController =
      StreamController<String>.broadcast();

  final StreamController isUserLoggedInSuccessfullyStreamController =
      StreamController<bool>();

  final StreamController _isAllInputValidStreamController =
      StreamController<void>.broadcast();
  late final LoginUseCase _loginUseCase;

  LoginViewModel(this._loginUseCase);

  @override
  void dispose() {
    _userNameStreamController.close();
    _passwordStreamController.close();
    _isAllInputValidStreamController.close();
    isUserLoggedInSuccessfullyStreamController.close();
  }

  @override
  void start() {
    // Views tell state renderer. Please show the content of the screen
    inputState.add(ContentState());
  }

  @override
  Sink get inputPassword => _passwordStreamController.sink;

  @override
  Sink get inputUserName => _userNameStreamController.sink;

  @override
  Sink get isAllInput => _isAllInputValidStreamController.sink;

  @override
  login() async {
    inputState.add(
        LoadingState(stateRendererType: StateRendererType.popupLoadingState));
    (await _loginUseCase.execute(LoginUseCaseInput(
            email: loginObject.userName, password: loginObject.password)))
        .fold(
            (left) => {
                  // Left => Failure
                  inputState.add(ErrorState(
                      stateRendererType: StateRendererType.popupErrorState,
                      message: left.message))
                },
            (right) => {
                  //Right => Success
                  inputState.add(ContentState()),

                  //Navigate to main screen after login
                  isUserLoggedInSuccessfullyStreamController.sink.add(true)
                });
  }

  @override
  Stream<bool> get outputIsPasswordValid => _passwordStreamController.stream
      .map((password) => _isPasswordValid(password));

  @override
  Stream<bool> get outputIsUserNameValid => _userNameStreamController.stream
      .map((userName) => _isUserNameValid(userName));

  @override
  setPassword(String password) {
    inputPassword.add(password);
    loginObject = loginObject.copyWith(password: password);
    _isAllInputValidStreamController.add(null);
  }

  @override
  setUserName(String userName) {
    inputUserName.add(userName);
    loginObject = loginObject.copyWith(userName: userName);
    _isAllInputValidStreamController.add(null);
  }

  bool _isPasswordValid(String password) {
    return password.isNotEmpty && password.length >= 8;
  }

  bool _isUserNameValid(String userName) {
    return userName.isNotEmpty;
  }

  @override
  Stream<bool> get outputIsAllInputIsValid =>
      _isAllInputValidStreamController.stream
          .map((event) => _isAllInputsValid());

  bool _isAllInputsValid() {
    return _isUserNameValid(loginObject.userName) &&
        _isPasswordValid(loginObject.password);
  }
}

abstract class LoginViewModelInputs {
  setUserName(String userName);

  setPassword(String password);

  login();

  //Two sinks
  Sink get inputUserName;

  Sink get inputPassword;

  Sink get isAllInput;
}

abstract class LoginViewModelOutputs {
  Stream<bool> get outputIsUserNameValid;

  Stream<bool> get outputIsPasswordValid;

  Stream<bool> get outputIsAllInputIsValid;
}
