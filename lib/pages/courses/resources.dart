import 'package:class_resources/components/loader.dart';
import 'package:class_resources/components/text-avatar.dart';
import 'package:class_resources/models/course.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class CourseResources extends StatelessWidget {

  CourseResources({this.model});

  final CourseModel model;

  Widget onError(err) {
    return Text('Error: $err');
  }

  Widget onSuccess(DocumentSnapshot doc) {
    return Builder(
      builder: (BuildContext ctx) {
        return ListTile(
          leading: TextAvatar(
            text: doc.data['title'] + doc.data['class'].documentID,
          ),
          title: Text(doc.data['title'] ?? ""),
          subtitle: Text("${doc.data['class'].documentID} - ${doc.data['teacher']}" ?? ""),
          // trailing: _getPopup(doc.reference),
          onTap: () {},
          // onLongPress: () {
          //   if ((widget.popupItems ?? []).isNotEmpty) {
          //     dynamic popUpMenustate = _menuKey.currentState;
          //     popUpMenustate.showButtonMenu();
          //   }
          // },
        );
      },
    );
  }
  
  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
      stream: model.getCourseResources(),
      builder: (context, snapshot){
        if (snapshot.hasError) return onError(snapshot.error);

        if (snapshot.connectionState == ConnectionState.waiting)
          return Loader();

        return onSuccess(snapshot.data);
      },
    );
  }
}
