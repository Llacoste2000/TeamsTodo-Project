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
                  new Container(
                    width: MediaQuery.of(context).size.width * 0.80,
                    decoration: new BoxDecoration(
                      border: new Border(
                        bottom: new BorderSide(
                          width: 0.5,
                          color: Colors.white,
                        ),
                      ),
                    ),
                    child: TextFormField(
                      controller: login,
                      style: const TextStyle(
                        color: Colors.white,
                      ),
                      obscureText: false,
                      decoration: InputDecoration(
                        icon: new Icon(Icons.alternate_email, color: Colors.white),
                        border: InputBorder.none,
                        hintText: "Email",
                        hintStyle: const TextStyle(color: Colors.white, fontSize: 15.0),
                        contentPadding: const EdgeInsets.only(
                            top: 10.0, right: 30.0, bottom: 10.0, left: 5.0),
                      ),
                    ),
                  ),
                  SizedBox(
                    height: 15.0,
                  ),
                  new Container(
                    width: MediaQuery.of(context).size.width * 0.80,
                    decoration: new BoxDecoration(
                      border: new Border(
                        bottom: new BorderSide(
                          width: 0.5,
                          color: Colors.white,
                        ),
                      ),
                    ),
                    child: TextFormField(
                      controller: password,
                      style: const TextStyle(
                        color: Colors.white,
                      ),
                      obscureText: true,
                      decoration: InputDecoration(
                        icon: new Icon(Icons.lock_outline, color: Colors.white),
                        border: InputBorder.none,
                        hintText: "Password",
                        hintStyle: const TextStyle(color: Colors.white, fontSize: 15.0),
                        contentPadding: const EdgeInsets.only(
                            top: 10.0, right: 30.0, bottom: 10.0, left: 5.0),
                      ),
                    ),
                  ),
                ],
              )),
        ],
      ),
    ));
  }
}