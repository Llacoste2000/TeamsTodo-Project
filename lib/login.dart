import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:http/http.dart' as http;
import 'package:provider/provider.dart';
import 'package:todo/helpers/flash.dart';
import 'package:todo/helpers/storage.dart';
import 'package:todo/state/user/user_model.dart';
import 'package:todo/state/user/user_provider.dart';

class Login extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final UserProvider user = Provider.of(context);

    final login = TextEditingController();
    final password = TextEditingController();

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
                      controller: login,
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
                      controller: password,
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
                        __handleLogin(context, login.text, password.text);
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

Future __handleLogin(BuildContext context, login, password) async {
  try {
    User user = await loginToApi(context, login, password);
    //await StorageService.writeValue('user', user.toJson().toString());
    await StorageService.writeValue('firstName', user.firstName);
    await StorageService.writeValue('lastName', user.lastName);
    await StorageService.writeValue('email', user.email);
    await StorageService.writeValue('id', user.id.toString());
    await StorageService.writeValue('token', user.token);

    Navigator.pushNamed(context, '/todo');
  } catch (e) {
    showTopFlash(context, "Failed", e.toString(), flashError);
  }
}

Future loginToApi(BuildContext context, login, password) async {
  UserProvider userProvider = Provider.of(context, listen: false);

  if (login == "" || password == "") {
    throw 'Please enter a valid login and password.';
  }

  await DotEnv().load('.env');

  var url = DotEnv().env['API_URL'] + '/login_check';
  var response = await http.post(url,
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: jsonEncode(<String, String>{"email": login, "password": password}));

  if (response.statusCode == 200) {
    var userData = jsonDecode(response.body);

    User user = User.fromJson(userData);
    userProvider.setUser(user);
    return user;
  } else {
    var body = jsonDecode(response.body);
    throw body['message'];
  }
}
