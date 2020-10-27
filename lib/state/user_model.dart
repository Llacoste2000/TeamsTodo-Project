import 'package:flutter/cupertino.dart';
import 'package:todo/users/connect.dart';

class UserModel extends ChangeNotifier {
  User _user;

  String get userToken => this._user.token;

  User get userAuth => this._user;

  void setUser(User user) {
    this._user = user;
    notifyListeners();
  }
}
