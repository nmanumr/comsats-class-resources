import 'package:class_resources/components/centered-appbar.dart';
import 'package:class_resources/components/illustrated-page.dart';
import 'package:class_resources/components/list-header.dart';
import 'package:class_resources/models/event.dart';
import 'package:class_resources/models/notification.dart';
import 'package:class_resources/models/timetable.dart';
import 'package:date_utils/date_utils.dart';
import 'package:class_resources/utils/colors.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:scoped_model/scoped_model.dart';

class NotificationPage extends StatefulWidget {
  NotificationPage({@required this.timetableModel});
  final TimeTableModel timetableModel;

  @override
  _NotificationPageState createState() => _NotificationPageState();
}

class _NotificationPageState extends State<NotificationPage> {
  Widget _buildRow(AppNotification notification, num index) {
    return Dismissible(
      key: Key(notification.hashCode.toString()),
      onDismissed: (_) {
        NotificationModel.instance.removeNotification(index);
      },
      child: ListTile(
        leading: CircleAvatar(
            child: Icon(Icons.notifications),
            backgroundColor: HexColor(generateColor(notification.title ?? "")),
            foregroundColor: Colors.white),
        title: Text(notification.title ?? ""),
        subtitle: Text(notification.body ?? ""),
      ),
      background: Container(
        color: Theme.of(context).accentColor,
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[Icon(Icons.delete), Icon(Icons.delete)],
          ),
        ),
      ),
    );
  }

  List<Widget> _buildNotifications(NotificationModel model) {
    List<Widget> children = [];
    if (model.notifications.length > 0) {
      children.add(ListHeader(text: "Notifications"));
    }
    for (num i = model.notifications.length - 1; i >= 0; i--) {
      children.add(_buildRow(model.notifications[i], i));
    }
    return children;
  }

  Widget _buildEvent(EventModel event) {
    var startTime = DateFormat.jm().format(event.startTime.toDate());
    var endTime = event.endTime != null
        ? DateFormat.jm().format(event.endTime.toDate())
        : '';
    return ListTile(
      leading: CircleAvatar(
          child: Icon(Icons.event_note),
          backgroundColor:
              HexColor(generateColor(event.title + startTime)).withAlpha(130),
          foregroundColor: Colors.white),
      title: Text(event.title ?? ""),
      subtitle: Text(event.endTime != null
          ? "${event.location ?? ''} ($startTime - $endTime)"
          : "$startTime"),
      onTap: () {},
    );
  }

  List<Widget> _buildEvents(TimeTableModel model) {
    List<Widget> events = [];
    var todayEvents = model.getEventForDay(DateTime.now());
    var tomorrowEvents =
        model.getEventForDay(DateTime.now().add(Duration(days: 1)));

    if (todayEvents.length != 0) {
      // Remove all the passed events;
      todayEvents.removeWhere(
          (event) => event.startTime.toDate().isAfter(DateTime.now()));
          
      events.add(ListHeader(text: "Today"));
      events.addAll(
          todayEvents.map((EventModel event) => _buildEvent(event)).toList());
    }

    if (tomorrowEvents.length != 0) {
      events.add(ListHeader(text: "Tomorrow"));
      events.addAll(tomorrowEvents
          .map((EventModel event) => _buildEvent(event))
          .toList());
    }

    return events;
  }

  @override
  Widget build(BuildContext context) {
    return ScopedModel(
      model: NotificationModel.instance,
      child: Scaffold(
        appBar: centeredAppBar(
          context,
          "Notifications",
          actions: [
            IconButton(
              icon: Icon(Icons.sync),
              onPressed: widget.timetableModel.isLoading
                  ? null
                  : () {
                      widget.timetableModel.loadEvents();
                    },
            )
          ],
        ),
        body: ScopedModelDescendant<NotificationModel>(
          builder: (context, child, notificationModel) {
            return ScopedModel(
              model: widget.timetableModel,
              child: ScopedModelDescendant<TimeTableModel>(
                builder: (context, child, timetableModel) {
                  var children = [
                    timetableModel.isLoading
                        ? LinearProgressIndicator()
                        : SizedBox(height: 6),
                    ..._buildNotifications(notificationModel),
                    ..._buildEvents(timetableModel)
                  ];

                  if (children.length == 0)
                    return Padding(
                      padding: EdgeInsets.only(top: 60),
                      child: IllustartedPage(
                        imagePath: "assets/images/chore_list.png",
                        headingText: "No Notification",
                      ),
                    );
                  return ListView(children: children);
                },
              ),
            );
          },
        ),
      ),
    );
  }
}
