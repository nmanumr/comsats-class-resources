import 'dart:async';

import 'package:class_resources/components/centered-appbar.dart';
import 'package:class_resources/components/input.dart';
import 'package:class_resources/services/authentication.dart';
import 'package:class_resources/utils/validator.dart';
import 'package:flutter/material.dart';

class SignupPage extends StatefulWidget {
  final AuthService auth = AuthService();

  @override
  _SignupPageState createState() => _SignupPageState();
}

class _SignupPageState extends State<SignupPage> {
  final _formKey = GlobalKey<FormState>();
  TextEditingController _controller = TextEditingController();
  final _scaffoldKey = GlobalKey<ScaffoldState>();

  Profile profile = Profile();
  String password2;

  void onError(ctx, err) {
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

  FutureOr<dynamic> onSignedUp(ctx) {
    Navigator.pushNamedAndRemoveUntil(ctx, '/dashboard', (r) => false);
  }

  void onSubmit(ctx) {
    _formKey.currentState.save();
    if (_formKey.currentState.validate()) {
      widget.auth
          .signUp(profile)
          .then((val) => onSignedUp(ctx))
          .catchError((err) => onError(ctx, err));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      appBar: centeredAppBar(context, "Signup"),
      body: Form(
        key: _formKey,
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16.0),
          child: ListView(
            children: <Widget>[
              PaddedInput(
                label: "Email",
                validator: emailValidator,
                onSave: (value) => profile.email = value,
              ),
              PaddedInput(
                label: "Your Name",
                validator: notEmptyValidator,
                onSave: (value) => profile.name = value,
              ),
              PaddedInput(
                label: "Password",
                validator: passwordValidator,
                controller: _controller,
                obscureText: true,
                onSave: (value) => profile.password = value,
              ),
              PaddedInput(
                label: "Confirm Password",
                validator: repasswordValidator(_controller),
                obscureText: true,
                onSave: (value) => password2 = value,
              ),
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 15.0),
                child: Builder(builder: (ctx) {
                  return Row(
                    children: <Widget>[
                      FlatButton(
                        padding: EdgeInsets.symmetric(
                            vertical: 12.0, horizontal: 25.0),
                        onPressed: () => Navigator.pushNamed(context, '/login'),
                        child: Text('Already have account?'),
                      ),
                      Expanded(
                        child: Text(" "),
                      ),
                      RaisedButton(
                        textColor: Colors.white,
                        color: Theme.of(context).primaryColor,
                        padding: EdgeInsets.symmetric(
                            vertical: 12.0, horizontal: 25.0),
                        onPressed: () => onSubmit(ctx),
                        child: Text('Signup'),
                      ),
                    ],
                  );
                }),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
