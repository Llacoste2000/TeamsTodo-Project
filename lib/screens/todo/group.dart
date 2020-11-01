import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:todo/state/user/user_provider.dart';

class Group extends StatefulWidget {
  @override
  _GroupState createState() => _GroupState();
}

class _GroupState extends State<Group> {
  @override
  Widget build(BuildContext context) {
    UserProvider userProvider = Provider.of(context);

    var _selectedIndex = 1;

    void _onItemTapped(int index) {
      if (index == 0) {
        Navigator.pushNamed(context, '/todo');
      }
    }

    return new Scaffold(
      appBar: AppBar(
        title: const Text('TodoList APP'),
        actions: <Widget>[
          IconButton(
            icon: const Icon(Icons.person),
            tooltip: 'Connexion',
            onPressed: () {},
          ),
        ],
      ),
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
}
