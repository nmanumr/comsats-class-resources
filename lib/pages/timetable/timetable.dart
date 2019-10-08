import 'dart:async';

import 'package:class_resources/components/loader.dart';
import 'package:class_resources/models/event.model.dart';
import 'package:class_resources/models/profile.model.dart';
import 'package:class_resources/pages/timetable/three-days.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter/scheduler.dart' show timeDilation;

class TimeTablePage extends StatefulWidget {
  TimeTablePage({this.userProfile});
  final ProfileModel userProfile;

  @override
  _TimeTablePageState createState() => _TimeTablePageState();
}

class _TimeTablePageState extends State<TimeTablePage> {
  List<EventModel> events = [];
  List<StreamSubscription> subscriptions = [];
  TimeTableView view;

  @override
  void initState() {
    super.initState();

    (() async {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      this.view =
          TimeTableView.from(prefs.getString('timetableView') ?? "OneWeek");
    })();

    var semester = widget.userProfile.service.getCurrentSemester();
    if (semester == null) return;
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

  void changeView(TimeTableView view) {
    print(view);
  }

  @override
  Widget build(BuildContext context) {
    timeDilation = 1.0;
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).canvasColor,
        elevation: 0,
        actions: <Widget>[
          PopupMenuButton(
            onSelected: (TimeTableView val) => changeView(val),
            itemBuilder: (BuildContext context) {
              return [
                PopupMenuItem<TimeTableView>(
                  value: TimeTableView.OneDay,
                  child: ListTile(
                    leading: Icon(Icons.view_agenda),
                    title: Text("One Day"),
                  ),
                ),
                PopupMenuItem<TimeTableView>(
                  value: TimeTableView.TwoDays,
                  child: ListTile(
                    leading: Icon(Icons.view_carousel),
                    title: Text("Two Days"),
                  ),
                ),
                PopupMenuItem<TimeTableView>(
                  value: TimeTableView.OneWeek,
                  child: ListTile(
                    leading: Icon(Icons.view_week),
                    title: Text("One Week"),
                  ),
                ),
                PopupMenuItem<TimeTableView>(
                  value: TimeTableView.Schedule,
                  child: ListTile(
                    leading: Icon(Icons.calendar_view_day),
                    title: Text("Schedule"),
                  ),
                ),
              ];
            },
          ),
        ],
      ),
      body: Builder(builder: (_) {
        if (this.view == null) return Loader();

        var startTime = TimeOfDay(hour: 8, minute: 30);
        var lectureDuration = Duration(hours: 1, minutes: 30);
        var totalLectures = 7;

        if (this.view == TimeTableView.OneWeek)
          return ThreeDaysView(
              lectureDuration, totalLectures, startTime, events);
      }),
    );
  }
}

class TimeTableView {
  final String _value;

  const TimeTableView._internal(this._value);

  String get value => _value;

  get hashCode => _value.hashCode;

  operator ==(status) => status._value == this._value;

  toString() => 'TimeTableView($_value)';

  static TimeTableView from(String value) => TimeTableView._internal(value);

  static const OneDay = const TimeTableView._internal("OneDay");
  static const TwoDays = const TimeTableView._internal("TwoDays");
  static const OneWeek = const TimeTableView._internal("OneWeek");
  static const Schedule = const TimeTableView._internal("Schedule");
}