import 'package:flutter/material.dart';

ThemeData lightTheme() {
  return ThemeData(
    brightness: Brightness.light,
    primaryColor: Color(0xFF0d47a1),
    accentColor: Colors.lightBlue,
  );
}

ThemeData darkTheme() {
  return ThemeData(
    brightness: Brightness.dark,
    primaryColor: Colors.indigo,
    accentColor: Colors.indigo,
  );
}
