import 'dart:convert';

import 'package:email_validator/email_validator.dart';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:http/http.dart' as http;
import 'package:provider/provider.dart';
import 'package:todo/helpers/flash.dart';
import 'package:todo/state/user/user_model.dart';
import 'package:todo/state/user/user_provider.dart';

class Register extends StatefulWidget {
  @override
  _RegisterState createState() => _RegisterState();
}

class _RegisterState extends State<Register> {
  String firstname = '';
  String lastname = '';
  String email = '';
  String password = '';
  String confirmPassword = '';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Container(
          decoration:  new BoxDecoration(
            image: new DecorationImage(
                image: new AssetImage('assets/images/login.jpg'),
                fit: BoxFit.cover,
                ),
              ),
          child: new Container(
              decoration: new BoxDecoration(
                  gradient: new LinearGradient(
                    colors: <Color>[
                      const Color.fromRGBO(6, 52, 94, 0.8),
                      const Color.fromRGBO(85, 169, 244, 0.9),
                    ],
                    stops: [0.2, 1.0],
                    begin: const FractionalOffset(0.0, 0.0),
                    end: const FractionalOffset(0.0, 1.0),
                  )),
            child: new ListView(
                  padding: const EdgeInsets.all(0.0),
                  children: <Widget>[
                  new Stack(
                    alignment: AlignmentDirectional.bottomCenter,
                    children: <Widget>[
                    new Column(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: <Widget>[
                        new Container(
                        margin: EdgeInsets.only(left: 40.0),
                        width: double.infinity,
                        height: 200.0,
                        alignment: Alignment.center,
                        decoration: new BoxDecoration(
                          image: new DecorationImage(
                            image: new AssetImage('assets/images/transparent-banner-logo.png'),
                            fit: BoxFit.cover,
                          ),
                        ),
                      ),
                        new Form(
                          child: Container(
                            width: MediaQuery.of(context).size.width * 0.80,
                            child: Column(
                              children: <Widget>[
                                new Container(
                                  decoration: new BoxDecoration(
                                    border: new Border(
                                      bottom: new BorderSide(
                                        width: 0.5,
                                        color: Colors.white,
                                      ),
                                    ),
                                  ),
                                  child: TextFormField(
                                    style: const TextStyle(
                                      color: Colors.white,
                                    ),
                                    onChanged: (val) {
                                      setState(() {
                                        firstname = val;
                                      });
                                    },
                                    decoration: InputDecoration(
                                      icon: new Icon(Icons.person_outline, color: Colors.white),
                                      border: InputBorder.none,
                                      hintText: "Firstname",
                                      hintStyle: const TextStyle(color: Colors.white, fontSize: 15.0),
                                      contentPadding: const EdgeInsets.only(
                                          top: 10.0, right: 30.0, bottom: 10.0, left: 5.0),
                                    ),
                                  ),
                                ),
                                new Container(
                                  decoration: new BoxDecoration(
                                    border: new Border(
                                      bottom: new BorderSide(
                                        width: 0.5,
                                        color: Colors.white,
                                      ),
                                    ),
                                  ),
                                  child: TextFormField(
                                    style: const TextStyle(
                                      color: Colors.white,
                                    ),
                                    onChanged: (val) {
                                      setState(() {
                                        lastname = val;
                                      });
                                    },
                                    decoration: InputDecoration(
                                      icon: new Icon(Icons.person_outline, color: Colors.white),
                                      border: InputBorder.none,
                                      hintText: "Lastname",
                                      hintStyle: const TextStyle(color: Colors.white, fontSize: 15.0),
                                      contentPadding: const EdgeInsets.only(
                                          top: 10.0, right: 30.0, bottom: 10.0, left: 5.0),
                                    ),
                                  ),
                                ),
                                new Container(
                                  decoration: new BoxDecoration(
                                    border: new Border(
                                      bottom: new BorderSide(
                                        width: 0.5,
                                        color: Colors.white,
                                      ),
                                    ),
                                  ),
                                  child: TextFormField(
                                    style: const TextStyle(
                                      color: Colors.white,
                                    ),
                                    onChanged: (val) {
                                      setState(() {
                                        email = val;
                                      });
                                    },
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
                                new Container(
                                  decoration: new BoxDecoration(
                                    border: new Border(
                                      bottom: new BorderSide(
                                        width: 0.5,
                                        color: Colors.white,
                                      ),
                                    ),
                                  ),
                                  child: TextFormField(
                                    style: const TextStyle(
                                      color: Colors.white,
                                    ),
                                    onChanged: (val) {
                                      setState(() {
                                        password = val;
                                      });
                                    },
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
                                new Container(
                                  decoration: new BoxDecoration(
                                    border: new Border(
                                      bottom: new BorderSide(
                                        width: 0.5,
                                        color: Colors.white,
                                      ),
                                    ),
                                  ),
                                  child: TextFormField(
                                    style: const TextStyle(
                                      color: Colors.white,
                                    ),
                                    onChanged: (val) {
                                      setState(() {
                                        confirmPassword = val;
                                      });
                                    },
                                    obscureText: true,
                                    decoration: InputDecoration(
                                      icon: new Icon(Icons.lock_outline, color: Colors.white),
                                      border: InputBorder.none,
                                      hintText: "Confirm password",
                                      hintStyle: const TextStyle(color: Colors.white, fontSize: 15.0),
                                      contentPadding: const EdgeInsets.only(
                                          top: 10.0, right: 30.0, bottom: 10.0, left: 5.0),
                                    ),
                                  ),
                                ),
                                new Padding(
                                  padding: const EdgeInsets.fromLTRB(0, 30.0, 0, 10),
                                  child: new InkWell(
                                      onTap: () {
                                        submitRegister();
                                      },
                                      child: new Container(
                                        width: 320.0,
                                        height: 60.0,
                                        alignment: FractionalOffset.center,
                                        decoration: new BoxDecoration(
                                          color: const Color.fromRGBO(12, 86, 141, 1.0),
                                          borderRadius: new BorderRadius.all(const Radius.circular(30.0)),
                                        ),
                                        child: new Text(
                                          "Register",
                                          style: new TextStyle(
                                            color: Colors.white,
                                            fontSize: 22.0,
                                            fontWeight: FontWeight.w500,
                                            fontFamily: 'SourceSansPro',
                                            letterSpacing: 0.5,
                                          ),
                                        ),
                                      )),
                                ),
                              ],
                            ),
                          )
                        ),
                      ],
                    ),
                    ],
                    ),
                  ],
              ))),
        ));
  }

//  Mettre fonctions en async et throw err

  submitRegister() async {
    final UserProvider userProvider = Provider.of(context, listen: false);

    if (firstname == '' ||
        lastname == '' ||
        email == '' ||
        password == '' ||
        confirmPassword == '') {
      throw 'Tous les champs doient être remplis.';
    } else {
      if (!EmailValidator.validate(email)) {
        throw 'vous devez renseigner un email valide';
      }
      if (password != confirmPassword) {
        throw 'Les mots de passes ne sont pas identiques';
      }

      await DotEnv().load('.env');
      var url = DotEnv().env['API_URL'] + '/users';

      var response = await http.post(url,
          headers: <String, String>{
            'Content-Type': 'application/json; charset=UTF-8',
          },
          body: jsonEncode({
            "firstname": firstname,
            "lastname": lastname,
            "email": email,
            "password": password
          }));

      if (response.statusCode == 201) {
        var decodedResponse = jsonDecode(response.body);
        userProvider.setUser(new User(
          email: decodedResponse['email'],
          firstName: decodedResponse['firstname'],
          lastName: decodedResponse['lastname'],
          id: decodedResponse['id'],
        ));
        __handleLogin(context, email, password);
      } else {
        var body = jsonDecode(response.body);
        throw body['message'];
      }
    }
  }
}

Future __handleLogin(BuildContext context, login, password) async {
  try {
    await loginToApi(context, login, password);
    Navigator.pushNamed(context, '/todo');
    showTopFlash(context, "Authentifié", "Bienvenue !", flashSuccess);
  } catch (e) {
    Navigator.pushNamed(context, '/login');
    showTopFlash(context, "Auth fail :", "Authentification échoué (console)",
        flashError);
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
