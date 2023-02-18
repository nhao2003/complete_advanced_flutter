import 'dart:async';

import 'package:complete_advanced_flutter/domain/usecase/login_usecase.dart';
import 'package:complete_advanced_flutter/presentation/base/baseviewmodel.dart';

import '../common/freezed_data_classes.dart';

class LoginViewModel extends BaseViewMobel
    with LoginViewModelInputs, LoginViewModelOutputs {
  StreamController _userNameStreamController =
      StreamController<String>.broadcast();
  StreamController _passwordStreamController =
      StreamController<String>.broadcast();
  LoginObject loginObject = LoginObject("", "");

  StreamController _isAllInputValidStreamController =
      StreamController<void>.broadcast();
  late LoginUseCase _loginUseCase;

  LoginViewModel(this._loginUseCase);

  @override
  void dispose() {
    _userNameStreamController.close();
    _passwordStreamController.close();
    _isAllInputValidStreamController.close();
  }

  @override
  void start() {
    // TODO: implement start
  }

  @override
  Sink get inputPassword => _passwordStreamController.sink;

  @override
  Sink get inputUserName => _userNameStreamController.sink;

  @override
  Sink get isAllInput => _isAllInputValidStreamController.sink;

  @override
  login() async {
    print(loginObject);
    (await _loginUseCase.execute(LoginUseCaseInput(
            email: loginObject.userName, password: loginObject.password)))
        .fold(
            (left) => {
                  // Left => Failure
                  print(left.message)
                },
            (right) => {
                  //Right => Success
                  print(right.customer?.name)
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
    loginObject =  loginObject.copyWith(password: password);
    _isAllInputValidStreamController.add(null);
  }

  @override
  setUserName(String userName) {
    inputUserName.add(userName);
    loginObject =   loginObject.copyWith(userName: userName);
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
