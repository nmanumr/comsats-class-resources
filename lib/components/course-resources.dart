import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class CourseResources extends StatefulWidget {
  CourseResources({@required this.resources});

  final List<dynamic> resources;

  @override
  _CourseResourcesState createState() => _CourseResourcesState();
}

class _CourseResourcesState extends State<CourseResources> {
  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      itemCount: widget.resources.length,
      itemBuilder: (BuildContext ctx, int i) {
        return RefItem(
          ref: widget.resources[i],
        );
      },
    );
  }
}

class RefItem extends StatefulWidget {
  RefItem({this.ref});

  final DocumentReference ref;

  @override
  _RefItemState createState() => _RefItemState();
}

class _RefItemState extends State<RefItem> {
  Widget onError(err) {
    return Text('Error: $err');
  }

  Widget onLoading() {
    return ListTile(
      title: Text(widget.ref.documentID),
      subtitle: Text("loading.."),
    );
  }

  Widget onSuccess(DocumentSnapshot doc) {
    DateTime date = (doc.data['date'] ?? Timestamp.now()).toDate();
    var formatter = new DateFormat('MMM dd, yyyy');
    String formatted = formatter.format(date);
    return Builder(
      builder: (BuildContext ctx) {
        switch (doc.data['type'].toLowerCase()) {
          case 'h':
            return ListTile(
              dense: true,
              title: Text(
                doc.data['title'],
                style: Theme.of(ctx).textTheme.subtitle,
              ),
            );
          default:
            return ListTile(
              leading: CircleAvatar(
                child: Icon(Icons.book),
              ),
              title: Text(
                doc.data['title'],
                style: Theme.of(ctx).textTheme.subhead,
              ),
              subtitle: Text("$formatted"),
              onTap: () {},
            );
        }
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<DocumentSnapshot>(
      stream: widget.ref.snapshots(),
      builder: (BuildContext ctx, AsyncSnapshot<DocumentSnapshot> snapshot) {
        if (snapshot.hasError) return onError(snapshot.error);

        if (snapshot.connectionState == ConnectionState.waiting)
          return onLoading();

        return onSuccess(snapshot.data);
      },
    );
  }
}
