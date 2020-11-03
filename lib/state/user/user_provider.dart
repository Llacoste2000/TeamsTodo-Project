import 'package:flutter/cupertino.dart';
import 'package:todo/state/user/user_model.dart';

class GlobalProvider extends ChangeNotifier {
  User _user;
  String _groupId;
  String _teamId;
  String _todoListId;

  String get userToken => this._user.token;

  User get userAuth => this._user;

  String get groupId => this._groupId;

  String get teamId => this._teamId;

  String get todolistsId => this._todoListId;

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

  void setTeamId(String id) {
    this._teamId = id;
    notifyListeners();
  }

  void setTodolistId(String id) {
    this._todoListId = id;
    notifyListeners();
  }
}
