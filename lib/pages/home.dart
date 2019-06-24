import 'package:class_resources/components/reference-item.dart';
import 'package:class_resources/services/courses.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

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

  Widget onError(err) {
    return Text('Error: $err');
  }

  Widget onLoading() {
    return Text("loading..");
  }

  Widget onSuccess(data) {
    return ListView.separated(
      itemCount: data['subjects'].length,
      itemBuilder: (BuildContext ctx, int i) {
        return RefItem(
          ref: data['subjects'][i],
          userId: widget.userProfile['id'],
        );
      },
      separatorBuilder: (ctx, t) => Divider(),
    );
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);

    return StreamBuilder<DocumentSnapshot>(
      stream: _courses.getUserCourses(widget.userProfile['id']),
      builder: (BuildContext ctx, AsyncSnapshot<DocumentSnapshot> snapshot) {
        if (snapshot.hasError) return onError(snapshot.error);

        if (snapshot.connectionState == ConnectionState.waiting)
          return onLoading();

        return onSuccess(snapshot.data);
      },
    );
  }
}
