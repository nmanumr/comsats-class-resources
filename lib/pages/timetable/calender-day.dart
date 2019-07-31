import 'package:class_resources/models/event.dart';
import 'package:class_resources/utils/colors.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class CalendarDay extends StatelessWidget {
  String getTimeFromIdx(num idx) => idx < 13 ? "$idx AM" : "${idx - 12} PM";

  Widget paddedText(text) {
    return Padding(
      padding: EdgeInsets.fromLTRB(10, 3, 0, 0),
      child: Text(
        text,
        style: TextStyle(fontWeight: FontWeight.w500),
      ),
    );
  }

  Widget buildEventWidget(EventModel event) {
    var startPos = event.startTime.toDate().hour * 48.0;
    startPos += (event.startTime.toDate().minute / 60) * 48.0 + 2;
    var timediff = event.endTime.toDate().difference(event.startTime.toDate());
    var height = timediff.inMinutes / 60 * 48.0 - 5;
    var color = HexColor(generateColor(event.title)).withAlpha(240);
    color.computeLuminance();

    return Container(
      margin: EdgeInsets.fromLTRB(64, startPos, 10, 0),
      decoration: BoxDecoration(
        color: color,
        borderRadius: BorderRadius.circular(5),
      ),
      child: SizedBox(
        height: height,
        width: double.infinity,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            paddedText(event.title),
            paddedText(event.location),
          ],
        ),
      ),
    );
  }

  List<Widget> buildColumns(BuildContext context) {
    List<Widget> children = [];
    for (var i = 0; i < 24; i++) {
      children.add(SizedBox(
        height: 48,
        child: Row(
          children: <Widget>[
            ConstrainedBox(
              constraints: BoxConstraints(minWidth: 60, minHeight: 40),
              child: Align(
                alignment: Alignment.centerRight,
                child: Container(
                  padding: EdgeInsets.only(right: 13),
                  transform: Matrix4.translationValues(0, -24, 0),
                  child: Text(
                    i == 0 ? "" : getTimeFromIdx(i),
                    style: TextStyle(fontSize: 11),
                  ),
                ),
              ),
            ),
            Expanded(
              child: DecoratedBox(
                decoration: BoxDecoration(
                  border: Border(
                    bottom: BorderSide(
                      width: i == 23 ? 0 : 1,
                      color: Theme.of(context).dividerColor,
                    ),
                    left: BorderSide(
                      width: 1,
                      color: Theme.of(context).dividerColor,
                    ),
                  ),
                ),
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: Text(""),
                ),
              ),
            )
          ],
        ),
      ));
    }
    return children;
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Stack(
        children: [
          Column(
            children: buildColumns(context),
          ),
          buildEventWidget(EventModel(
            startTime: Timestamp.fromDate(DateTime(2019, 7, 31, 11, 30)),
            endTime: Timestamp.fromDate(DateTime(2019, 7, 31, 13)),
            title: "Programming Fundamentals",
            location: "N-6",
          )),
          buildEventWidget(EventModel(
            startTime: Timestamp.fromDate(DateTime(2019, 7, 31, 14, 30)),
            endTime: Timestamp.fromDate(DateTime(2019, 7, 31, 16)),
            title: "Professional Practices for IT",
            location: "N-2",
          )),
          buildEventWidget(EventModel(
            startTime: Timestamp.fromDate(DateTime(2019, 7, 31, 16)),
            endTime: Timestamp.fromDate(DateTime(2019, 7, 31, 17, 30)),
            title: "Multivaribale Calculus",
            location: "C-6",
          )),
        ],
      ),
    );
  }
}
