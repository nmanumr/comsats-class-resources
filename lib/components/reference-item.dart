import 'package:class_resources/components/text-avatar.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class RefItem extends StatefulWidget {
  RefItem({
    @required this.ref,
    this.popupItems,
    this.handlePopUpChanged,
  });

  final DocumentReference ref;
  final List<PopupMenuItem> popupItems;
  final Function(dynamic val, DocumentReference docRef) handlePopUpChanged;

  @override
  _RefItemState createState() => _RefItemState();
}

class _RefItemState extends State<RefItem> {
  final GlobalKey _menuKey = new GlobalKey();

  Widget _getPopup(DocumentReference docRef) {
    return PopupMenuButton(
      icon: Icon(Icons.more_vert, color: Colors.transparent),
      key: _menuKey,
      onSelected: (val) => widget.handlePopUpChanged(val, docRef),
      itemBuilder: (BuildContext context) => widget.popupItems,
      enabled: false,
    );
  }

  String className(DocumentReference classPath){
    return classPath.path.substring(8);
  }

  Widget onError(err) {
    return Text('Error: $err');
  }

  Widget onLoading() {
    return ListTile(
      leading: TextAvatar(text: "..."),
      title: Text(widget.ref.documentID),
      subtitle: Text("loading.."),
    );
  }

  Widget onSuccess(DocumentSnapshot doc) {
    return Builder(
      builder: (BuildContext ctx) {
        return ListTile(
          leading: TextAvatar(
            text: doc.data['title'] ?? doc.data['code'],
            colorCode: doc.data['color'],
            foreground: Colors.white,
          ),
          title: Text(doc.data['title'] ?? ""),
          subtitle: Text("${className(doc.data['class'])} - ${doc.data['teacher']}" ?? ""),
          trailing: _getPopup(doc.reference),
          onTap: () {},
          onLongPress: () {
            if ((widget.popupItems ?? []).isNotEmpty) {
              dynamic popUpMenustate = _menuKey.currentState;
              popUpMenustate.showButtonMenu();
            }
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
