import 'package:flutter/material.dart';

class MessageSnacks {
  static void success(BuildContext context, String message) {
    SnackBar snackBar = build(message, Colors.white, Colors.green);
    ScaffoldMessenger.of(context).showSnackBar(snackBar);
  }

  static void warn(BuildContext context, String message) {
    SnackBar snackBar = build(message, Colors.black, Colors.amber);
    ScaffoldMessenger.of(context).showSnackBar(snackBar);
  }

  static void danger(BuildContext context, String message) {
    SnackBar snackBar = build(message, Colors.white, Colors.red);
    ScaffoldMessenger.of(context).showSnackBar(snackBar);
  }

  static SnackBar build(
      String message, Color textColor, Color backgroundColor) {
    return SnackBar(
      content: Text(message,
          style: TextStyle(color: textColor, fontWeight: FontWeight.w300)),
      backgroundColor: backgroundColor,
    );
  }
}
