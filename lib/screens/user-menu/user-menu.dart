import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:todo/helpers/storage.dart';
import 'package:todo/state/user/user_provider.dart';

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
        onPressed: () async {
          try {
            GlobalProvider userProvider = Provider.of(context, listen: false);
            await StorageService.deleteAll();
            userProvider.deleteUser();
          } catch (e) {
            print(e.toString());
          }
//          Navigator.pushReplacementNamed(context, '/login');
        },
        child: Text(
          'Se deconnecter',
          style: TextStyle(color: Colors.red[400]),
        ),
      ),
    );
  }
}
