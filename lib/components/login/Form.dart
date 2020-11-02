import 'package:flutter/material.dart';
import 'InputFields.dart';

class FormSignIn extends StatelessWidget {
  @override
  var login;
  var password;
  FormSignIn(TextEditingController this.login, TextEditingController this.password);
  Widget build(BuildContext context) {
    return (new Container(
      margin: new EdgeInsets.symmetric(horizontal: 20.0),
      width: MediaQuery.of(context).size.width,
      child: new Column(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: <Widget>[
          new Form(
              child: new Column(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: <Widget>[
                  TextField(
                    controller: login,
                    obscureText: false,
                    decoration: InputDecoration(
                      fillColor: Colors.white,
                      filled: true,
                      border: OutlineInputBorder(),
                      labelText: 'Email',
                      icon: new Icon(
                          Icons.person_outline,
                          color: Colors.white)
                    ),
                  ),
                  SizedBox(
                    height: 15.0,
                  ),
                  TextField(
                    controller: password,
                    obscureText: true,
                    decoration: InputDecoration(
                      fillColor: Colors.white,
                      filled: true,
                      border: OutlineInputBorder(),
                      labelText: 'Password',
                      icon: new Icon(
                          Icons.lock_outline,
                          color: Colors.white)
                    ),
                  ),
                ],
              )),
        ],
      ),
    ));
  }
}