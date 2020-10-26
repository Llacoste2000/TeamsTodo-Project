import 'package:flash/flash.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

const Color flashError = Colors.red;
const Color flashSuccess = Colors.green;

void showTopFlash(BuildContext context, String title, String text, Color type,
    {FlashStyle style = FlashStyle.floating}) {
  showFlash(
    context: context,
    duration: const Duration(seconds: 2),
    builder: (_, controller) {
      return Flash(
        controller: controller,
        backgroundColor: type,
        brightness: Brightness.light,
        boxShadows: [BoxShadow(blurRadius: 4)],
        barrierBlur: 3.0,
        barrierColor: Colors.white,
        barrierDismissible: true,
        style: style,
        position: FlashPosition.top,
        child: FlashBar(
          title: Text(title, style: TextStyle(color: Colors.white)),
          message: Text(text, style: TextStyle(color: Colors.white)),
          showProgressIndicator: true,
          primaryAction: FlatButton(
            onPressed: () => controller.dismiss(),
            child: Text('DISMISS', style: TextStyle(color: Colors.white)),
          ),
        ),
      );
    },
  );
}
