import 'package:flutter/material.dart';
import 'package:todo/helpers/storage.dart';
import 'package:todo/login.dart';
import 'package:todo/screens/login/login.dart';
import 'package:todo/screens/todo/todo.dart';

class Home extends StatefulWidget {
  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  var user;

  Future _checkLogin(BuildContext context) async {
    try {
      String user = await StorageService.readValue('user');

      return user;
    } catch (e) {
      print(e.toString());
    }
  }

  @override
  void initState() {
    super.initState();
    _checkLogin(context).then((value) {
      setState(() {
        user = value;
      });
    });
    new Future.delayed(new Duration(seconds: 5), () => _checkLogin(context))
        .then((value) {
      setState(() {
        user = value;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    print(user);
    if (user != null) {
      return TodoList();
    } else {
      return LoginScreen();
    }
  }
}
