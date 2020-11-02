import 'package:flutter/material.dart';

class Team extends StatefulWidget {
  Function(String) callback;

  Team(this.callback);

  @override
  _TeamState createState() => _TeamState();
}

class _TeamState extends State<Team> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('TodoList APP - Team'), actions: <Widget>[
        IconButton(
          icon: const Icon(Icons.close_rounded),
          tooltip: 'Close team page',
          onPressed: () {
            widget.callback('groupList');
          },
        )
      ]),
      body: Center(
        child: Text(widget.callback.toString()),
      ),
    );
  }
}
