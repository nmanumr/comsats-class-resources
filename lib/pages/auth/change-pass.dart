import 'package:class_resources/components/centered-appbar.dart';
import 'package:class_resources/components/illustrated-form.dart';
import 'package:class_resources/components/illustrated-page.dart';
import 'package:class_resources/components/input.dart';
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
  final _scaffoldKey = GlobalKey<ScaffoldState>();
  bool isLoading = false;

  TextEditingController _passwordController = TextEditingController();
  TextEditingController _password2Controller = TextEditingController();

  void onSubmit(ctx) async {
    setState(() => isLoading = true);
    _formKey.currentState.save();
    if (_formKey.currentState.validate()) {
      try {
        await _authService.changePassword(_passwordController.text);
        _pageController.nextPage(
          curve: Curves.easeOutExpo,
          duration: Duration(milliseconds: 700),
        );
      } catch (err) {
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
    }
    setState(() => isLoading = false);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      appBar: centeredAppBar(context, "Change Password"),
      body: PageView(
        controller: _pageController,
        physics: NeverScrollableScrollPhysics(),
        children: <Widget>[
          illustratedForm(
            isLoading: isLoading,
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
          IllustartedPage(
            headingText: "Password Changed",
            imagePath: "assets/images/sent.png",
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
