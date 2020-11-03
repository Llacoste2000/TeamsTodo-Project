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
          backgroundColor: Color.fromRGBO(25, 86, 170, 1.0),
          title: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Image.asset(
                'assets/images/app-logo.png',
                fit: BoxFit.contain,
                height: 42,
              ),
              Container(
                  padding: const EdgeInsets.all(8.0), child: Text(
                'TeamsToDo',
                style: TextStyle(
                    fontSize: 23.0,
                    fontFamily: 'Pacifico',
                    fontWeight: FontWeight.w600,
                    letterSpacing: 2.0
                ),
              ))
            ],
          )
      ),
      body: Center(
        child: Column(
          children: <Widget>[
            Container(
              padding: EdgeInsets.only(left: 16.0, right: 16.0, top: 20.0, bottom: 20.0),
              child: Text(
                'My Groups',
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
                      childs.add(Center(
                        child: Card(
                          color: Colors.white,
                          borderOnForeground: true,
                          shape: Border(left: BorderSide(color: Color.fromRGBO(25, 86, 170, 1.0), width: 10)),
                          elevation: 4.0,
                          child: Column(
                            mainAxisSize: MainAxisSize.min,
                            children: <Widget>[
                              ListTile(
                                leading: Icon(Icons.group, size: 40.0, color: Color.fromRGBO(25, 86, 170, 1.0)),
                                title: Text(
                                  'Group : '+ _groups[i].name,
                                  style: TextStyle(
                                      letterSpacing: 1.0,
                                      fontFamily: 'SourceSansPro',
                                      fontSize: 17.0,
                                      color: Color.fromRGBO(25, 86, 170, 1.0),
                                      fontWeight: FontWeight.w600
                                  ) ,),
                              ),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.end,
                                children: <Widget>[
                                  SizedBox(width: 8),
                                  TextButton(
                                    child: Text(
                                      'SHOW GROUP',
                                      style: new TextStyle(
                                          color: Colors.blue[300],
                                          fontWeight: FontWeight.w800,
                                          fontSize: 18.0
                                      ),
                                    ),
                                    onPressed: () {
                                      setState(() {
                                        widget.callback('team');
                                        provider.setGroupId(_groups[i].id);
                                      });
                                    },
                                  ),
                                  SizedBox(width: 8),
                                ],
                              ),
                            ],
                          ),
                        ),
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
          backgroundColor: Color.fromRGBO(25, 86, 170, 1.0),
          focusColor: Color.fromRGBO(25, 86, 170, 0.9),
          hoverColor: Color.fromRGBO(25, 86, 170, 0.8),
          onPressed: _pushAddGroupScreen,
          tooltip: 'Add group',
          child: new Icon(Icons.add, size: 35.0,)),
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

      GroupCard group = new GroupCard(
          data['groups'][i]['@id'].toString().split('/').last.toString(),
          data['groups'][i]['name']);

      _groups.add(group);
    }

    return response.body;
  }
}
