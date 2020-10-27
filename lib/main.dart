import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:todo/routes/routes.dart';
import 'package:todo/state/user_model.dart';

void main() => runApp(
      ChangeNotifierProvider(
        create: (context) => UserModel(),
        child: new TodoApp(),
      ),
    );

class TodoApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return new MaterialApp(
      // Start the app with the "/" named route. In this case, the app starts
      // on the FirstScreen widget.
      initialRoute: '/',
      routes: routes,
    );
  }
}
