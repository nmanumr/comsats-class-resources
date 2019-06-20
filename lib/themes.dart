import 'package:flutter/material.dart';

ThemeData lightTheme() {
  return ThemeData(
    brightness: Brightness.light,
    primaryColor: Colors.indigo,
    primaryColorDark: Color(0xFFF5F5F5),
    accentColor: Colors.blue,
  );
}

ThemeData darkTheme() {
  return ThemeData(
    brightness: Brightness.dark,
    primaryColor: Colors.indigo,
    primaryColorLight: Colors.blue,
    accentColor: Colors.blue,
  );
}
