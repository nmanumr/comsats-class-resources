import 'package:flutter/material.dart';

ThemeData lightTheme() {
  return ThemeData(
    brightness: Brightness.light,
    primaryColor: Colors.white,
    primaryColorDark: Color(0xFFF5F5F5),
    accentColor: Colors.blue,

    primaryIconTheme: IconThemeData(
      color: Color(0x99000000)
    )
  );
}

ThemeData darkTheme() {
  return ThemeData(
    brightness: Brightness.dark,
    primaryColor: Colors.black,
    primaryColorLight: Colors.blue,
    accentColor: Colors.blue,
  );
}
