import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:todo/helpers/flash.dart';
import 'package:todo/helpers/storage.dart';
import 'package:todo/state/todo/todo_model.dart';
import 'package:todo/state/user/user_model.dart';
import 'package:http/http.dart' as http;

class TodoList extends StatefulWidget {
  bool isPersonnal;
  String id;

  TodoList({this.id, this.isPersonnal = true});

  @override
  createState() => new TodoListState();
}

class TodoListState extends State<TodoList> {
  bool isLoaded = false;
  List<Todo> _todos = [];

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    widget.isPersonnal ? fetchPersonnalTodos() : fetchTodos();
  }

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      appBar: AppBar(
        title: const Text('TodoList APP'),
      ),
      body: Center(
        child: Column(
          children: <Widget>[
            Container(
              padding: EdgeInsets.only(left: 16.0, right: 16.0, top: 10.0),
              child: Text(
                'My personnal Todos',
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
                    for (int i = 0; i < _todos.length; i++)
                      TodoCard(_todos[i], () {
                        _todos.removeAt(i);
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
          onPressed: _pushAddTodoScreen,
          tooltip: 'Add group',
          child: new Icon(Icons.add)),
    );
  }

  Future<void> _pushAddTodo(name) async {
    int index;
    try {
      setState(() {
        _todos.add(new Todo(
          name: name,
          isCompleted: false,
        ));
      });
      index = _todos.length - 1;

      print('------1------');
      print(_todos[index].id);
      print(_todos[index].name);
      print(_todos[index].isCompleted);

      User user = User.fromJson(await StorageService.readValue('user'));

      await DotEnv().load('.env');

      String url = DotEnv().env['API_URL'] + "/users/${user.id}";

      var response = await http.get(url, headers: <String, String>{
        HttpHeaders.authorizationHeader: 'Bearer ' + user.token,
        'Content-Type': 'application/json; charset=UTF-8',
      });

      Map<String, dynamic> data = jsonDecode(response.body);
      String ptodolistId = data['ptodolists'][0]['@id'].toString();
      url = DotEnv().env['API_URL'] + "/personal_todos";
      response = await http.post(
        url,
        headers: <String, String>{
          HttpHeaders.authorizationHeader: 'Bearer ' + user.token,
          'Content-Type': 'application/json; charset=UTF-8',
        },
        body: jsonEncode(
          <String, dynamic>{
            "name": name,
            "isCompleted": false,
            "affectedTodolist": ptodolistId
          },
        ),
      );
      data = jsonDecode(response.body);
      setState(() {
        _todos[index] = new Todo(
          id: data['id'].toString(),
          name: data['name'],
          isCompleted: false,
        );
      });
      print('------2------');
      print(_todos[index].id);
      print(_todos[index].name);
      print(_todos[index].isCompleted);
    } catch (e) {
      showTopFlash(context, "Error", "Could not create a Todo", flashError);
      print(e.toString());
    }
  }

  void _pushAddTodoScreen() {
    // Push this page
    Navigator.of(context).push(new MaterialPageRoute(builder: (context) {
      return new Scaffold(
          appBar: new AppBar(title: new Text('Add a todo...')),
          body: new TextField(
            autofocus: true,
            onSubmitted: (val) {
              _pushAddTodo(val);
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
    print('oui');
    try {
      User user = User.fromJson(await StorageService.readValue('user'));
      await DotEnv().load('.env');
      String url = DotEnv().env['API_URL'] + "/personal_todos/$id";

      await http.delete(url, headers: <String, String>{
        HttpHeaders.authorizationHeader: 'Bearer ' + user.token,
        'Content-Type': 'application/json; charset=UTF-8',
      });

      print('deleted');
    } catch (e) {
      showTopFlash(context, "Error", "Could not delete Todo", flashError);
      print(e.toString());
    }
  }

  Future<String> fetchPersonnalTodos() async {
    List<Todo> todos = [];
    print('oui');
    try {
      User user = User.fromJson(await StorageService.readValue('user'));

      await DotEnv().load('.env');

      String url = DotEnv().env['API_URL'] + "/users/${user.id}";

      var response = await http.get(url, headers: <String, String>{
        HttpHeaders.authorizationHeader: 'Bearer ' + user.token,
        'Content-Type': 'application/json; charset=UTF-8',
      });

      Map<String, dynamic> data = jsonDecode(response.body);
      String ptodolistId = data['ptodolists'][0]['id'].toString();

      url = DotEnv().env['API_URL'] + "/personal_todolists/$ptodolistId";
      response = await http.get(url, headers: <String, String>{
        HttpHeaders.authorizationHeader: 'Bearer ' + user.token,
        'Content-Type': 'application/json; charset=UTF-8',
      });
      data = jsonDecode(response.body);
      for (int i = 0; i < data['ptodos'].length; i++) {
        Todo todo = new Todo(
          id: data['ptodos'][i]['id'].toString(),
          name: data['ptodos'][i]['name'],
          isCompleted: data['ptodos'][i]['isCompleted'],
        );

        todos.add(todo);
      }
      setState(() {
        _todos = todos;
        isLoaded = true;
      });
    } catch (e) {
      print(e.toString());
    }
  }

  Future<String> fetchTodos() async {
    List<Todo> todos = [];
    print('oui');
    try {
      User user = User.fromJson(await StorageService.readValue('user'));

      await DotEnv().load('.env');

      String url = DotEnv().env['API_URL'] + "/users/${user.id}";

      var response = await http.get(url, headers: <String, String>{
        HttpHeaders.authorizationHeader: 'Bearer ' + user.token,
        'Content-Type': 'application/json; charset=UTF-8',
      });

      Map<String, dynamic> data = jsonDecode(response.body);
      String ptodolistId = data['ptodolists'][0]['id'].toString();

      url = DotEnv().env['API_URL'] + "/personal_todolists/$ptodolistId";
      response = await http.get(url, headers: <String, String>{
        HttpHeaders.authorizationHeader: 'Bearer ' + user.token,
        'Content-Type': 'application/json; charset=UTF-8',
      });
      data = jsonDecode(response.body);
      for (int i = 0; i < data['ptodos'].length; i++) {
        Todo todo = new Todo(
          id: data['ptodos'][i]['id'].toString(),
          name: data['ptodos'][i]['name'],
          isCompleted: data['ptodos'][i]['isCompleted'],
        );

        todos.add(todo);
      }
      setState(() {
        _todos = todos;
        isLoaded = true;
      });
      return response.body;
    } catch (e) {
      print(e.toString());
    }
  }

  Widget TodoCard(Todo todo, Function callback) {
    return new Container(
      padding: EdgeInsets.only(left: 80.0, top: 10.0),
      child: Row(children: <Widget>[
        Expanded(child: Text(todo.name)),
        Expanded(
            child: FlatButton(
              textColor: Colors.green[600],
              onPressed: () {
                setState(() {
                  callback();
                  deletePersonnalTodo(todo.id);
                });
              },
              child: Text('Complete'),
            ))
      ]),
    );
  }
}