import 'package:flutter/material.dart';

import 'package:todo/login.dart';
import 'package:todo/todo.dart';

var routes = <String, WidgetBuilder>{
  '/login': (context) => Login(),
  '/': (context) => TodoList(),
};
