import 'package:class_resources/components/text-avatar.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

import './course-details.dart';

class HomeScreen extends StatefulWidget {
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen>
    with AutomaticKeepAliveClientMixin<HomeScreen> {
  final numIter = 6;

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
              leading: textCircularAvatar(
                document['title'] ?? document['code'],
                document['color'],
                Colors.white
              ),
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

  List<Widget> _buildCourseList(List<DocumentSnapshot> documents) {
    List<Widget> rows = [];
    documents.forEach((DocumentSnapshot document) {
      rows.add(_buildCourseRow(document));
      rows.add(Divider(
        indent: 70.0,
      ));
    });
    return rows;
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);

    return StreamBuilder<QuerySnapshot>(
      stream: Firestore.instance.collection('subjects').snapshots(),
      builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
        if (snapshot.hasError) return new Text('Error: ${snapshot.error}');
        switch (snapshot.connectionState) {
          case ConnectionState.waiting:
            return Text('Loading...');
          default:
            return ListView(
                children: _buildCourseList(snapshot.data.documents));
        }
      },
    );
  }
}
