import 'package:class_resources/utils/colors.dart';
import 'package:flutter/material.dart';

class TextAvatar extends StatelessWidget {
  TextAvatar({@required this.text});

  final String text;

  String getAvatarText(String text) {
    var words = (text ?? "").split(" ");
    words.remove("&");
    if (words.length > 2) words = words.sublist(0, 2);
    return words.map((f) => ((f.length > 0) ? f[0] : "")).join("").toUpperCase();
  }

  @override
  Widget build(BuildContext context) {
    String avatarText = getAvatarText(this.text);
    Color color = HexColor(generateColor(text));

    return CircleAvatar(
      child: Text(avatarText),
      backgroundColor: color.withAlpha(175),
      foregroundColor: Colors.white,
    );
  }
}