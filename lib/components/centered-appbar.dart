import 'package:flutter/material.dart';

AppBar centeredAppBar(BuildContext context, String title,
    {List<Widget> actions, Widget leading, bool isCloseable = false}) {
  return AppBar(
    title: Text(title, style: TextStyle(color: Theme.of(context).textTheme.headline.color)),
    centerTitle: true,
    backgroundColor: Theme.of(context).canvasColor,
    elevation: 0,
    actions: actions,
    leading: leading != null
        ? leading
        : isCloseable
            ? IconButton(
                icon: Icon(Icons.close),
                onPressed: () => Navigator.pop(context))
            : null,
  );
}
