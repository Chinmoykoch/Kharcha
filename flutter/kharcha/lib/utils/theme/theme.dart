import 'package:flutter/material.dart';

class KharchaTheme {
  KharchaTheme._();

  static ThemeData darkTheme = ThemeData(
    useMaterial3: true,
    fontFamily: 'Urbanist',
    disabledColor: Colors.grey,
    appBarTheme: AppBarTheme(backgroundColor: Color(0XFF1A1A1A)),
    brightness: Brightness.dark,
    scaffoldBackgroundColor: Color(0XFF1A1A1A),
  );
}
