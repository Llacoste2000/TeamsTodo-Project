import 'dart:convert';

import 'package:flutter/material.dart';

import 'package:http/http.dart' as http;
import 'package:provider/provider.dart';
import 'styles.dart';
import 'loginAnimation.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/animation.dart';
import 'dart:async';
import '../../components/SignUpLink.dart';
import '../../components/Form.dart';
import '../../components/SignInButton.dart';
import '../../components/WhiteTick.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter/services.dart';
import 'package:flutter/scheduler.dart' show timeDilation;
import 'package:todo/state/user_model.dart';
import 'package:todo/users/connect.dart';
import 'package:jwt_decoder/jwt_decoder.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({Key key}) : super(key: key);
  @override
  LoginScreenState createState() => new LoginScreenState();
}

class LoginScreenState extends State<LoginScreen>
    with TickerProviderStateMixin {
  AnimationController _loginButtonController;
  var animationStatus = 0;
  @override
  void initState() {
    super.initState();
    _loginButtonController = new AnimationController(
        duration: new Duration(milliseconds: 3000), vsync: this);
  }

  @override
  void dispose() {
    _loginButtonController.dispose();
    super.dispose();
  }

  Future<Null> _playAnimation() async {
    try {
      await _loginButtonController.forward();
      await _loginButtonController.reverse();
    } on TickerCanceled {}
  }

  Future<bool> _onWillPop() {
    return showDialog(
      context: context,
      child: new AlertDialog(
        title: new Text('Are you sure?'),
        actions: <Widget>[
          new FlatButton(
            onPressed: () => Navigator.of(context).pop(false),
            child: new Text('No'),
          ),
          new FlatButton(
            onPressed: () =>
                Navigator.pushReplacementNamed(context, "/todo"),
            child: new Text('Yes'),
          ),
        ],
      ),
    ) ??
        false;
  }

  @override
  Widget build(BuildContext context) {
    timeDilation = 0.4;
    SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle.light);
    final UserModel user = Provider.of(context);

    final login = TextEditingController();
    final password = TextEditingController();

    return (new WillPopScope(
        onWillPop: _onWillPop,
        child: new Scaffold(
          body: new Container(
              decoration: new BoxDecoration(
                image: backgroundImage,
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
                              new Tick(image: tick),
                              new FormSignIn(),
                              new SignUp()
                            ],
                          ),
                          animationStatus == 0
                              ? new Padding(
                            padding: const EdgeInsets.only(bottom: 50.0),
                            child: new InkWell(
                                onTap: () {
                                  setState(() {
                                    animationStatus = 1;
                                  });
                                  _playAnimation();
                                },
                                child: new SignIn()),
                          )
                              : new StaggerAnimation(
                              buttonController:
                              _loginButtonController.view),
                        ],
                      ),
                    ],
                  ))),
        )));
  }
}

void __handleLogin(BuildContext context) {
  Navigator.pushNamed(context, '/todo');
}

Future loginToApi(BuildContext context, login, password) async {
  UserModel userProvider = Provider.of(context, listen: false);

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
    // la logique viendra ici pour connecter à l'API ...
    var token = jsonDecode(response.body);
    Map<String, dynamic> decodedToken = JwtDecoder.decode(response.body);

    decodedToken['token'] = token['token'];

    User user = User.fromJson(decodedToken);
    userProvider.setUser(user);
    return user;
  } else {
    var body = jsonDecode(response.body);
    throw body['message'];
  }
}

// class Login extends StatelessWidget {
//   @override
//   Widget build(BuildContext context) {
//     return new Scaffold(
//         body: Container(
//             color: Colors.blue,
//             alignment: Alignment.center,
//             child: Column(
//               crossAxisAlignment: CrossAxisAlignment.center,
//               mainAxisAlignment: MainAxisAlignment.center,
//               children: <Widget>[
//                 Container(
//                     padding: EdgeInsets.all(10),
//                     child: TextField(
//                       decoration: InputDecoration(
//                         fillColor: Colors.white,
//                         filled: true,
//                         border: OutlineInputBorder(),
//                         labelText: 'Login',
//                       ),
//                     )),
//                 Container(
//                     padding: EdgeInsets.all(10),
//                     child: TextField(
//                       obscureText: true,
//                       decoration: InputDecoration(
//                         fillColor: Colors.white,
//                         filled: true,
//                         border: OutlineInputBorder(),
//                         labelText: 'Password',
//                       ),
//                     )),
//                 Container(
//                     padding: EdgeInsets.all(10),
//                     child: FlatButton(
//                       color: Colors.white,
//                       textColor: Colors.blue,
//                       disabledColor: Colors.grey,
//                       disabledTextColor: Colors.black,
//                       padding: EdgeInsets.all(10.0),
//                       splashColor: Colors.blueAccent,
//                       onPressed: () {
//                         __handleLogin(context);
//                       },
//                       child: Text(
//                         "Login",
//                         style: TextStyle(fontSize: 20.0),
//                       ),
//                     )),
//               ],
//             )));
//   }
// }
//
// void __handleLogin(BuildContext context) {
//   Navigator.pushNamed(context, '/todo');
// }
