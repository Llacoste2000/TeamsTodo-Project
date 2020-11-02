import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:http/http.dart' as http;
import 'package:provider/provider.dart';
import 'package:todo/helpers/storage.dart';
import 'package:todo/state/user/user_model.dart';
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

    Future<void> _pushAddTeam(name) async {
      String user = await StorageService.readValue('user');
      provider.setUser(User.fromJson(user));

      await DotEnv().load('.env');

      var url = DotEnv().env['API_URL'] + '/teams';

      var groupId = provider.groupId;

      var response = await http.post(url,
          headers: <String, String>{
            HttpHeaders.authorizationHeader: 'Bearer ' + provider.userToken,
            'Content-Type': 'application/json; charset=UTF-8',
          },
          body: jsonEncode(<String, String>{
            "name": name,
            "teamgroup": "/api/groups/" + groupId.toString()
          }));
      // @TODO add to state to push it ?
    }

    void _pushAddTeamScreen() {
      // Push this page
      Navigator.of(context).push(new MaterialPageRoute(builder: (context) {
        return new Scaffold(
            appBar: new AppBar(title: new Text('Add a new team')),
            body: new TextField(
              autofocus: true,
              onSubmitted: (val) {
                _pushAddTeam(val);
                Navigator.pop(context); // Close the add page
              },
              decoration: new InputDecoration(
                  hintText: 'Enter a group name.',
                  contentPadding: const EdgeInsets.all(16.0)),
            ));
      }));
    }

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
        child: Text(provider.groupId),
      ),
      floatingActionButton: new FloatingActionButton(
          onPressed: _pushAddTeamScreen,
          tooltip: 'Add group',
          child: new Icon(Icons.add)),
    );
  }
}
