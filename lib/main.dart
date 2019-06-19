import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import './themes/themes.dart';
import './themes/custome_theme.dart';
import './screens/main.dart';

void main() {
  SystemChrome.setSystemUIOverlayStyle(
    SystemUiOverlayStyle.light.copyWith(
      systemNavigationBarColor: Color(0xFFFFFFFF),
      statusBarColor: Color(0xFFF5F5F5)
    )
  );
  return runApp(
    CustomTheme(
      initialThemeKey: MyThemeKeys.LIGHT,
      child: MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        title: 'Dynamic themes demo',
        theme: CustomTheme.of(context),
        home: MainScreen(),
        debugShowCheckedModeBanner: false);
  }
}
