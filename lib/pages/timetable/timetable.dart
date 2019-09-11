import 'dart:async';

import 'package:class_resources/models/event.model.dart';
import 'package:class_resources/models/profile.model.dart';
import 'package:class_resources/pages/timetable/three-days.dart';
import 'package:flutter/material.dart';

class TimeTablePage extends StatefulWidget {
  TimeTablePage({this.userProfile});

  final ProfileModel userProfile;

  @override
  _TimeTablePageState createState() => _TimeTablePageState();
}

class _TimeTablePageState extends State<TimeTablePage> {
  List<EventModel> events = [];

  List<StreamSubscription> subscriptions = [];

  @override
  void initState() {
    super.initState();

    var semester = widget.userProfile.service.getCurrentSemester();
    for (var course in semester.courses) {
      subscriptions.add(course.service.getTimetable().listen(
        (data) {
          setState(() {
            events.addAll(data);
          });
        },
      ));
    }
  }

  @override
  void dispose() {
    for (var sub in subscriptions) sub.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: ThreeDaysView(Duration(hours: 1, minutes: 30), 7,
          TimeOfDay(hour: 8, minute: 30), events),
    );
  }
}
