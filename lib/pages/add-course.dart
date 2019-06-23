import 'package:class_resources/components/text-avatar.dart';
import 'package:class_resources/services/courses.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class AddCourse extends StatefulWidget {
  AddCourse({this.userId});

  final String userId;
  final CoursesService coursesService = CoursesService();

  @override
  _AddCourseState createState() => _AddCourseState();
}

class _AddCourseState extends State<AddCourse> {
  getClassNameFromPath(DocumentReference docRef){
    var splitted = docRef.path.split("/");
    return splitted[splitted.length - 1];
  }

  getCourseItems(AsyncSnapshot<QuerySnapshot> snapshot, BuildContext context) {
    return snapshot.data.documents
        .map((doc) => ListTile(
              leading: textCircularAvatar(
                doc.data['title'] ?? doc.data['code'],
                doc.data['color'],
                Colors.white,
              ),
              title: Text(doc.data['title'] ?? ""),
              subtitle: Text("${getClassNameFromPath(doc.data['class'])} - ${doc.data['teacher']}" ?? ""),
              onTap: () {
                widget.coursesService.addCourse(widget.userId, doc.reference);
                Navigator.pop(context);
              },
            ))
        .toList();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Add Course"),
      ),
      body: StreamBuilder<QuerySnapshot>(
        stream: widget.coursesService.getAllCourses(),
        builder: (BuildContext ctx, AsyncSnapshot<QuerySnapshot> snapshot) {
          if (!snapshot.hasData) return new Text("There is no expense");
          return new ListView(children: getCourseItems(snapshot, ctx));
        },
      ),
    );
  }
}
