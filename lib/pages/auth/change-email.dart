import 'package:class_resources/components/centered-appbar.dart';
import 'package:class_resources/components/illustrated-form.dart';
import 'package:class_resources/components/input.dart';
import 'package:class_resources/components/success-view.dart';
import 'package:class_resources/services/authentication.dart';
import 'package:class_resources/utils/validator.dart';
import 'package:flutter/material.dart';

// TODO: Add re authenticate user before changing the password

class ChangeEmail extends StatefulWidget {
  @override
  createState() => _ChangeEmailState();
}

class _ChangeEmailState extends State<ChangeEmail> {
  final _formKey = GlobalKey<FormState>();
  final _scaffoldKey = GlobalKey<ScaffoldState>();
  PageController _pageController = PageController();
  AuthService _authService = AuthService();

  TextEditingController _emailController = TextEditingController();

  void onSubmit(ctx) async {
    _formKey.currentState.save();
    print("fsdf");
    if (_formKey.currentState.validate()) {
      print("fsdfdas");
      try {
        await _authService.changePassword(_emailController.text);
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
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      appBar: centeredAppBar(context, "Change Email"),
      body: PageView(
        controller: _pageController,
        physics: NeverScrollableScrollPhysics(),
        children: <Widget>[
          illustratedForm(
            key: _formKey,
            imagePath: "assets/images/Login.png",
            children: [
              PaddedInput(
                label: "New Email",
                controller: _emailController,
                validator: emailValidator,
              ),
            ],
            primaryButton: RaisedButton(
              child: Text("Change Email"),
              onPressed: () => onSubmit(context),
            ),
          ),
          SuccessView(
            headingText: "Email Updated",
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
