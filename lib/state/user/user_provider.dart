import 'package:flutter/cupertino.dart';
import 'package:todo/state/user/user_model.dart';

class GlobalProvider extends ChangeNotifier {
  User _user;
  String _groupId;

  String get userToken => this._user.token;

  User get userAuth => this._user;

  String get groupId => this._groupId;

  void setUser(User user) {
    this._user = user;
    notifyListeners();
  }

  void deleteUser() {
    this._user = null;
    notifyListeners();
  }

  void setGroupId(String id) {
    this._groupId = id;
    notifyListeners();
  }
}
