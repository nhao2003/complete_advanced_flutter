import 'package:complete_advanced_flutter/app/extensions.dart';
import 'package:complete_advanced_flutter/data/network/failure.dart';
import 'package:complete_advanced_flutter/presentation/resources/font_manager.dart';
import 'package:complete_advanced_flutter/presentation/resources/styles_manager.dart';
import 'package:complete_advanced_flutter/presentation/resources/values_manager.dart';
import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import '../../resources/assets_manager.dart';
import '../../resources/color_manager.dart';
import '../../resources/strings_manager.dart';

enum StateRendererType {
  // Popup states
  popupLoadingState,
  popupErrorState,
  popupSuccess,
  // Fullscreen states
  fullscreenLoadingState,
  fullscreenErrorState,

  ///The UI of the screen
  contentScreenState,

  /// Empty view when we receive no data from api side for list screen
  emptyScreenState
}

class StateRenderer extends StatelessWidget {
  late StateRendererType stateRenderType;
  late String title;
  late String message;
  late Function retryActionFunction;

  StateRenderer({
    Key? key,
    required this.stateRenderType,
    required this.retryActionFunction,
    this.title = EMPTY,
    this.message = AppStrings.loading,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return _getStateWidget(context);
  }

  Widget _getStateWidget(BuildContext context) {
    switch (stateRenderType) {
      case StateRendererType.popupLoadingState:
        return _getPopupDialog(
            context, [_getAnimatedImage(JsonAssets.loading)]);
      case StateRendererType.popupErrorState:
        return _getPopupDialog(context, [
          _getAnimatedImage(JsonAssets.error),
          _getMessage(message),
          _getRetryButton(
            AppStrings.ok,
            context,
          )
        ]);
      case StateRendererType.fullscreenLoadingState:
        return _getItemsInColumn(
            [_getAnimatedImage(JsonAssets.loading), _getMessage(message)]);
      case StateRendererType.fullscreenErrorState:
        return _getItemsInColumn([
          _getAnimatedImage(JsonAssets.error),
          _getMessage(message),
          _getRetryButton(AppStrings.retry_again, context)
        ]);
      case StateRendererType.contentScreenState:
        return Container();
      case StateRendererType.emptyScreenState:
        return _getItemsInColumn(
            [_getAnimatedImage(JsonAssets.empty), _getMessage(message)]);
      default:
        return Container();
    }
  }

  Widget _getPopupDialog(BuildContext context, List<Widget> children) {
    return Dialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(AppSize.s14),
      ),
      elevation: AppSize.s1_5,
      backgroundColor: Colors.transparent,
      child: Container(
        decoration: BoxDecoration(
            color: ColorManager.white,
            shape: BoxShape.rectangle,
            borderRadius: BorderRadius.circular(AppSize.s14),
            boxShadow: const [
              BoxShadow(
                color: Colors.black26,
                blurRadius: AppSize.s12,
                offset: Offset(
                  AppSize.s0,
                  AppSize.s12,
                ),
              )
            ]),
        child: _getDialogContent(context, children),
      ),
    );
  }

  Widget _getDialogContent(BuildContext context, List<Widget> children) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: children,
    );
  }

  Widget _getAnimatedImage(String animationName) {
    return SizedBox(
      height: AppSize.s100,
      width: AppSize.s100,
      child: Lottie.asset(animationName),
    );
  }

  Widget _getMessage(String message) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(AppPadding.p18),
        child: Text(
          message,
          style: getMediumStyle(
            color: ColorManager.black,
            fontSize: FontSize.s16,
          ),
        ),
      ),
    );
  }

  Widget _getRetryButton(String buttonTitle, BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(AppPadding.p18),
        child: SizedBox(
          width: AppSize.s180,
          child: ElevatedButton(
              onPressed: () {
                if (stateRenderType == StateRendererType.fullscreenErrorState) {
                  //To call the API function again
                  retryActionFunction.call();
                } else {
                  //Popup state error so we need to dismiss the dialog
                  Navigator.of(context).pop();
                }
              },
              child: Text(buttonTitle)),
        ),
      ),
    );
  }

  Widget _getItemsInColumn(List<Widget> children) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: children,
      ),
    );
  }
}
