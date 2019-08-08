import 'package:class_resources/components/centered-appbar.dart';
import 'package:class_resources/components/illustrated-form.dart';
import 'package:class_resources/components/input.dart';
import 'package:class_resources/components/success-view.dart';
import 'package:class_resources/services/authentication.dart';
import 'package:class_resources/utils/validator.dart';
import 'package:flutter/material.dart';

// TODO: Add re authenticate user before changing the password

class ChangePass extends StatefulWidget {
  @override
  _ChangePassState createState() => _ChangePassState();
}

class _ChangePassState extends State<ChangePass> {
  final _formKey = GlobalKey<FormState>();
  PageController _pageController = PageController();
  AuthService _authService = AuthService();

  TextEditingController _passwordController = TextEditingController();
  TextEditingController _password2Controller = TextEditingController();

  void onSubmit(ctx) async {
    _formKey.currentState.save();
    if (_formKey.currentState.validate()) {
      try {
        await _authService.changePassword(_passwordController.text);
        _pageController.nextPage(
          curve: Curves.easeOutExpo,
          duration: Duration(milliseconds: 700),
        );
      } catch (err) {
        Scaffold.of(ctx).showSnackBar(
          SnackBar(
            content: Text('${err.message}'),
            action: SnackBarAction(
              label: 'Close',
              onPressed: () {},
            ),
          ),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: centeredAppBar(context, "Change Password"),
      body: PageView(
        controller: _pageController,
        physics: NeverScrollableScrollPhysics(),
        children: <Widget>[
          illustratedForm(
            key: _formKey,
            imagePath: "assets/images/Login.png",
            children: [
              PaddedInput(
                label: "New Password",
                controller: _passwordController,
                validator: passwordValidator,
                obscureText: true,
              ),
              PaddedInput(
                label: "Password Again",
                controller: _password2Controller,
                obscureText: true,
                validator: repasswordValidator(_passwordController),
              ),
            ],
            primaryButton: RaisedButton(
              child: Text("Change Password"),
              onPressed: () => onSubmit(context),
            ),
          ),
          SuccessView(
            headingText: "Password Changed",
            imagePath: "assets/images/sent.png",
            backButton: RaisedButton.icon(
              label: Text("Back"),
              icon: Icon(Icons.keyboard_arrow_left),
              onPressed: () => _pageController.previousPage(
                curve: Curves.easeOutExpo,
                duration: Duration(milliseconds: 700),
              ),
            ),
            nextButton: RaisedButton.icon(
              label: Text("OK"),
              icon: Icon(Icons.done),
              onPressed: () => Navigator.pop(context),
            ),
          ),
        ],
      ),
    );
  }
}
