import 'package:flutter/cupertino.dart';
import 'package:todo/state/user/user_model.dart';

class UserProvider extends ChangeNotifier {
  User _user;

  String get userToken => this._user.token;

  User get userAuth => this._user;

  void setUser(User user) {
    this._user = user;
    notifyListeners();
  }

  void deleteUser() {
    this._user = null;
    notifyListeners();
  }
}
