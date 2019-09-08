import 'package:flutter/material.dart';
import 'package:class_resources/models/event.model.dart';
import 'package:class_resources/pages/timetable/event-detail.dart';

class CalendarDay extends StatelessWidget {
  final List<EventModel> events;
  final DateTime day;

  CalendarDay({@required this.events, @required this.day});

  Widget paddedText(text) {
    return Padding(
      padding: EdgeInsets.fromLTRB(10, 3, 0, 0),
      child: Text(
        text,
        style: TextStyle(fontWeight: FontWeight.w500),
      ),
    );
  }

  Widget buildEventWidget(EventModel event, context) {
    var startPos = event.startTime.hour * 48.0;
    startPos += (event.startTime.minute / 60) * 48.0 + 2;
    var height;
    if (event.endTime == null) {
      height = 48.0;
    } else {
      var timediff = event.endTime.difference(event.startTime);
      height = timediff.inMinutes / 60 * 48.0 - 5;
    }

    return Container(
      margin: EdgeInsets.fromLTRB(64, startPos, 10, 0),
      child: Material(
        borderRadius: BorderRadius.circular(5),
        color: event.color,
        child: InkWell(
          borderRadius: BorderRadius.circular(5),
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (_) => EventDetails(model: event),
              ),
            );
          },
          child: SizedBox(
            height: height,
            width: double.infinity,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                paddedText(event.title),
                paddedText(event.location ?? ""),
              ],
            ),
          ),
        ),
      ),
    );
  }

  List<Widget> buildColumns() {
    List<Widget> children = [];
    for (var i = 0; i < 7; i++) {
      children.add(Container(
        height: 120,
        decoration: BoxDecoration(
          border: Border(
            bottom: BorderSide(width: i == 6 ? 0 : 1),
            left: BorderSide(width: 1),
          ),
        ),
        child: Row(
          children: <Widget>[
            Expanded(
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Text(""),
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
    List<Widget> children = [Column(children: buildColumns())];
    children.addAll(
        events.map((event) => buildEventWidget(event, context)).toList());

    return Stack(
      children: children,
    );
  }
}
