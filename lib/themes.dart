import 'package:flutter/material.dart';

ThemeData lightTheme(Brightness brightness) {
  // return ThemeData(
  //   brightness: brightness,
  //   canvasColor: Color(0xFFFFFFFF),
  //   primaryColor: Color(0xFF3F83B1),
  //   primaryColorLight: Color(0xFF3F83B1),
  //   primaryColorDark: Color(0xFF346C92),
  //   accentColor: Color(0xFF4FA9E6),
  //   floatingActionButtonTheme: FloatingActionButtonThemeData(
  //     backgroundColor: Color(0xFF4FA9E6),
  //     foregroundColor: Colors.white,
  //   ),
  //   dividerColor: Color(0xFFDEE3EA),
  // );
  return ThemeData(
    fontFamily: 'ProductSans',
    brightness: brightness,
    canvasColor: Color(0xFF1C2733),
    primaryColor: Color(0xFF195BBC),
    primaryColorLight: Color(0xFF222E3C),
    primaryColorDark: Color(0xFF151D26),
    accentColor: Color(0xFF61A9E1),
    floatingActionButtonTheme: FloatingActionButtonThemeData(
      backgroundColor: Color(0xFF61A9E1),
      foregroundColor: Colors.white,
    ),
    dividerColor: Color(0xFF10171E),
    textTheme: TextTheme(
      caption: TextStyle(
        color: Colors.white.withOpacity(0.5)
      )
    )
  );
}

ThemeData darkTheme() {
  return ThemeData(
    brightness: Brightness.dark,
    canvasColor: Color(0xFF1C2733),
    primaryColor: Color(0xFF195BBC),
    primaryColorLight: Color(0xFF222E3C),
    primaryColorDark: Color(0xFF151D26),
    accentColor: Color(0xFF61A9E1),
    floatingActionButtonTheme: FloatingActionButtonThemeData(
      backgroundColor: Color(0xFF61A9E1),
      foregroundColor: Colors.white,
    ),
    dividerColor: Color(0xFF10171E),
    buttonTheme: ButtonThemeData(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.all(Radius.circular(6))
      ),
    ),
    textSelectionHandleColor: Color(0xFF61A9E1),
  );
}
