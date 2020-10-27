import 'package:flutter/material.dart';
import 'package:todo/login.dart';
import 'package:todo/screens/login/login.dart';
import 'package:todo/screens/todo/todo.dart';

import '../login.dart';
import '../todo.dart';

var routes = <String, WidgetBuilder>{
  '/': (context) => TodoList(),
  '/login': (context) => Login(),
  '/register': (context) => Register()
};
