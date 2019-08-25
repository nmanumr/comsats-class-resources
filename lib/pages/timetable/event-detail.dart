import 'package:class_resources/components/centered-appbar.dart';
import 'package:class_resources/models/event.model.dart';
import 'package:clipboard_manager/clipboard_manager.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class EventDetails extends StatelessWidget {
  EventDetails({this.model});

  final EventModel model;

  copyToClipboard(BuildContext context, String text) {
    ClipboardManager.copyToClipBoard(text).then((result) {
      final snackBar = SnackBar(
        content: Text('Copied to Clipboard'),
      );
      Scaffold.of(context).showSnackBar(snackBar);
    });
  }

  copyableListItem(BuildContext context,
      {String title, String subtitle, IconData icon}) {
    return ListTile(
      leading: Icon(icon),
      title: Padding(
        padding: EdgeInsets.only(left: 10),
        child: Text(title ?? "null"),
      ),
      subtitle: subtitle != null
          ? Padding(
              padding: EdgeInsets.only(left: 10),
              child: Text(subtitle),
            )
          : null,
      onLongPress: () {
        copyToClipboard(context, model.title);
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: centeredAppBar(context, "", isCloseable: true),
      body: ListView(
        children: <Widget>[
          ListTile(
            leading: Container(
              width: 30,
              height: 30,
              decoration: new BoxDecoration(
                color: model.color,
                shape: BoxShape.circle,
              ),
            ),
            title: Text(
              model.title,
              style: Theme.of(context)
                  .textTheme
                  .title
                  .copyWith(fontWeight: FontWeight.normal),
            ),
          ),
          Divider(),
          SizedBox(height: 20),
          copyableListItem(
            context,
            title: model.location,
            icon: Icons.location_on,
          ),
          copyableListItem(
            context,
            title: model.course.teacher,
            icon: Icons.person,
          ),
          copyableListItem(
            context,
            title: "Start Time",
            subtitle: DateFormat.jm().format(model.startTime),
            icon: Icons.alarm,
          ),
          copyableListItem(
            context,
            title: "EndTime",
            subtitle: DateFormat.jm().format(model.endTime),
            icon: Icons.alarm_on,
          ),
          ...(model.eventSlot != null
              ? [
                  copyableListItem(
                    context,
                    title: "Slot",
                    subtitle: model.eventSlot,
                    icon: Icons.view_agenda,
                  )
                ]
              : []),
        ],
      ),
    );
  }
}
