import 'package:class_resources/components/centered-appbar.dart';
import 'package:class_resources/components/empty-state.dart';
import 'package:flutter/material.dart';

class NotificationPage extends StatefulWidget {
  @override
  _NotificationPageState createState() => _NotificationPageState();
}

class _NotificationPageState extends State<NotificationPage> {
  Widget _buildRow(int i) {
    return Material(
      child: InkWell(
        onTap: () {},
        child: ListTile(
          isThreeLine: true,
          leading: Icon(Icons.add_alert),
          title: Text('PPIT Assignment'),
          subtitle:
              Text("New PPIT Assignment has been added\nAdded by: Nauman Umer"),
        ),
      ),
      color: Colors.transparent,
    );
  }

  Widget emptyState(context) {
    return EmptyState(
      icon: Icons.playlist_add_check,
      text: "No pending tasks",
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: centeredAppBar(context, "Tasks"),
      body: emptyState(context),
    );
  }
}
