import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:http/http.dart' as http;
import 'package:provider/provider.dart';
import 'package:todo/helpers/storage.dart';
import 'package:todo/state/user/user_model.dart';
import 'package:todo/state/user/user_provider.dart';

class Group extends StatefulWidget {
  Function(String) callback;

  Group(this.callback);

  @override
  _GroupState createState() => _GroupState();
}

class GroupCard {
  String name;
  String id;

  GroupCard(this.id, this.name);

  String get getId => this.id;
}

class _GroupState extends State<Group> {
  List<GroupCard> _groups = [];

  @override
  Widget build(BuildContext context) {
    GlobalProvider userProvider = Provider.of(context);

    Future<void> _pushAddGroup(name) async {
      String user = await StorageService.readValue('user');
      userProvider.setUser(User.fromJson(user));

      await DotEnv().load('.env');

      var url = DotEnv().env['API_URL'] + '/groups';

      var response = await http.post(url,
          headers: <String, String>{
            HttpHeaders.authorizationHeader: 'Bearer ' + userProvider.userToken,
            'Content-Type': 'application/json; charset=UTF-8',
          },
          body: jsonEncode(<String, String>{"name": name}));

      // @TODO add to state to push it ?
    }

    void _pushAddGroupScreen() {
      // Push this page
      Navigator.of(context).push(new MaterialPageRoute(builder: (context) {
        return new Scaffold(
            appBar: new AppBar(title: new Text('Add a new group')),
            body: new TextField(
              autofocus: true,
              onSubmitted: (val) {
                _pushAddGroup(val);
                Navigator.pop(context); // Close the add page
              },
              decoration: new InputDecoration(
                  hintText: 'Enter a group name.',
                  contentPadding: const EdgeInsets.all(16.0)),
            ));
      }));
    }

    GlobalProvider provider = Provider.of(context, listen: false);

    return new Scaffold(
      appBar: AppBar(
        title: const Text('TodoList APP - Groups'),
      ),
      body: Center(
        child: Column(
          children: <Widget>[
            Container(
              padding: EdgeInsets.only(left: 16.0, right: 16.0, top: 10.0),
              child: Text(
                'My groups',
                style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 20.0,
                    color: Colors.black),
              ),
            ),
            Expanded(
              // @TODO Iterate over a variable...
              child: FutureBuilder<String>(
                future: fetchGroups(),
                builder:
                    (BuildContext context, AsyncSnapshot<String> snapshot) {
                  List<Widget> children;
                  List<Widget> childs = [];
                  if (snapshot.hasData) {
                    for (var i = 0; i < _groups.length; i++) {
                      childs.add(new Container(
                        padding: EdgeInsets.only(left: 80.0, top: 10.0),
                        child: Row(children: <Widget>[
                          Expanded(child: Text(_groups[i].name)),
                          Expanded(
                              child: FlatButton(
                            textColor: Color(0xFF6200EE),
                            onPressed: () {
                              widget.callback('team');
                              provider.setGroupId(_groups[i].id);
                            },
                            child: Text('See group'),
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
          onPressed: _pushAddGroupScreen,
          tooltip: 'Add group',
          child: new Icon(Icons.add)),
    );
  }

  Future<String> fetchGroups() async {
    User user = User.fromJson(await StorageService.readValue('user'));

    await DotEnv().load('.env');

    String url = DotEnv().env['API_URL'] + "/users/${user.id}";

    var response = await http.get(url, headers: <String, String>{
      HttpHeaders.authorizationHeader: 'Bearer ' + user.token,
      'Content-Type': 'application/json; charset=UTF-8',
    });

    Map<String, dynamic> data = jsonDecode(response.body);
    for (int i = 0; i < data['groups'].length; i++) {
      //_groups[data['groups'][i]['@id']] = data['groups'][i]['name'];

      GroupCard group = new GroupCard(
          data['groups'][i]['@id'].toString().split('/').last.toString(),
          data['groups'][i]['name']);

      _groups.add(group);
    }

    return response.body;
  }
}
