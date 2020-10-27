import 'package:flutter/material.dart';
import 'package:todo/helpers/storage.dart';

class UserMenu extends StatefulWidget {
  @override
  _UserMenuState createState() => _UserMenuState();
}

class _UserMenuState extends State<UserMenu> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('User Menu'),
      ),
      body: RawMaterialButton(
        onPressed: () {
          StorageService.deleteAll();
          Navigator.pushReplacementNamed(context, '/login');
        },
        child: Text(
          'Se deconnecter',
          style: TextStyle(color: Colors.red[400]),
        ),
      ),
    );
  }
}
