import 'package:flutter/material.dart';

class AppConfigConst {
  AppConfigConst._();

  // static const String baseApiUrl = 'http://10.0.2.2:8080';
  static const String baseApiUrl = 'http://127.0.0.1:8080'; // dev
  // static const String baseApiUrl = 'http://18.230.249.227:8080'; // prod
}

class AppColorsConst {
  AppColorsConst._();

  // static const Color blue = Color(0xFF0C71FF);
  static const Color dark = Color(0xFF222831);
  static const Color black = Color(0xFF393E46);

  // static const Color blue = Color(0xFF003C84);
  static const Color blue = Color(0xFF0466c8);
  static const MaterialColor purple = MaterialColor(
    0xFF7F27FF,
    <int, Color>{
      400: Color(0xFF9F70FD),
      500: Color(0xFF6312A5),
      600: Color(0xFF6312A5),
      700: Color(0xFF720B98),
      800: Color(0xFF561396),
      900: Color(0xFF391E94),
    },
  );
  static const Color yellow = Color(0xFFFAB411);

  // static const Color white = Color(0xFFF1F2F6);
  static const Color white = Color(0xFFEEEEEE);
// static const Color white = Colors.white;
}
