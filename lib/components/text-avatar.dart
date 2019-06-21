import 'package:class_resources/utils/colors.dart';
import 'package:flutter/material.dart';

CircleAvatar textCircularAvatar(String text, [colorCode, Color foreground]) {
  Color color;
  if (!(colorCode ?? "").isEmpty) color = HexColor(colorCode);

  final words = (text ?? "").split(" ");
  String avatarText = words.map((f) => ((f.length > 0) ? f[0] : "")).join("");

  if (avatarText.length > 2) avatarText = avatarText.substring(0, 2);

  return CircleAvatar(
    child: Text(avatarText),
    backgroundColor: color,
    foregroundColor: foreground,
  );
}
