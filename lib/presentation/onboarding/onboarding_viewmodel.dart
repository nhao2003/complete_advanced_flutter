import 'dart:async';

import 'package:complete_advanced_flutter/presentation/base/baseviewmodel.dart';
import '../../domain/model/model.dart';
import '../resources/assets_manager.dart';
import '../resources/strings_manager.dart';

class OnboardingViewModel extends BaseViewMobel
    with OnboardingViewModelInputs, OnboardingViewModelOutputs {
  int _currentIndex = 0;
  final StreamController _streamController = StreamController<SliderViewObject>();
  late List<SliderObject> _list;

  @override
  void start() {
    _list = _getSliderDate();
    _postDataToView();
  }

  @override
  void dispose() {
    _streamController.close();
  }

  @override
  int goNext() {
    int previousIndex = _currentIndex++;
    if (previousIndex >= _list.length - 1) {
      //Infinite loop go to the first item
      _currentIndex = 0;
    }
    _postDataToView();
    return _currentIndex;
  }

  @override
  int goPrevious() {
    int previousIndex = _currentIndex--;
    if (previousIndex == 0) {
      //Infinite loop go to the length of slider list
      _currentIndex = _list.length - 1;
    }
    _postDataToView();
    return _currentIndex;
  }

  @override
  void onPageChanged(int index) {
    _currentIndex = index;
    _postDataToView();
  }

  //The input of StreamController
  @override
  Sink get inputSliderViewObject => _streamController.sink;

  //The output of StreamController
  @override
  Stream<SliderViewObject> get outputSliderViewObject =>
      _streamController.stream.map((sliderViewObject) => sliderViewObject);

  List<SliderObject> _getSliderDate() => [
        SliderObject(
            title: AppStrings.onBoardingTitle1,
            subTitle: AppStrings.onBoardingSubTitle1,
            image: ImageAssets.onboardingLogo1),
        SliderObject(
            title: AppStrings.onBoardingTitle2,
            subTitle: AppStrings.onBoardingSubTitle2,
            image: ImageAssets.onboardingLogo2),
        SliderObject(
            title: AppStrings.onBoardingTitle3,
            subTitle: AppStrings.onBoardingSubTitle3,
            image: ImageAssets.onboardingLogo3),
      ];

  _postDataToView() {
    inputSliderViewObject.add(SliderViewObject(
        sliderObject: _list[_currentIndex],
        numOfSliders: _list.length,
        currentIndex: _currentIndex));
  }
}

//Inputs mean the orders view model will be received from view
abstract class OnboardingViewModelInputs {
  ///When user clicks on right arrow or swipe left
  void goNext();

  ///When user clicks on left arrow or swipe right
  void goPrevious();

  ///When page changed
  void onPageChanged(int index);

  ///Add SliderViewObject to the stream (Stream Input)
  Sink get inputSliderViewObject;
}

//Outputs mean the data or results will be sent from view model to view
abstract class OnboardingViewModelOutputs {
  ///Get SliderViewObject from the stream (Stream output)
  Stream<SliderViewObject> get outputSliderViewObject;
}

class SliderViewObject {
  late SliderObject sliderObject;
  late int numOfSliders;
  late int currentIndex;

  SliderViewObject({
    required this.sliderObject,
    required this.numOfSliders,
    required this.currentIndex,
  });
}
