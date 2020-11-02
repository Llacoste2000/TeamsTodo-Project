import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class Tick extends StatelessWidget {
  final DecorationImage image;
  Tick({this.image});
  @override
  Widget build(BuildContext context) {
    return (new Container(
      margin: EdgeInsets.only(left: 40.0),
      width: double.infinity,
      height: 300.0,
      alignment: Alignment.center,
      decoration: new BoxDecoration(
        image: image,
      ),
    ));
  }
}