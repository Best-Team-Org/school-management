import 'package:flutter/foundation.dart';
import 'package:semi_final_lab/models/user_model.dart';

class HomeViewModel with ChangeNotifier{

  UserModel? user;
  set setUser(UserModel? newUser){
    user = newUser;
    notifyListeners();
  }

}