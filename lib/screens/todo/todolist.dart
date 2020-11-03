import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:provider/provider.dart';
import 'package:todo/helpers/flash.dart';
import 'package:todo/helpers/storage.dart';
import 'package:todo/state/todo/todo_model.dart';
import 'package:todo/state/user/user_model.dart';
import 'package:http/http.dart' as http;
import 'package:todo/state/user/user_provider.dart';

class ListTodoList extends StatefulWidget {
  Function callback;

  ListTodoList(this.callback);

  @override
  _ListTodoListState createState() => _ListTodoListState();
}

class TodoListModel {
  String id;
  String name;

  TodoListModel({this.id, this.name = ""});
}

class _ListTodoListState extends State<ListTodoList> {
  bool isLoaded = false;
  List<TodoListModel> _lists = [];

  @override
  void initState() {
    super.initState();
    fetchLists();
  }

  @override
  Widget build(BuildContext context) {
    GlobalProvider provider = Provider.of(context, listen: false);
    return new Scaffold(
      appBar: AppBar(title: const Text('TodoList APP'), actions: <Widget>[
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
                'Team Todo Lists',
                style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 20.0,
                    color: Colors.black),
              ),
            ),
            Expanded(
              child: Center(
                child: isLoaded
                    ? Column(
                        children: [
                          for (int i = 0; i < _lists.length; i++)
                            TodoListCard(_lists[i], () {
                              _lists.removeAt(i);
                              provider.setTodolistId(_lists[i].id);
                            }),
                        ],
                      )
                    : Text('Loading...'),
              ),
            ),
          ],
        ),
      ),
      floatingActionButton: new FloatingActionButton(
          onPressed: _pushAddTodoListScreen,
          tooltip: 'Add group',
          child: new Icon(Icons.add)),
    );
  }

  Future<void> _pushAddTodoList(name) async {
    int index;
    try {
      setState(() {
        _lists.add(new TodoListModel(name: name));
      });
      index = _lists.length - 1;

      User user = User.fromJson(await StorageService.readValue('user'));

      await DotEnv().load('.env');

      String url = DotEnv().env['API_URL'] + "/users/${user.id}";

      var response = await http.post(
        url,
        headers: <String, String>{
          HttpHeaders.authorizationHeader: 'Bearer ' + user.token,
          'Content-Type': 'application/json; charset=UTF-8',
        },
        body: jsonEncode(
          <String, dynamic>{
            //TODO: push values
          },
        ),
      );
      var data = jsonDecode(response.body);
      setState(() {
        _lists[index] = new TodoListModel();
      });
    } catch (e) {
      showTopFlash(context, "Error", "Could not create a Todo", flashError);
      print(e.toString());
    }
  }

  void _pushAddTodoListScreen() {
    // Push this page
    Navigator.of(context).push(new MaterialPageRoute(builder: (context) {
      return new Scaffold(
          appBar: new AppBar(title: new Text('Add a todo...')),
          body: new TextField(
            autofocus: true,
            onSubmitted: (val) {
              _pushAddTodoList(val);
              Navigator.pop(context); // Close the add page
            },
            decoration: new InputDecoration(
                hintText: 'Enter a group name.',
                contentPadding: const EdgeInsets.all(16.0)),
          ));
    }));
  }

  Future deletePersonnalTodo(String id) async {
    List<Todo> todos = [];
    try {
      User user = User.fromJson(await StorageService.readValue('user'));
      await DotEnv().load('.env');
      String url = DotEnv().env['API_URL'] + "/personal_todos/$id";

      await http.delete(url, headers: <String, String>{
        HttpHeaders.authorizationHeader: 'Bearer ' + user.token,
        'Content-Type': 'application/json; charset=UTF-8',
      });
    } catch (e) {
      showTopFlash(context, "Error", "Could not delete Todo", flashError);
      print(e.toString());
    }
  }

  Future<String> fetchLists() async {
    GlobalProvider provider = Provider.of(context, listen: false);
    List<TodoListModel> lists = [];

    try {
      User user = User.fromJson(await StorageService.readValue('user'));

      await DotEnv().load('.env');

      String url = DotEnv().env['API_URL'] + "/teams/1";

      var response = await http.get(url, headers: <String, String>{
        HttpHeaders.authorizationHeader: 'Bearer ' + user.token,
        'Content-Type': 'application/json; charset=UTF-8',
      });

      Map<String, dynamic> dataTeam = jsonDecode(response.body);

      for (int i = 0; i < dataTeam['todolists'].length; i++) {
        String id =
            dataTeam['todolists'][i].toString().split('/').last.toString();
        String url = DotEnv().env['API_URL'] + "/todolists/$id";

        response = await http.get(url, headers: <String, String>{
          HttpHeaders.authorizationHeader: 'Bearer ' + user.token,
          'Content-Type': 'application/json; charset=UTF-8',
        });

        var dataList = jsonDecode(response.body);

        TodoListModel list = new TodoListModel(
          name: dataList['name'],
          id: dataList['id'].toString(),
        );

        lists.add(list);
      }

      setState(() {
        _lists = lists;
        isLoaded = true;
      });
      return response.body;
    } catch (e) {
      print(e);
    }
  }

  Widget TodoListCard(TodoListModel todolist, Function callback) {
    GlobalProvider provider = Provider.of(context, listen: false);
    return new Container(
      padding: EdgeInsets.only(left: 80.0, top: 10.0),
      child: Row(children: <Widget>[
        Expanded(child: Text(todolist.name)),
        Expanded(
            child: FlatButton(
          textColor: Colors.green[600],
          onPressed: () {
            setState(() {
              widget.callback('todos');
            });
          },
          child: Text('See todos'),
        ))
      ]),
    );
  }
}
