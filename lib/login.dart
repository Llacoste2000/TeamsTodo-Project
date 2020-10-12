import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:http/http.dart' as http;
import 'package:todo/helpers/flash.dart';
import 'package:todo/users/connect.dart';

class Login extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return new Scaffold(
        body: Container(
            color: Colors.blue,
            alignment: Alignment.center,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Container(
                    padding: EdgeInsets.all(10),
                    child: TextField(
                      decoration: InputDecoration(
                        fillColor: Colors.white,
                        filled: true,
                        border: OutlineInputBorder(),
                        labelText: 'Login',
                      ),
                    )),
                Container(
                    padding: EdgeInsets.all(10),
                    child: TextField(
                      obscureText: true,
                      decoration: InputDecoration(
                        fillColor: Colors.white,
                        filled: true,
                        border: OutlineInputBorder(),
                        labelText: 'Password',
                      ),
                    )),
                Container(
                    padding: EdgeInsets.all(10),
                    child: FlatButton(
                      color: Colors.white,
                      textColor: Colors.blue,
                      disabledColor: Colors.grey,
                      disabledTextColor: Colors.black,
                      padding: EdgeInsets.all(10.0),
                      splashColor: Colors.blueAccent,
                      onPressed: () {
                        __handleLogin(context);
                      },
                      child: Text(
                        "Login",
                        style: TextStyle(fontSize: 20.0),
                      ),
                    )),
              ],
            )));
  }
}

void __handleLogin(BuildContext context) {
  Future main() async {
    await DotEnv().load('.env');

    Future<User> fetchUser() async {
      final response = await http.get(DotEnv().env['VAR_NAME'] + '/users');

      if (response.statusCode == 200) {
        // la logique viendra ici pour connecter à l'API ...

        User user = User.fromJson(jsonDecode(response.body));

        return user;
      } else {
        showTopFlash(context, "Failed", "Error while loging in", flashError);
      }
    }
  }

  // la logique viendra ici pour connecter à l'API ...
  Navigator.pushNamed(context, '/todo');
}
