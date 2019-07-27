import 'package:flutter/material.dart';


AppBar centeredAppBar(BuildContext ctx, String title, {List<Widget> actions}){
  return AppBar(
      title: Text(title),
      centerTitle: true,
      backgroundColor: Theme.of(ctx).canvasColor,
      elevation: 0,
      actions: actions,
    );
}
