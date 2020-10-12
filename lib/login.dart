import 'package:flutter/material.dart';

class Login extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return new Scaffold(
        body: Container(
            color: Colors.blue,
            padding: EdgeInsets.only(left: 50, right: 50, top: 150),
            child: Column(
              children: <Widget>[
                Expanded(
                    child: TextField(
                  obscureText: false,
                  decoration: InputDecoration(
                    fillColor: Colors.white,
                    focusColor: Colors.white,
                    border: OutlineInputBorder(),
                    labelText: 'Login',
                  ),
                )),
                Expanded(
                    child: TextField(
                  obscureText: true,
                  decoration: InputDecoration(
                    border: OutlineInputBorder(),
                    labelText: 'Password',
                  ),
                )),
              ],
            )));
  }
}
