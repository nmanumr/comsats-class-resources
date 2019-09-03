import 'package:dynamic_theme/dynamic_theme.dart';
import 'package:flutter/material.dart';
import 'package:scoped_model/scoped_model.dart';

import '../themes.dart';

class ThemeModel extends Model {
  String selectedTheme = "Default dark";

  Map<String, ThemeData> themesData = {
    "Default dark": defaultDarkTheme(),
    "Default": defaultTheme()
  };

  get themes => themesData.keys;


  setTheme(String theme, BuildContext context) {
    selectedTheme = theme;
    notifyListeners();
    DynamicTheme.of(context).setThemeData(themesData[selectedTheme]);
  }
}
