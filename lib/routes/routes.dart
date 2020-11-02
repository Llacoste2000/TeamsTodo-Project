import 'package:flutter/material.dart';
import 'package:todo/screens/home/home.dart';
import 'package:todo/screens/login/login.dart';
import 'package:todo/screens/todo/todo.dart';

import 'package:todo/login.dart';
import 'package:todo/register.dart';

var routes = <String, WidgetBuilder>{
  '/': (context) => Home(),
  '/todo': (context) => TodoList(),
  '/login': (context) => LoginScreen(),
  '/register': (context) => Register()
};
