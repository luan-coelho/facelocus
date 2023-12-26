import 'package:flutter/material.dart';

class MessageSnacks {
  static void success(BuildContext context, String message) {
    SnackBar snackBar = build(message, Colors.green);
    ScaffoldMessenger.of(context).showSnackBar(snackBar);
  }

  static void warn(BuildContext context, String message) {
    SnackBar snackBar = build(message, Colors.amber);
    ScaffoldMessenger.of(context).showSnackBar(snackBar);
  }

  static void danger(BuildContext context, String message) {
    SnackBar snackBar = build(message, Colors.red);
    ScaffoldMessenger.of(context).showSnackBar(snackBar);
  }

  static SnackBar build(String message, Color backgroundColor) {
    return SnackBar(
      content: Text(message),
      backgroundColor: backgroundColor,
    );
  }
}
