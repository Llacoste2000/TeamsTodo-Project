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

    UserProvider userProvider = Provider.of(context);
    return new Scaffold(
      appBar: AppBar(
        title: const Text('TodoList APP'),
      ),
      body: _buildTodoList(),
      floatingActionButton: new FloatingActionButton(
          onPressed: _pushAddTodoScreen,
          tooltip: 'Add task',
          child: new Icon(Icons.add)),
      bottomNavigationBar: BottomNavigationBar(
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Icon(Icons.list),
            label: 'Personal List',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.group),
            label: 'Groups',
          ),
        ],
        currentIndex: _selectedIndex,
        selectedItemColor: Colors.blue[800],
        onTap: _onItemTapped,
      ),
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
    return new ListTile(
        title: new Text(todoText), onTap: () => _promptRemoveTodoItem(index));
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
