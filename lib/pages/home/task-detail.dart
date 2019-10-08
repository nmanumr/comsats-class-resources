import 'package:class_resources/components/centered-appbar.dart';
import 'package:class_resources/components/list-header.dart';
import 'package:class_resources/models/task.model.dart';
import 'package:class_resources/utils/colors.dart';
import 'package:clipboard_manager/clipboard_manager.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class TaskDetail extends StatelessWidget {
  final TaskModel task;

  TaskDetail(this.task);

  copyToClipboard(BuildContext context, String text) {
    ClipboardManager.copyToClipBoard(text).then((result) {
      final snackBar = SnackBar(
        content: Text('Copied to Clipboard'),
      );
      Scaffold.of(context).showSnackBar(snackBar);
    });
  }

  copyableListItem(BuildContext context,
      {String title, String subtitle, IconData icon, String copyText}) {
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
        copyToClipboard(context, copyText ?? title);
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: centeredAppBar(context, "", isCloseable: true, actions: [
        Builder(
          builder: (context) => PopupMenuButton(
            onSelected: (val) =>
                copyToClipboard(context, task.getAnnoucmentTemplate()),
            itemBuilder: (BuildContext context) {
              return [
                PopupMenuItem(
                  value: "",
                  child: Text("Copy Annoucment Text"),
                )
              ];
            },
          ),
        ),
      ]),
      body: ListView(
        children: <Widget>[
          ListTile(
            leading: Hero(
              tag: "${task.hashCode}-c",
              child: Container(
                width: 30,
                height: 30,
                decoration: new BoxDecoration(
                  color: HexColor(generateColor(task.title)).withAlpha(130),
                  shape: BoxShape.circle,
                ),
              ),
            ),
            title: Hero(
              tag: task.hashCode,
              child: Material(
                child: Text(
                  task.title,
                  style: Theme.of(context)
                      .textTheme
                      .title
                      .copyWith(fontWeight: FontWeight.normal),
                ),
              ),
            ),
          ),
          Divider(),
          SizedBox(height: 20),
          copyableListItem(
            context,
            icon: Icons.book,
            title: ((task.isLab) ? "(Lab) " : "") + task.course.title,
          ),
          copyableListItem(
            context,
            icon: Icons.date_range,
            title: DateFormat("EEEE, MMM d").format(task.dueDate),
          ),
          ...((task.room != null)
              ? [
                  copyableListItem(
                    context,
                    icon: Icons.location_on,
                    title: task.room,
                  )
                ]
              : []),
          ...((task.desc != null)
              ? [
                  ListHeader(text: "Description"),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 24),
                    child: SelectableText(
                      task.desc,
                      style: TextStyle(fontFamily: "monospace"),
                    ),
                  ),
                ]
              : []),
        ],
      ),
    );
  }
}
