import 'package:class_resources/components/list-header.dart';
import 'package:class_resources/models/course.dart';
import 'package:clipboard_manager/clipboard_manager.dart';
import 'package:flutter/material.dart';

import 'add-resource.dart';

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
      title: Padding(
        padding: EdgeInsets.only(left: 10),
        child: Text(title),
      ),
      subtitle: Padding(
        padding: EdgeInsets.only(left: 10),
        child: Text(subtitle),
      ),
      onLongPress: () {
        copyToClipboard(context, model.title);
      },
    );
  }

  routedListTile(context, title, {page}) {
    return ListTile(
      title: Padding(
        padding: EdgeInsets.only(left: 10),
        child: Text(title),
      ),
      onTap: () {
        if (page != null)
          Navigator.of(context).push(MaterialPageRoute(builder: (ctx) => page));
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    List<Widget> children = [
      ListHeader(text: "Course Info"),
      copyableListItem(context, "Course title", model.title),
      copyableListItem(context, "Course code", model.code),
      copyableListItem(context, "Credit Hours", model.creditHours),
      copyableListItem(context, "Teacher", model.teacher),
      copyableListItem(context, "Class", model.klassName),
    ];

    if (model.maintainers.contains(model.user.id)) {
      children.addAll([
        ListHeader(text: "Course Admin"),
        routedListTile(
          context,
          "Add Resource",
          page: AddResource(
            userName: model.user.name,
            courseId: model.ref.documentID,
          ),
        ),
        routedListTile(context, "Add Assignment"),
        routedListTile(context, "Manage Students"),
        routedListTile(context, "Manage Maintainers"),
      ]);
    }

    return ListView(
      children: children,
    );
  }
}
