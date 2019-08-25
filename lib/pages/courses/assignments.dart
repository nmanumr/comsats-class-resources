import 'package:class_resources/components/empty-state.dart';
import 'package:class_resources/components/loader.dart';
import 'package:class_resources/models/assignment.model.dart';
import 'package:class_resources/models/course.model.dart';
import 'package:class_resources/pages/courses/resources.dart';
import 'package:class_resources/services/download-manager.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class CourseAssignments extends StatelessWidget {
  CourseAssignments({this.model});

  final CourseModel model;

  final DownloadManager _downloadManager = DownloadManager();

  Widget onError(err) {
    return Text('Error: $err');
  }

  Widget onSuccess(QuerySnapshot query) {
    List<Widget> children = query.documents
        .map((doc) => CourseResource(
              model: AssignmentModel(
                data: doc.data,
                downloadManager: _downloadManager,
                ref: doc.reference,
              ),
            ))
        .toList();

    if (children.isNotEmpty)
      return ListView(
        children: children,
      );

    return EmptyState(
      text: "No assignment found",
      icon: Icons.assignment,
    );
  }

  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
      stream: model.getCourseAssignments(),
      builder: (context, snapshot) {
        if (snapshot.hasError) return onError(snapshot.error);

        if (snapshot.connectionState == ConnectionState.waiting)
          return Loader();

        return onSuccess(snapshot.data);
      },
    );
  }
}
