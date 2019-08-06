import 'package:flutter/material.dart';


AppBar centeredAppBar(BuildContext ctx, String title, {List<Widget> actions, Widget leading}){
  return AppBar(
      title: Text(title),
      centerTitle: true,
      backgroundColor: Theme.of(ctx).canvasColor,
      elevation: 0,
      actions: actions,
      leading: leading
    );
}
