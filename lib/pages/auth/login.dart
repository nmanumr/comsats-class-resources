import 'package:class_resources/components/centered-appbar.dart';
import 'package:class_resources/components/illustrated-form.dart';
import 'package:class_resources/models/user.model.dart';
import 'package:class_resources/pages/dashboard.dart';
import 'package:class_resources/services/user.service.dart';
import 'package:class_resources/utils/route-transition.dart';
import 'package:class_resources/utils/validator.dart';
import 'package:firebase_analytics/observer.dart';
import 'package:flutter/material.dart';

import 'package:class_resources/components/input.dart';

class LoginPage extends StatefulWidget {
  final UserService userService = UserService("", null);
  final FirebaseAnalyticsObserver observer;

  LoginPage(this.observer);

  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final _formKey = GlobalKey<FormState>();
  final _scaffoldKey = GlobalKey<ScaffoldState>();

  String email;
  String password;
  bool showPass = false;
  bool isLoading = false;

  void onLogin(UserModel user) {
    Navigator.pushAndRemoveUntil(
        context,
        EnterExitRoute(
          exitPage: this.widget,
          enterPage: Dashboard(user, widget.observer),
        ),
        (_) => false);
  }

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

  void onSubmit(ctx) async {
    setState(() => isLoading = true);
    _formKey.currentState.save();
    if (_formKey.currentState.validate()) {
      try {
        var user = await widget.userService.signIn(email, password);
        onLogin(user);
      } catch (e) {
        onError(ctx, e);
      }
    }
    setState(() => isLoading = false);
  }

  void toSignup(ctx) {
    Navigator.pushNamed(ctx, '/signup');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      appBar: centeredAppBar(
        context,
        "Login",
        actions: <Widget>[
          PopupMenuButton(
            onSelected: (val) => toSignup(context),
            itemBuilder: (BuildContext context) {
              return [
                PopupMenuItem(
                  value: "signup",
                  child: Row(
                    children: [
                      Padding(
                        padding: EdgeInsets.only(right: 12),
                        child: Icon(Icons.person_add),
                      ),
                      Text("Signup"),
                    ],
                  ),
                )
              ];
            },
          ),
        ],
      ),
      body: illustratedForm(
        isLoading: isLoading,
        imagePath: "assets/images/Login.png",
        key: _formKey,
        children: <Widget>[
          PaddedInput(
            label: "Email",
            validator: emailValidator,
            onSave: (value) => email = value,
          ),
          PaddedInput(
            label: "Password",
            validator: passwordValidator,
            obscureText: true,
            onSave: (value) => password = value,
          ),
        ],
        secandaryButton: FlatButton(
          onPressed: () => Navigator.pushNamed(context, '/resetpass'),
          child: Text('Forget password?'),
        ),
        primaryButton: RaisedButton(
          onPressed: () => onSubmit(context),
          child: Text('Login'),
        ),
      ),
    );
  }
}
