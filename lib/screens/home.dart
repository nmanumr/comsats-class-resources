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
              leading:
                  textCircularAvatar(document['title'] ?? document['code']),
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

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<QuerySnapshot>(
      stream: Firestore.instance.collection('subjects').snapshots(),
      builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
        if (snapshot.hasError) return new Text('Error: ${snapshot.error}');
        switch (snapshot.connectionState) {
          case ConnectionState.waiting:
            return new Text('Loading...');
          default:
            return new ListView(
              children:
                  snapshot.data.documents.map((DocumentSnapshot document) {
                return _buildCourseRow(document);
                //  new ListTile(
                //   title: new Text(document['title']),
                //   subtitle: new Text(document['author']),
                // );
              }).toList(),
            );
        }
      },
    );
    return ListView.builder(
      itemCount: numIter * 2,
      padding: EdgeInsets.all(16.0),
      itemBuilder: (BuildContext ctx, int i) {
        if (i.isOdd) return Divider();

        // final index = i ~/ 2 + 1;
        // return _buildRow(index);
      },
    );
  }
}
