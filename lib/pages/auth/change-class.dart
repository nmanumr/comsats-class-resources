import 'package:class_resources/components/centered-appbar.dart';
import 'package:class_resources/services/class.dart';
import 'package:class_resources/utils/colors.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

import 'package:class_resources/models/class.model.dart';

class ChangeClass extends StatefulWidget {
  ChangeClass({this.klass, this.navigateToDashboard = true});

  final bool navigateToDashboard;
  final KlassModel klass;

  @override
  _ChangeClassState createState() => _ChangeClassState();
}

class _ChangeClassState extends State<ChangeClass> {
  KlassService _klassService = KlassService();
  final _scaffoldKey = GlobalKey<ScaffoldState>();
  Stream<QuerySnapshot> _stream;
  String selectedKlass;
  bool isLoading = false;

  @override
  initState() {
    _stream = _klassService.getAllClasses();
    super.initState();
  }

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
    // Just close the dialog if klass is not changed
    if (widget.klass != null && selectedKlass == widget.klass.name)
      Navigator.of(context).pop();

    setState(() => isLoading = true);
    try {
      await _klassService.changeClass(selectedKlass);
      setState(() => isLoading = false);

      if (widget.navigateToDashboard) {
        Navigator.pushNamedAndRemoveUntil(context, "/dashboard", (_) => false);
      } else
        Navigator.of(context).pop();
    } catch (e) {
      if (_scaffoldKey.currentState != null) showError(e);
      setState(() => isLoading = false);
    }
  }

  Widget onSuccess(List<DocumentSnapshot> klasses) {
    return ListView.builder(
      itemCount: klasses.length + 1,
      itemBuilder: (context, i) {
        if (i == 0)
          return isLoading ? LinearProgressIndicator() : SizedBox(height: 6);
        var klassName = klasses[i - 1].data["name"];

        if (widget.klass != null &&
            widget.klass.name == klassName &&
            selectedKlass == null) {
          selectedKlass = widget.klass.name;
        }
        var isSelected = selectedKlass == klassName;

        return ListTile(
          leading: CircleAvatar(
            child: Icon(isSelected ? Icons.done : Icons.class_),
            backgroundColor: isSelected
                ? Theme.of(context).accentColor
                : HexColor(generateColor(klasses[i-1].data["CR"])),
            foregroundColor: Colors.white,
          ),
          title: Text(klassName),
          subtitle: Text(klasses[i-1].data["CR"]),
          onTap: () {
            setState(() => selectedKlass = klassName);
          },
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      appBar: centeredAppBar(context, "Select Class"),
      body: StreamBuilder(
        stream: _stream,
        builder: (context, AsyncSnapshot snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting)
            return ListView(
              children: <Widget>[LinearProgressIndicator()],
            );

          return onSuccess(snapshot.data.documents);
        },
      ),
      floatingActionButton: FloatingActionButton.extended(
        label: Text("Done"),
        icon: Icon(Icons.done),
        onPressed: () => submit(context),
      ),
    );
  }
}
