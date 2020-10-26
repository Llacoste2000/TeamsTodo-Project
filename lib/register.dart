import 'package:email_validator/email_validator.dart';
import 'package:flutter/material.dart';

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
                    onPressed: () ²{
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
      print('Tous les champs doient être remplis.');
      return;
    } else {
      if (!EmailValidator.validate(email)) {
        print('vous devez renseigner un emai valide');
        return;
      }
      if (password != confirmPassword) {
        print('Les mots de passes ne sont pas identiques');
        return;
      }
      return register();
    }
  }

  register() {
    print('register');
  }
}
