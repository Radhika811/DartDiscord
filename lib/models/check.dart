import 'package:dartdiscord/models/user.dart';

class checkValidity{
  bool check = false;

  static bool checkLogin(User currentUser){
    if(currentUser.username == ''){
      return false;
    }
    return true;
  }
}