import 'package:flutter/material.dart';
import 'package:class_resources/models/event.model.dart';
import 'package:class_resources/pages/timetable/event-detail.dart';

class CalendarDay extends StatelessWidget {
  final List<EventModel> events;
  final DateTime day;

  CalendarDay({@required this.events, @required this.day});

  Widget paddedText(text, {light = false}) {
    return Padding(
      padding: EdgeInsets.fromLTRB(10, 3, 0, 0),
      child: Opacity(
        opacity: light ? 0.8 : 1.0,
        child: Text(
          text,
          style: TextStyle(
            fontWeight: FontWeight.w500,
            fontSize: light ? 13 : 14.0,
          ),
        ),
      ),
    );
  }

  DateTime dateTimeFromTime(TimeOfDay t) {
    var now = DateTime.now();
    return DateTime(now.year, now.month, now.day, t.hour, t.minute);
  }

  Widget buildEventWidget(EventModel event, context) {
    var startTime = dateTimeFromTime(event.startTime)
        .difference(dateTimeFromTime(TimeOfDay(hour: 8, minute: 30)));

    var duration = dateTimeFromTime(event.endTime)
        .difference(dateTimeFromTime(event.startTime));

    var startPos = startTime.inMinutes / 60 * 80.0 + 4;
    var height = duration.inMinutes / 60 * 80.0 - 8;

    return Container(
      margin: EdgeInsets.fromLTRB(4, startPos, 3, 0),
      child: Material(
        borderRadius: BorderRadius.circular(5),
        color: event.color.withAlpha(200),
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
                SizedBox(height: 5),
                paddedText(event.location ?? "", light: true),
              ],
            ),
          ),
        ),
      ),
    );
  }

  List<Widget> buildColumns(context) {
    List<Widget> children = [];
    for (var i = 0; i < 7; i++) {
      children.add(Container(
        height: 120,
        decoration: BoxDecoration(
          border: Border(
            bottom: BorderSide(width: 1, color: Theme.of(context).dividerColor),
            left: BorderSide(width: 1, color: Theme.of(context).dividerColor),
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
    List<Widget> children = [Column(children: buildColumns(context))];
    children.addAll(
        events.map((event) => buildEventWidget(event, context)).toList());

    return Stack(
      children: children,
    );
  }
}
