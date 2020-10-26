import 'package:flutter/material.dart';

import 'package:todo/login.dart';
import 'package:todo/register.dart';
import 'package:todo/todo.dart';

var routes = <String, WidgetBuilder>{
  '/todo': (context) => TodoList(),
  '/login': (context) => Login(),
  '/register': (context) => Register()
};
