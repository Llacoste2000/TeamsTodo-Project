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
  List<TeamCard> _teams = [];

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
        child: Column(
          children: <Widget>[
            Container(
              padding: EdgeInsets.only(left: 16.0, right: 16.0, top: 10.0),
              child: Text(
                'My teams',
                style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 20.0,
                    color: Colors.black),
              ),
            ),
            Expanded(
              // @TODO Iterate over a variable...
              child: FutureBuilder<String>(
                future: fetchTeams(provider.groupId),
                builder:
                    (BuildContext context, AsyncSnapshot<String> snapshot) {
                  List<Widget> children;
                  List<Widget> childs = [];
                  if (snapshot.hasData) {
                    for (var i = 0; i < _teams.length; i++) {
                      childs.add(new Container(
                        padding: EdgeInsets.only(left: 80.0, top: 10.0),
                        child: Row(children: <Widget>[
                          Expanded(child: Text(_teams[i].name)),
                          Expanded(
                              child: FlatButton(
                            textColor: Color(0xFF6200EE),
                            onPressed: () {
                              // @TODO Modify this to go to the todolists of the team
                              //widget.callback('team');
                              //provider.setGroupId(_teams[i].id);
                            },
                            child: Text('See team'),
                          ))
                        ]),
                      ));
                    }
                    children = childs;
                  } else if (snapshot.hasError) {
                    children = <Widget>[
                      Icon(
                        Icons.error_outline,
                        color: Colors.red,
                        size: 60,
                      ),
                      Padding(
                        padding: const EdgeInsets.all(15.0),
                        child: Text('Error: ${snapshot.error}'),
                      )
                    ];
                  } else {
                    children = <Widget>[
                      SizedBox(
                        child: CircularProgressIndicator(),
                        width: 60,
                        height: 60,
                      ),
                      const Padding(
                        padding: EdgeInsets.only(top: 16),
                        child: Text('Awaiting result...'),
                      )
                    ];
                  }
                  return Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: children,
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
      floatingActionButton: new FloatingActionButton(
          onPressed: _pushAddTeamScreen,
          tooltip: 'Add group',
          child: new Icon(Icons.add)),
    );
  }

  Future<String> fetchTeams(groupId) async {
    User user = User.fromJson(await StorageService.readValue('user'));

    await DotEnv().load('.env');

    String url = DotEnv().env['API_URL'] + "/groups/$groupId";

    var response = await http.get(url, headers: <String, String>{
      HttpHeaders.authorizationHeader: 'Bearer ' + user.token,
      'Content-Type': 'application/json; charset=UTF-8',
    });

    print(response.body);

    Map<String, dynamic> data = jsonDecode(response.body);
    for (int i = 0; i < data['teams'].length; i++) {
      //_groups[data['groups'][i]['@id']] = data['groups'][i]['name'];

      TeamCard team = new TeamCard(
          data['teams'][i]['id'].toString(), data['teams'][i]['name']);

      _teams.add(team);
    }

    return response.body;
  }
}

class TeamCard {
  String name;
  String id;

  TeamCard(this.id, this.name);

  String get getId => this.id;
}
