import 'dart:convert';

import 'package:email_validator/email_validator.dart';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:http/http.dart' as http;
import 'package:todo/users/connect.dart';

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
        Navigator.pushNamed(context, '/login');
      } else {
        var body = jsonDecode(response.body);
        print(body);
        throw body['message'];
      }
    }
  }
}
