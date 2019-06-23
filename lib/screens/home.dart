import 'package:class_resources/components/reference-item.dart';
import 'package:class_resources/components/text-avatar.dart';
import 'package:class_resources/services/courses.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

import './course-details.dart';

class HomeScreen extends StatefulWidget {
  HomeScreen({this.userProfile});

  final dynamic userProfile;

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen>
    with AutomaticKeepAliveClientMixin<HomeScreen> {
  final numIter = 6;
  CoursesService _courses = CoursesService();

  @override
  bool get wantKeepAlive => true;

  Widget _buildCourseRow(DocumentSnapshot document) {
    return Material(
      child: InkWell(
        onTap: () {
          Navigator.push(context, MaterialPageRoute(builder: (_) {
            return CourseScreen(
              code: document['code'],
            );
          }));
        },
        child: Hero(
          tag: document['code'],
          child: Material(
            child: ListTile(
              leading: textCircularAvatar(document['title'] ?? document['code'],
                  document['color'], Colors.white),
              title: Text(document['title'] ?? ""),
              subtitle:
                  Text("${document['code']} - ${document['teacher']}" ?? ""),
            ),
          ),
        ),
      ),
      color: Colors.transparent,
    );
  }

  Widget onError(err) {
    return Text('Error: $err');
  }

  Widget onLoading() {
    return Text("loading..");
  }

  Widget onSuccess(data) {

    return ListView.builder(
      itemCount: data['subjects'].length * 2,
      itemBuilder: (BuildContext ctx, int i){
        if(i.isOdd) return Divider();
        return RefItem(ref: data['subjects'][i ~/ 2]);
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);

    return StreamBuilder<DocumentSnapshot>(
      stream: _courses.getUserCourses(widget.userProfile['id']),
      builder: (BuildContext ctx, AsyncSnapshot<DocumentSnapshot> snapshot) {

        if (snapshot.hasError)
          return onError(snapshot.error);

        if (snapshot.connectionState == ConnectionState.waiting)
          return onLoading();

        return onSuccess(snapshot.data);
      },
    );
  }
}
