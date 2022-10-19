import 'package:flutter/foundation.dart';

class SplashViewModel with ChangeNotifier{

  bool isSplashEnd = false;
  set setIsSplashEnd(bool newValue){
    isSplashEnd = newValue;
    notifyListeners();
  }

}