import 'package:class_resources/models/event.model.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import 'calender-day.dart';

class ThreeDaysView extends StatelessWidget {
  ThreeDaysView(
      this.lectureDuration, this.totalLectures, this.startTime, this.events);

  final Duration lectureDuration;
  final num totalLectures;
  final TimeOfDay startTime;
  final ScrollController calenderDaysScoller = ScrollController();
  final ScrollController calenderLagendScoller = ScrollController();
  final List<EventModel> events;

  getslotStartTime(num slot) {
    final now = DateTime.now();
    var startDate = DateTime(
        now.year, now.month, now.day, startTime.hour, startTime.minute);
    var time = startDate.add(lectureDuration * slot);

    return DateFormat.jm().format(time);
  }

  buildLectureLagend(num lectureNum) {
    return Container(
      height: 120,
      width: 70,
      // color: Colors.red,
      child: Stack(
        children: <Widget>[
          Align(
            alignment: Alignment.topCenter,
            child: Container(
              padding: EdgeInsets.only(right: 13),
              child: Text(
                getslotStartTime(lectureNum - 1),
                style: TextStyle(fontSize: 11),
              ),
            ),
          ),
          Align(
            alignment: Alignment.center,
            child: Text(lectureNum.toString()),
          ),
          Align(
            alignment: Alignment.bottomCenter,
            child: Container(
              padding: EdgeInsets.only(right: 13),
              child: Text(
                totalLectures == lectureNum ? getslotStartTime(lectureNum) : "",
                style: TextStyle(fontSize: 11),
              ),
            ),
          ),
        ],
      ),
    );
  }

  buildLagends() {
    var lagends =
        List<Widget>.generate(totalLectures, (i) => buildLectureLagend(i + 1));

    return Container(
      child: Column(
        children: lagends,
      ),
    );
  }

  buildCalederDay(index, width) {
    var date =
        DateTime.now().subtract(Duration(days: DateTime.now().weekday - index - 1));
    var dayEvents = events.where((e) => e.weekday == index + 1).toList();
    return SizedBox(
      width: 150,
      child: CalendarDay(day: date, events: dayEvents),
    );
  }

  buildDayLangends(width, context) {
    var days = ["MON", "TUE", "WED", "THU", "FRI"];
    List<Widget> dayLagends = [];
    for (var i = 0; i < days.length; i++) {
      var day = days[i];
      bool isCrntDay = DateTime.now().weekday - 1 == i;
      dayLagends.add(SizedBox(
        width: 150,
        height: 70,
        child: Material(
          elevation: 2,
          color: Theme.of(context).primaryColorLight,
          child: Center(
            child: Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(15.0),
                color: isCrntDay
                    ? Theme.of(context).accentColor
                    : Colors.transparent,
              ),
              padding: EdgeInsets.symmetric(horizontal: 15, vertical: 5),
              child: Text(day),
            ),
          ),
        ),
      ));
    }

    return SizedBox(
      height: 46,
      child: Row(
        children: <Widget>[
          SizedBox(
            width: 70,
            child: Material(
              elevation: 2,
              color: Theme.of(context).primaryColorLight,
            ),
          ),
          Expanded(
            child: ListView(
              controller: calenderLagendScoller,
              scrollDirection: Axis.horizontal,
              physics: NeverScrollableScrollPhysics(),
              children: dayLagends,
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    double height = MediaQuery.of(context).size.height;

    calenderDaysScoller.addListener(() {
      calenderLagendScoller.jumpTo(
        calenderDaysScoller.position.pixels,
      );
    });

    return SizedBox(
      height: height,
      width: width,
      child: Column(
        children: <Widget>[
          Container(
            height: 50,
            width: double.infinity,
            child: Material(
              color: Theme.of(context).primaryColorLight,
            ),
          ),
          buildDayLangends(width, context),
          Expanded(
            child: SingleChildScrollView(
              scrollDirection: Axis.vertical,
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: <Widget>[
                  buildLagends(),
                  SizedBox(
                    width: width - 70,
                    height: 120.0 * totalLectures,
                    child: SingleChildScrollView(
                      controller: calenderDaysScoller,
                      scrollDirection: Axis.horizontal,
                      child: Row(
                        children: List<Widget>.generate(
                            5, (i) => buildCalederDay(i, width)),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
