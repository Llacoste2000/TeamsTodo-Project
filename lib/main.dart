import 'package:flutter/material.dart';

void main() => runApp(new TodoApp());

class TodoApp extends StatelessWidget {
  static const String appTitle = 'TodoTeams';

  @override
  Widget build(BuildContext context) {
    return new MaterialApp(
      // Start the app with the "/" named route. In this case, the app starts
      // on the FirstScreen widget.
      initialRoute: '/',
      home: Scaffold(
        appBar: AppBar(
          title: Text(appTitle),
        ),
      ),
    );
  }
}
