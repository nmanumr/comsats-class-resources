import 'package:class_resources/components/text-avatar.dart';
import 'package:class_resources/services/courses.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class RefItem extends StatefulWidget {
  RefItem({this.ref, this.userId});

  final DocumentReference ref;
  final String userId;
  final CoursesService coursesService = CoursesService();

  @override
  _RefItemState createState() => _RefItemState();
}

class _RefItemState extends State<RefItem> {
  final GlobalKey _menuKey = new GlobalKey();

  handlePopUpChanged(val, docRef) {
    widget.coursesService.removeCourse(widget.userId, docRef);
  }

  Widget _getPopup(DocumentReference docRef) {
    List<PopupMenuItem> popupItems = [
      PopupMenuItem(
        child: Text("Remove Course"),
        value: "",
      )
    ];

    return PopupMenuButton(
      icon: Icon(
        Icons.error,
        color: Colors.transparent,
      ),
      key: _menuKey,
      onSelected: (val) => handlePopUpChanged(val, docRef),
      itemBuilder: (BuildContext context) => popupItems,
      enabled: false,
    );
  }

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

  Widget onSuccess(DocumentSnapshot doc) {
    return Builder(
      builder: (BuildContext ctx) {
        return ListTile(
          leading: textCircularAvatar(
            doc.data['title'] ?? doc.data['code'],
            doc.data['color'],
            Colors.white,
          ),
          title: Text(doc.data['title'] ?? ""),
          subtitle: Text("${doc.data['code']} - ${doc.data['teacher']}" ?? ""),
          trailing: _getPopup(doc.reference),
          onTap: () {},
          onLongPress: () {
            dynamic popUpMenustate = _menuKey.currentState;
            popUpMenustate.showButtonMenu();
          },
        );
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
