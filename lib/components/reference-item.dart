import 'package:class_resources/components/text-avatar.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

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
      leading: textCircularAvatar("..."),
      title: Text(widget.ref.documentID),
      subtitle: Text("loading.."),
    );
  }

  Widget onSuccess(data) {
    return ListTile(
      leading: textCircularAvatar(
        data['title'] ?? data['code'],
        data['color'],
        Colors.white,
      ),
      title: Text(data['title'] ?? ""),
      subtitle: Text("${data['code']} - ${data['teacher']}" ?? ""),
    );
  }

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<DocumentSnapshot>(
      stream: widget.ref.snapshots(),
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
