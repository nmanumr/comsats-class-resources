import 'package:class_resources/models/course.dart';
import 'package:clipboard_manager/clipboard_manager.dart';
import 'package:flutter/material.dart';

class CourseAbout extends StatelessWidget {
  CourseAbout({@required this.model});

  final CourseModel model;

  copyToClipboard(BuildContext context, String text) {
    ClipboardManager.copyToClipBoard(text).then((result) {
      final snackBar = SnackBar(
        content: Text('Copied to Clipboard'),
      );
      Scaffold.of(context).showSnackBar(snackBar);
    });
  }

  copyableListItem(BuildContext context, String title, String subtitle) {
    return ListTile(
      leading: Text(""),
      title: Text(title),
      subtitle: Text(subtitle),
      onLongPress: () {
        copyToClipboard(context, model.title);
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return ListView(
      children: <Widget>[
        copyableListItem(context, "Course title", model.title),
        copyableListItem(context, "Course code", model.code),
        copyableListItem(context, "Credit Hours", model.creditHours),
        copyableListItem(context, "Teacher", model.teacher),
        copyableListItem(context, "Class", model.klassName),
      ],
    );
  }
}
