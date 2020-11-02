import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:todo/helpers/storage.dart';
import 'package:todo/routes/routes.dart';
import 'package:todo/state/user/user_provider.dart';

void main() => runApp(
      ChangeNotifierProvider(
        create: (context) => GlobalProvider(),
        child: new TodoApp(),
      ),
    );

class TodoApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return new MaterialApp(
      initialRoute: '/',
      routes: routes,
    );
  }
}
