import 'package:class_resources/components/centered-appbar.dart';
import 'package:class_resources/components/illustrated-form.dart';
import 'package:class_resources/services/authentication.dart';
import 'package:class_resources/utils/validator.dart';
import 'package:flutter/material.dart';
import 'package:flutter_masked_text/flutter_masked_text.dart';
import 'package:class_resources/components/input.dart';

class UpdateProfile extends StatefulWidget {
  UpdateProfile({
    this.name,
    this.rollNum,
    this.klass,
    this.navigateToDashboard = true,
  });

  final String name;
  final String rollNum;
  final String klass;

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

  MaskedTextController _rollumController = MaskedTextController(mask: 'AA00-AAA-000');
  TextEditingController _nameController = TextEditingController();

  @override
  void initState() {
    super.initState();
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
    _formKey.currentState.save();
    if (_formKey.currentState.validate()) {
      try {
        await _authService.updateProfile(
          _nameController.text,
          _rollumController.text,
        );
        if (widget.navigateToDashboard)
          Navigator.pushNamedAndRemoveUntil(
              context, "/dashboard", (_) => false);
        else
          Navigator.pop(context);
      } catch (e) {
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
          )
        ],
        primaryButton: RaisedButton(child: Text("Save"), onPressed: submit),
      ),
    );
  }
}
