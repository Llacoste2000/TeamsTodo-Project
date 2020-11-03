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
  bool isPersonnal = true;
  String id;
  Function callback;

  TodoList({this.id, this.isPersonnal, this.callback});

  @override
  createState() => new TodoListState();
}

class TodoListState extends State<TodoList> {
  bool isLoaded = false;
  List<Todo> _todos = [];

  @override
  void initState() {
    super.initState();
    widget.isPersonnal ? fetchPersonnalTodos() : fetchTodos();
  }

  @override
  Widget build(BuildContext context) {
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
          backgroundColor: Color.fromRGBO(25, 86, 170, 1.0),
          focusColor: Color.fromRGBO(25, 86, 170, 0.9),
          hoverColor: Color.fromRGBO(25, 86, 170, 0.8),
          onPressed: _pushAddTodoScreen,
          tooltip: 'Add group',
          child: new Icon(Icons.add, size: 35.0,)),
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
                hintText: 'Enter a To Do.',
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

  Future<String> fetchPersonnalTodos() async {
    List<Todo> todos = [];
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
    try {
      await DotEnv().load('.env');

      String url = DotEnv().env['API_URL'] + "/todolists/" + widget.id;
      User user = User.fromJson(await StorageService.readValue('user'));

      var response = await http.get(url, headers: <String, String>{
        HttpHeaders.authorizationHeader: 'Bearer ' + user.token,
        'Content-Type': 'application/json; charset=UTF-8',
      });

      Map<String, dynamic> data = jsonDecode(response.body);
      data = jsonDecode(response.body);

      for (int i = 0; i < data['todos'].length; i++) {
        Todo todo = new Todo(
          id: data['todos'][i]['id'].toString(),
          name: data['todos'][i]['name'],
          isCompleted: data['todos'][i]['isCompleted'],
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
    return new Center(
      child: Card(
        color: Colors.white,
        borderOnForeground: true,
        shape: Border(left: BorderSide(color: Color.fromRGBO(25, 86, 170, 1.0), width: 10)),
        elevation: 4.0,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            ListTile(
              leading: Icon(Icons.pending_actions_outlined, size: 40.0, color: Color.fromRGBO(25, 86, 170, 1.0)),
              title: Text(
                todo.name,
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
                TextButton(
                  child: Text(
                      'DONE',
                  style: TextStyle(
                    color: Colors.green.shade400,
                    fontWeight: FontWeight.w800,
                    fontSize: 18.0
                  ),),
                  onPressed: () {
                    setState(() {
                      callback();
                      deletePersonnalTodo(todo.id);
                    });
                  },
                ),
                SizedBox(width: 8),
                TextButton(
                  child: Text(
                    'DELETE',
                    style: new TextStyle(
                      color: Colors.red[500],
                      fontWeight: FontWeight.w800,
                      fontSize: 18.0
                    ),
                  ),
                  onPressed: () {
                    setState(() {
                      callback();
                      deletePersonnalTodo(todo.id);
                    });
                  },
                ),
                SizedBox(width: 8),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
