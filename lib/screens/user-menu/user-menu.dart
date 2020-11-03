import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:todo/helpers/storage.dart';
import 'package:todo/state/user/user_provider.dart';

class UserMenu extends StatefulWidget {
  @override
  _UserMenuState createState() => _UserMenuState();
}

class _UserMenuState extends State<UserMenu> {
  @override
  Widget build(BuildContext context) {
    GlobalProvider userProvider = Provider.of(context, listen: false);
    return Scaffold(
      appBar: AppBar(
          backgroundColor: Color.fromRGBO(25, 86, 170, 1.0),
          title: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Image.asset(
                'assets/images/app-logo.png',
                fit: BoxFit.contain,
                height: 42,
              ),
              Container(
                  padding: const EdgeInsets.all(8.0), child: Text(
                'TeamsToDo',
                style: TextStyle(
                    fontSize: 23.0,
                    fontFamily: 'Pacifico',
                    fontWeight: FontWeight.w600,
                    letterSpacing: 2.0
                ),
              ))
            ],
          )
      ),
      body: Center(
        child: Column(
            children: <Widget>[
                Container(
                  padding: EdgeInsets.only(left: 16.0, right: 16.0, top: 20.0, bottom: 20.0),
                  child: Text(
                      'Personnal Info',
                      style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 20.0,
                      color: Colors.black),
                ),
              ),
              Padding(
                padding: const EdgeInsets.fromLTRB(0, 30.0, 0, 10),
                child: new InkWell(
                    onTap: () async {
                      try {
                      GlobalProvider userProvider = Provider.of(context, listen: false);
                      await StorageService.deleteAll();
                      userProvider.deleteUser();
                      } catch (e) {
                      print(e.toString());
                      }
                    },
                    child: new Container(
                      width: 320.0,
                      height: 50.0,
                      alignment: FractionalOffset.center,
                      decoration: new BoxDecoration(
                        color: Color.fromRGBO(25, 86, 170, 0.9),
                        borderRadius: new BorderRadius.all(const Radius.circular(30.0)),
                      ),
                      child: new Text(
                        "Sign Out",
                        style: new TextStyle(
                          color: Colors.white,
                          fontSize: 22.0,
                          fontWeight: FontWeight.w500,
                          fontFamily: 'SourceSansPro',
                          letterSpacing: 1.8,
                        ),
                      ),
                    )),
              ),
            ])));
  }
}
