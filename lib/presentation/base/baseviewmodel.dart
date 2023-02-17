///Shared variables and functions that will be used through any view model
abstract class BaseViewMobel extends BaseViewMobelInputs with BaseViewMobelOutputs {

}

abstract class BaseViewMobelInputs {
  ///Will be called while initiation of the view model
  void start();

  ///Will be called when view model dispose
  void dispose();

}

abstract class BaseViewMobelOutputs {

}