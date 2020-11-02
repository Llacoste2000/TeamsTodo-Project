import 'package:flutter/material.dart';

class SignIn extends StatelessWidget {
  SignIn();
  @override
  Widget build(BuildContext context) {
    return (new Container(
      width: 320.0,
      height: 50.0,
      alignment: FractionalOffset.center,
      decoration: new BoxDecoration(
        color: Color.fromRGBO(25, 86, 170, 0.9),
        borderRadius: new BorderRadius.all(const Radius.circular(30.0)),
      ),
      child: new Text(
        "Sign In",
        style: new TextStyle(
          color: Colors.white,
          fontSize: 22.0,
          fontWeight: FontWeight.w500,
          fontFamily: 'SourceSansPro',
          letterSpacing: 1.8,
        ),
      ),
    ));
  }
}