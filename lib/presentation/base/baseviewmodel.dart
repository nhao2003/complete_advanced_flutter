import 'dart:async';

import 'package:complete_advanced_flutter/presentation/common/state_render/state_render_impl.dart';

///Shared variables and functions that will be used through any view model
abstract class BaseViewModel extends BaseViewModelInputs
    with BaseViewModelOutputs {
  StreamController _inputStateStreamController =
      StreamController<FlowState>.broadcast();

  @override
  Sink get inputState => _inputStateStreamController.sink;

  @override
  Stream<FlowState> get outputState => _inputStateStreamController.stream.map((flowState) => flowState);

  @override
  void dispose() {
    _inputStateStreamController.close();
  }

}

abstract class BaseViewModelInputs {
  ///Will be called while initiation of the view model
  void start();

  ///Will be called when view model dispose
  void dispose();

  Sink get inputState;
}

abstract class BaseViewModelOutputs {
  Stream<FlowState> get outputState;
}
