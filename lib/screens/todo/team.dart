import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:todo/state/user/user_provider.dart';

class Team extends StatefulWidget {
  Function(String) callback;

  Team(this.callback);

  @override
  _TeamState createState() => _TeamState();
}

class _TeamState extends State<Team> {
  @override
  Widget build(BuildContext context) {
    GlobalProvider provider = Provider.of(context, listen: false);

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
        child: Text(provider.groupId == null ? "loading..." : provider.groupId),
      ),
    );
  }
}
