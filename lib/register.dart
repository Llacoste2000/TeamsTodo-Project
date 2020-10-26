import 'package:flutter/material.dart';

class Register extends StatefulWidget {
  @override
  _RegisterState createState() => _RegisterState();
}

class _RegisterState extends State<Register> {
  @override
  Widget build(BuildContext context) {
    return Container(
      child: Center(
        child: Form(
          child: Column(
            children: [
              TextFormField(
                onChanged: (val) {},
              ),
              TextFormField(
                obscureText: true,
                onChanged: (val) {},
              ),
              TextFormField(
                obscureText: true,
                onChanged: (val) {},
              ),
            ],
          ),
        ),
      ),
    );
  }
}
