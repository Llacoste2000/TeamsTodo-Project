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
  @override
  _GroupState createState() => _GroupState();
}

class _GroupState extends State<Group> {
  var _groups = {};

  @override
  Widget build(BuildContext context) {
    UserProvider userProvider = Provider.of(context);

    fetchGroups();

    var _selectedIndex = 1;

    void _onItemTapped(int index) {
      if (index == 0) {
        Navigator.pushNamed(context, '/todo');
      }
    }

    Future<void> _pushAddGroup(name) async {
      String token = await StorageService.readValue('token');

      await DotEnv().load('.env');

      var url = DotEnv().env['API_URL'] + '/groups';

      var response = await http.post(url,
          headers: <String, String>{
            HttpHeaders.authorizationHeader: 'Bearer ' + token,
            'Content-Type': 'application/json; charset=UTF-8',
          },
          body: jsonEncode(<String, String>{"name": name}));
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

    return new Scaffold(
      appBar: AppBar(
        title: const Text('TodoList APP - Groups'),
      ),
      body: Center(
        child: Column(
          children: <Widget>[
            Container(
              padding: EdgeInsets.all(16.0),
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
              child: Column(),
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

  Future fetchGroups() async {
    User user = User.fromJson(await StorageService.readValue('user'));

    await DotEnv().load('.env');

    String url = DotEnv().env['API_URL'] + "/users/${user.id}";

    var response = await http.get(url, headers: <String, String>{
      HttpHeaders.authorizationHeader: 'Bearer ' + user.token,
      'Content-Type': 'application/json; charset=UTF-8',
    });

    Map<String, dynamic> data = jsonDecode(response.body);
    for (int i = 0; i < data['groups'].length; i++) {
      _groups[data['groups'][i]['@id']] = data['groups'][i]['name'];
    }

//    print(_groups);
  }
}
