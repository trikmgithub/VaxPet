import 'package:flutter/material.dart';

class AppNavigator {

  static void pushReplacement(BuildContext context,Widget widget) {
    //A -> C
    Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => widget)
    );
  }

  static void push(BuildContext context,Widget widget) {
    //A -> B -> C
    Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => widget)
    );
  }

  static void pushAndRemove(BuildContext context,Widget widget) {
    //C
    Navigator.pushAndRemoveUntil(
        context,
        MaterialPageRoute(builder: (context) => widget),
            (Route<dynamic> route) => false
    );
  }
}