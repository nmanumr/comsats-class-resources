import 'package:flutter/material.dart';

import './themes.dart';
import './screens/main.dart';

void main() {
  return runApp(
    MyApp(),
  );
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {

    return MaterialApp(
      title: 'Dynamic themes demo',
      theme: lightTheme(),
      darkTheme: darkTheme(),
      home: MainScreen(),
      debugShowCheckedModeBanner: false,
    );
  }
}
