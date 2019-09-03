import 'package:class_resources/models/theme.model.dart';
import 'package:flutter/material.dart';
import 'package:scoped_model/scoped_model.dart';

class ThemeSwitcherDialog extends StatelessWidget {
  ThemeSwitcherDialog({Key key, this.themeModel})
      : super(key: key);

  final ThemeModel themeModel;

  @override
  Widget build(BuildContext context) {
    return ScopedModel(
      model: themeModel,
      child: ScopedModelDescendant<ThemeModel>(
        builder: (context, child, userModel) {
          return SimpleDialog(
            title: const Text('Select Theme'),
            children: <Widget>[
              ...themeModel.themes.map<Widget>((theme) {
                return RadioListTile<String>(
                  value: theme,
                  groupValue: themeModel.selectedTheme,
                  onChanged: (theme) => themeModel.setTheme(theme, context),
                  title: Text(theme),
                );
              }).toList(),
            ],
          );
        },
      ),
    );
  }
}
