import 'package:flutter/material.dart';

ThemeData lightTheme() {
  return ThemeData(
    brightness: Brightness.light,
    primaryColor: Color(0xFF0d47a1),
    accentColor: Colors.lightBlue,
    floatingActionButtonTheme: FloatingActionButtonThemeData(
      backgroundColor: Color(0xFF0d47a1)
    )
  );
}

ThemeData darkTheme() {
  return ThemeData(
    brightness: Brightness.dark,
    canvasColor: Color(0xFF121212),
    primaryColor: Color(0xFF2C2C2C),
    primaryColorDark: Color(0xFF0E397A),
    accentColor: Color(0xFF0F2F60),
    floatingActionButtonTheme: FloatingActionButtonThemeData(
      backgroundColor: Color(0xFF0E397A),
      foregroundColor: Colors.white
    ),
  );
}