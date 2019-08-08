import 'package:class_resources/components/centered-appbar.dart';
import 'package:class_resources/components/input.dart';
import 'package:class_resources/services/authentication.dart';
import 'package:class_resources/utils/validator.dart';
import 'package:flutter/material.dart';

class ChangePass extends StatefulWidget {
  @override
  _ChangePassState createState() => _ChangePassState();
}

class _ChangePassState extends State<ChangePass> {
  final _formKey = GlobalKey<FormState>();
  AuthService _authService = AuthService();

  TextEditingController _passwordController = TextEditingController();
  TextEditingController _password2Controller = TextEditingController();

  String password;
  String password2;

  void onSubmit() {
    _formKey.currentState.save();
    if (_formKey.currentState.validate()) {
      // widget.auth
      //     .signUp(profile)
      //     .then((val) => onSignedUp(ctx))
      //     .catchError((err) => onError(ctx, err));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: centeredAppBar(context, "Change Password"),
      body: Form(
        key: _formKey,
        child: ListView(
          children: <Widget>[
            SizedBox(height: 30),
            Image.asset(
              "assets/images/Login.png",
              height: 230,
            ),
            SizedBox(height: 30),
            PaddedInput(
              label: "New Password",
              controller: _passwordController,
              validator: passwordValidator,
              obscureText: true,
              onSave: (value) => password = value,
            ),
            PaddedInput(
              label: "Password Again",
              controller: _password2Controller,
              obscureText: true,
              validator: repasswordValidator(_passwordController),
            ),
            SizedBox(height: 30),
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: <Widget>[
                RaisedButton(
                  child: Text("Change Password"),
                  onPressed: onSubmit,
                ),
                SizedBox(width: 20)
              ],
            )
          ],
        ),
      ),
    );
  }
}
