import 'package:flutter/material.dart';

CircleAvatar textCircularAvatar(String text) {

  final words = (text ?? "").split(" ");
  final avatarText = words.map((f)=>f[0]).join("").substring(0, 2);

  return CircleAvatar(
    child: Text(avatarText),
    backgroundColor: Colors.grey.withAlpha(127),
  );
}
