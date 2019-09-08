import 'package:class_resources/pages/timetable/three-days.dart';
import 'package:flutter/material.dart';

class TimeTablePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: ThreeDaysView(
        Duration(hours: 1, minutes: 30),
        7,
        TimeOfDay(hour: 8, minute: 30),
      ),
    );
  }
}
