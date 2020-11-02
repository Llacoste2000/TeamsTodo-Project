import 'package:flutter/material.dart';
import 'package:todo/login.dart';
import 'package:todo/register.dart';
import 'package:todo/screens/home/home.dart';
import 'package:todo/screens/todo/group.dart';
import 'package:todo/screens/todo/todo.dart';
import 'package:todo/screens/user-menu/user-menu.dart';

var routes = <String, WidgetBuilder>{
  '/': (context) => Home(),
  '/todo': (context) => TodoList(),
  '/login': (context) => Login(),
  '/usermenu': (context) => UserMenu(),
  '/register': (context) => Register(),
  '/group': (context) => Group(),
  '/usermenu': (context) => UserMenu(),
  '/register': (context) => Register()
};
