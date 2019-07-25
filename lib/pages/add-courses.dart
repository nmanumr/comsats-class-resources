import 'package:class_resources/components/centered-appbar.dart';
import 'package:class_resources/components/loader.dart';
import 'package:class_resources/components/text-avatar.dart';
import 'package:class_resources/services/courses.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class AddCourses extends StatelessWidget {
  final CoursesService coursesService = CoursesService();

  String className(DocumentReference classPath) {
    if (classPath != null) return classPath.path.substring(8);
    return "";
  }

  Widget onLoaded(List<DocumentSnapshot> courses, context) {
    List<Widget> children = courses
        .map((course) => ListTile(
              leading: TextAvatar(
                text: course['title'],
              ),
              title: Text(course["title"]),
              subtitle:
                  Text("${className(course['class'])} - ${course['teacher']}"),
              onTap: () {},
            ))
        .toList();

    children = [
          ListTile(
            leading: CircleAvatar(
              child: Icon(Icons.add),
              backgroundColor: Theme.of(context).accentColor.withAlpha(85),
              foregroundColor: Theme.of(context).accentColor,
            ),
            title: Text("Create new course"),
            onTap: () {
              Navigator.popAndPushNamed(context, '/create-course');
            },
          ),
          ListTile(
            leading: CircleAvatar(
              child: Icon(Icons.sync),
              backgroundColor: Theme.of(context).accentColor.withAlpha(85),
              foregroundColor: Theme.of(context).accentColor,
            ),
            title: Text("Sync with class"),
            onTap: () {
              coursesService.syncWithClass();
            },
          ),
          Divider()
        ] +
        children;
    return ListView(children: children);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: centeredAppBar(context, "Courses"),
      body: StreamBuilder(
        stream: coursesService.getAllCourses(),
        builder: (builder, snapshot) {
          if (snapshot.hasError) {
            return Text('Error: ${snapshot.error}');
          } else if (snapshot.connectionState == ConnectionState.waiting) {
            return Loader();
          } else {
            return onLoaded(snapshot.data.documents, context);
          }
        },
      ),
    );
  }
}
