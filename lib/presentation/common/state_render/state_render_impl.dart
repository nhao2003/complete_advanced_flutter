import 'package:complete_advanced_flutter/app/extensions.dart';
import 'package:complete_advanced_flutter/presentation/common/state_render/state_renderer.dart';
import 'package:complete_advanced_flutter/presentation/resources/strings_manager.dart';
import 'package:flutter/material.dart';

abstract class FlowState {
  StateRendererType getStateRendererType();

  String getMessage();
}

///Loading State (Popup, Fullscreen)
class LoadingState extends FlowState {
  StateRendererType stateRendererType;
  String message;

  LoadingState(
      {required this.stateRendererType, this.message = AppStrings.loading,});

  @override
  String getMessage() => message;

  @override
  StateRendererType getStateRendererType() => stateRendererType;
}

///Error State (Popup, Full loading)
class ErrorState extends FlowState {
  StateRendererType stateRendererType;
  String message;

  ErrorState(
      {required this.stateRendererType, required this.message});

  @override
  String getMessage() => message;

  @override
  StateRendererType getStateRendererType() => stateRendererType;
}

/// ContentState
class ContentState extends FlowState {
  ContentState();

  @override
  String getMessage() => EMPTY;

  @override
  StateRendererType getStateRendererType() =>
      StateRendererType.contentScreenState;
}

/// EmptyState
class EmptyState extends FlowState {
  String message;

  EmptyState(this.message);

  @override
  String getMessage() => message;

  @override
  StateRendererType getStateRendererType() => StateRendererType.emptyScreenState;
}

//SuccessState
class SuccessState extends FlowState {
  String message;

  SuccessState(this.message);

  @override
  String getMessage() => message;

  @override
  StateRendererType getStateRendererType() => StateRendererType.popupSuccess;
}

extension FlowStateExtension on FlowState {
  Widget getScreenWidget(
    BuildContext context,
    Widget contentScreenWidget,
    Function retryActionFunction,
  ) {
    switch (runtimeType) {
      case LoadingState:
        {
          if (getStateRendererType() == StateRendererType.popupLoadingState) {
            // Showing popup dialog
            showPopup(context, getStateRendererType(), getMessage());
            // Return the content ui of the screen
            return contentScreenWidget;
          } else {
            return StateRenderer(
              stateRenderType: getStateRendererType(),
              retryActionFunction: retryActionFunction,
              message: getMessage(),
            );
          }
        }
      case ErrorState:
        {
          dismissDialog(context);
          if (getStateRendererType() == StateRendererType.popupErrorState) {
            showPopup(context, getStateRendererType(), getMessage());
            return contentScreenWidget;
          } else {
            return StateRenderer(
              stateRenderType: getStateRendererType(),
              retryActionFunction: retryActionFunction,
              message: getMessage(),
            );
          }
        }

      case ContentState:
        {
          dismissDialog(context);
          return contentScreenWidget;
        }
      case EmptyState:
        {
          return StateRenderer(
              stateRenderType: getStateRendererType(),
              message: getMessage(),
              retryActionFunction: retryActionFunction);
        }
    }
    return contentScreenWidget;
  }

  dismissDialog(BuildContext context) {
    if (_isThereCurrentDialogShowing(context)) {
      Navigator.of(context, rootNavigator: true).pop(true);
    }
  }

  _isThereCurrentDialogShowing(BuildContext context) =>
      ModalRoute.of(context)?.isCurrent != true;

  showPopup(BuildContext context, StateRendererType stateRendererType,
      String message) {
    WidgetsBinding.instance.addPostFrameCallback(
      (_) => showDialog(
        context: context,
        builder: (BuildContext context) => StateRenderer(
          stateRenderType: stateRendererType,
          message: message,
          retryActionFunction: () {},
        ),
      ),
    );
  }
}
