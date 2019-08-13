import 'package:class_resources/components/centered-appbar.dart';
import 'package:class_resources/components/illustrated-form.dart';
import 'package:class_resources/components/list-header.dart';
import 'package:class_resources/components/loader.dart';
import 'package:class_resources/models/class.dart';
import 'package:class_resources/services/authentication.dart';
import 'package:class_resources/utils/colors.dart';
import 'package:class_resources/utils/route-transition.dart';
import 'package:class_resources/utils/validator.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_masked_text/flutter_masked_text.dart';
import 'package:class_resources/components/input.dart';

import 'change-class.dart';

class UpdateProfile extends StatefulWidget {
  UpdateProfile({
    this.name,
    this.rollNum,
    this.klass,
    this.navigateToDashboard = false,
  });

  final String name;
  final String rollNum;
  final DocumentReference klass;

  /// if true will navigate to dashboard Route
  /// otherwise just closes itself
  final bool navigateToDashboard;

  @override
  _UpdateProfileState createState() => _UpdateProfileState();
}

class _UpdateProfileState extends State<UpdateProfile> {
  final _formKey = GlobalKey<FormState>();
  final _scaffoldKey = GlobalKey<ScaffoldState>();
  AuthService _authService = AuthService();

  MaskedTextController _rollumController =
      MaskedTextController(mask: 'AA00-AAA-000');
  TextEditingController _nameController = TextEditingController();
  KlassModel _klass;
  bool isLoading = false;

  @override
  void initState() {
    super.initState();
    if (widget.klass != null) loadClass();
  }

  void loadClass() async {
    var klass = await KlassModel.fromRef(widget.klass);
    setState(() => _klass = klass);
  }

  void onError(err) {
    _scaffoldKey.currentState.showSnackBar(
      SnackBar(
        content: Text('${err.message}'),
        action: SnackBarAction(
          label: 'Close',
          onPressed: () {},
        ),
      ),
    );
  }

  void submit() async {
    setState(() => isLoading = true);
    _formKey.currentState.save();
    if (_formKey.currentState.validate()) {
      try {
        await _authService.updateProfile(
          _nameController.text,
          _rollumController.text,
        );
        setState(() => isLoading = false);
        if (widget.navigateToDashboard)
          Navigator.push(
            context,
            EnterExitRoute(
              exitPage: this.widget,
              enterPage: ChangeClass(navigateToDashboard: true),
            ),
          );
        else
          Navigator.pop(context);
      } catch (e) {
        setState(() => isLoading = true);
        onError(e);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      appBar: centeredAppBar(context,
          widget.navigateToDashboard ? "Create Profile" : "Update Profile"),
      body: illustratedForm(
        key: _formKey,
        imagePath: "assets/images/profile.png",
        isLoading: isLoading,
        children: [
          PaddedInput(
            label: "Your Name",
            initialValue: widget.name,
            controller: _nameController,
            validator: nameValidator,
          ),
          PaddedInput(
            label: "Your Roll Number",
            initialValue: widget.rollNum,
            controller: _rollumController,
            validator: rollNumValidator,
          ),
          widget.klass != null ? ListHeader(text: "Your Class") : Text(" "),
          Builder(
            builder: (context) {
              if (widget.klass != null) {
                if (_klass != null) {
                  return Padding(
                    padding: const EdgeInsets.fromLTRB(20, 10, 20, 15),
                    child: OutlineButton(
                      // padding: EdgeInsets.fromLTRB(20, 15, 10, 15),
                      child: SizedBox(
                        width: double.infinity,
                        child: ListTile(
                          leading: CircleAvatar(
                            child: Icon(Icons.class_),
                            backgroundColor: HexColor(generateColor(_klass.cr)),
                            foregroundColor: Colors.white,
                          ),
                          title: Text(_klass.name),
                          subtitle: Text("CR: " + _klass.cr ?? ""),
                          trailing: Icon(Icons.keyboard_arrow_right),
                        ),
                      ),
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (_) => ChangeClass(klass: _klass),
                          ),
                        );
                      },
                    ),
                  );
                }

                return Padding(
                  padding: const EdgeInsets.fromLTRB(20, 10, 20, 15),
                  child: OutlineButton(
                    padding: EdgeInsets.fromLTRB(20, 15, 10, 15),
                    child: SizedBox(
                      width: double.infinity,
                      child: Loader(),
                    ),
                    onPressed: () {},
                  ),
                );
              }

              return Text(" ");
            },
          )
        ],
        primaryButton: RaisedButton.icon(
          icon: Icon(widget.navigateToDashboard ? Icons.keyboard_arrow_right : Icons.check),
          label: Text(widget.navigateToDashboard ? "Next" : "Save"),
          onPressed: submit,
        ),
      ),
    );
  }
}
