import 'package:flutter/material.dart';

TimeOfDay timeOfDayFromString(String time) {
  var t = time.split(":");
  return TimeOfDay(hour: int.parse(t[0]), minute: int.parse(t[1]));
}

String timeOfDayToString(TimeOfDay t) {
  return "${t.hour}:${t.minute}";
}
