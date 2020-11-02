import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:todo/state/user/user_provider.dart';

class TodoList extends StatefulWidget {
  @override
  createState() => new TodoListState();
}

class TodoListState extends State<TodoList> {
  List<String> _todoItems = [];

  @override
  Widget build(BuildContext context) {
    var _selectedIndex = 0;

    void _onItemTapped(int index) {
      if (index == 1) {
        Navigator.pushNamed(context, '/group');
      }
    }

    GlobalProvider userProvider = Provider.of(context);
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
        body: _buildTodoList(),
        backgroundColor: Colors.grey[50],
        floatingActionButton: new FloatingActionButton(
          backgroundColor: Color.fromRGBO(25, 86, 170, 1.0),
          focusColor: Color.fromRGBO(25, 86, 170, 0.9),
          hoverColor: Color.fromRGBO(25, 86, 170, 0.8),
          onPressed: _pushAddTodoScreen,
          tooltip: 'Add task',
          child: new Icon(
            Icons.add,
            size: 35.0,
          )),
    );
  }

  void _addTodoItem(String task) {
    // Only add the task if the user actually entered something
    if (task.length > 0) {
      setState(() => _todoItems.add(task));
    }
  }

  void _removeTodoItem(int index) {
    setState(() => _todoItems.removeAt(index));
  }

  void _promptRemoveTodoItem(int index) {
    showDialog(
        context: context,
        builder: (BuildContext context) {
          return new AlertDialog(
              title: new Text('Mark "${_todoItems[index]}" as done?'),
              actions: <Widget>[
                new FlatButton(
                    child: new Text('CANCEL'),
                    onPressed: () => Navigator.of(context).pop()),
                new FlatButton(
                    child: new Text('MARK AS DONE'),
                    onPressed: () {
                      _removeTodoItem(index);
                      Navigator.of(context).pop();
                    })
              ]);
        });
  }

  Widget _buildTodoList() {
    return new ListView.builder(
      // ignore: missing_return
      itemBuilder: (context, index) {
        if (index < _todoItems.length) {
          return _buildTodoItem(_todoItems[index], index);
        }
      },
    );
  }

  Widget _buildTodoItem(String todoText, int index) {
    return new Center(
          child: Card(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: <Widget>[
                ListTile(
                  leading: Icon(Icons.pending_actions_outlined, size: 40.0,),
                  title: Text(todoText),
                  subtitle: Text('Assigné à'),
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: <Widget>[
                    TextButton(
                      child: const Text('DELETE'),
                      onPressed: () {/* ... */},
                    ),
                    SizedBox(width: 8),
                    TextButton(
                      child: const Text('MARK AS DONE'),
                      onPressed: () {
                        _promptRemoveTodoItem(index);
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

  void _pushAddTodoScreen() {
    // Push this page
    Navigator.of(context).push(new MaterialPageRoute(builder: (context) {
      return new Scaffold(
          appBar: new AppBar(title: new Text('Add a new task')),
          body: new TextField(
            autofocus: true,
            onSubmitted: (val) {
              _addTodoItem(val);
              Navigator.pop(context); // Close the add page
            },
            decoration: new InputDecoration(
                hintText: 'Enter something to do...',
                contentPadding: const EdgeInsets.all(16.0)),
          ));
    }));
  }
}
