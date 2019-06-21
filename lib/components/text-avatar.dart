import 'package:class_resources/utils/colors.dart';
import 'package:flutter/material.dart';

CircleAvatar textCircularAvatar(String text, [colorCode, Color foreground]) {  

  print(colorCode);
  Color color;
  if(!(colorCode ?? "").isEmpty)
    color = HexColor(colorCode);


  final words = (text ?? "").split(" ");
  final avatarText = words.map((f)=>f[0]).join("").substring(0, 2);

  return CircleAvatar(
    child: Text(avatarText),
    backgroundColor: color,
    foregroundColor: foreground,
  );
}
