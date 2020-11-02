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
          child: Center(
            child: Form(
              child: Column(
                children: [
                  TextFormField(
                    onChanged: (val) {
                      setState(() {
                        firstname = val;
                      });
                    },
                    decoration: InputDecoration(labelText: 'Prénom'),
                  ),
                  TextFormField(
                    onChanged: (val) {
                      setState(() {
                        lastname = val;
                      });
                    },
                    decoration: InputDecoration(labelText: 'Nom'),
                  ),
                  TextFormField(
                    onChanged: (val) {
                      setState(() {
                        email = val;
                      });
                    },
                    decoration: InputDecoration(labelText: 'Email'),
                  ),
                  TextFormField(
                    obscureText: true,
                    onChanged: (val) {
                      setState(() {
                        password = val;
                      });
                    },
                    decoration: InputDecoration(labelText: 'Mot de passe'),
                  ),
                  TextFormField(
                    obscureText: true,
                    onChanged: (val) {
                      setState(() {
                        confirmPassword = val;
                      });
                    },
                    decoration:
                        InputDecoration(labelText: 'Confirmer le mot de passe'),
                  ),
                  RaisedButton(
                    onPressed: () {
                      submitRegister();
                    },
                    child: Text("S'enregistrer"),
                  )
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

//  Mettre fonctions en async et throw err

  submitRegister() async {
    final GlobalProvider userProvider = Provider.of(context, listen: false);

    if (firstname == '' ||
        lastname == '' ||
        email == '' ||
        password == '' ||
        confirmPassword == '') {
      throw 'Tous les champs doient être remplis.';
    } else {
      if (!EmailValidator.validate(email)) {
        throw 'vous devez renseigner un emai valide';
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
  GlobalProvider userProvider = Provider.of(context, listen: false);

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
