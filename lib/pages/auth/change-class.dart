import 'package:class_resources/components/centered-appbar.dart';
import 'package:class_resources/models/profile.model.dart';
import 'package:class_resources/utils/colors.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class ChangeClass extends StatefulWidget {
  ChangeClass(this.profile, {this.navigateToDashboard = true});

  final bool navigateToDashboard;
  final ProfileModel profile;

  @override
  _ChangeClassState createState() => _ChangeClassState();
}

class _ChangeClassState extends State<ChangeClass> {
  final _scaffoldKey = GlobalKey<ScaffoldState>();
  // Stream<QuerySnapshot> _stream;
  String selectedKlass;
  bool isLoading = false;

  showError(err) {
    var msg;
    try {
      msg = err.message;
    } catch (e) {
      msg = err;
    }
    _scaffoldKey.currentState.showSnackBar(
      SnackBar(
        content: Text('$msg'),
        action: SnackBarAction(
          label: 'Close',
          onPressed: () {},
        ),
      ),
    );
  }

  submit(context) async {
    setState(() => isLoading = true);
    // Just close the dialog if klass is not changed
    if (widget.profile.klass != null &&
        selectedKlass == widget.profile.klass.name) Navigator.of(context).pop();

    try {
      await widget.profile.service.changeClass(selectedKlass);
      await widget.profile.service.refresh();

      setState(() => isLoading = false);

      if (widget.navigateToDashboard) {
        Navigator.pushNamedAndRemoveUntil(context, "/dashboard", (_) => false);
      } else
        Navigator.of(context).pop();
    } catch (e) {
      if (_scaffoldKey.currentState != null) showError(e);
    }

    setState(() => isLoading = false);
  }

  Widget onSuccess(List<DocumentSnapshot> klasses) {
    return ListView.builder(
      itemCount: klasses.length + 1,
      itemBuilder: (context, i) {
        if (i == 0)
          return isLoading ? LinearProgressIndicator() : SizedBox(height: 6);
        var klassName = klasses[i - 1].data["name"];
        var id = klasses[i - 1].documentID;

        if (widget.profile.klass != null &&
            widget.profile.klass.name == klassName &&
            selectedKlass == null) {
          selectedKlass = widget.profile.klass.ref.documentID;
        }
        var isSelected = selectedKlass == id;

        return ListTile(
          leading: CircleAvatar(
            child: Icon(isSelected ? Icons.done : Icons.class_),
            backgroundColor: isSelected
                ? Theme.of(context).accentColor
                : HexColor(generateColor(klasses[i - 1].data["CR"])),
            foregroundColor: Colors.white,
          ),
          title: Text(klassName),
          subtitle: Text(klasses[i - 1].data["CR"]),
          onTap: () {
            setState(() => selectedKlass = id);
          },
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      appBar: centeredAppBar(context, "Select Your Class", actions: [
        FlatButton(
          child: Text(widget.navigateToDashboard ? "Skip" : "Cancel"),
          onPressed: () {
            if (widget.navigateToDashboard)
              Navigator.pushNamedAndRemoveUntil(
                  context, "/dashboard", (_) => false);
            else
              Navigator.of(context).pop();
          },
        )
      ]),
      body: StreamBuilder(
        stream: Firestore.instance.collection("classes").snapshots(),
        builder: (context, AsyncSnapshot snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting)
            return ListView(
              children: <Widget>[LinearProgressIndicator()],
            );

          return onSuccess(snapshot.data.documents);
        },
      ),
      floatingActionButton: FloatingActionButton.extended(
        label: Text("Select"),
        icon: Icon(Icons.done),
        onPressed: () => submit(context),
      ),
    );
  }
}
