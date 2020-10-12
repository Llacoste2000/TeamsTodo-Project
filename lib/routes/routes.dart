import 'package:flutter/material.dart';

import '../login.dart';
import '../todo.dart';

var routes = <String, WidgetBuilder>{
  '/': (context) => Login(),
  '/todo': (context) => TodoList(),
};
