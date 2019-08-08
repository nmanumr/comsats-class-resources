import 'package:class_resources/components/centered-appbar.dart';
import 'package:class_resources/utils/validator.dart';
import 'package:flutter/material.dart';

import 'package:class_resources/components/input.dart';
import 'package:class_resources/services/authentication.dart';

class LoginPage extends StatefulWidget {
  final AuthService auth = AuthService();

  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final _formKey = GlobalKey<FormState>();

  String email;
  String password;
  bool showPass = false;

  void onLogin(ctx) {
    Navigator.pushNamedAndRemoveUntil(ctx, '/dashboard', (r) => false);
  }

  void onError(ctx, err) {
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

  void onSubmit(ctx) {
    _formKey.currentState.save();
    if (_formKey.currentState.validate()) {
      widget.auth
          .signIn(email, password)
          .then((v) => onLogin(ctx))
          .catchError((err) => onError(ctx, err));
    }
  }

  void toSignup(ctx) {
    Navigator.pushNamed(ctx, '/signup');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
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
            Padding(
              padding:
                  const EdgeInsets.symmetric(vertical: 15.0, horizontal: 20),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  FlatButton(
                    onPressed: () => Navigator.pushNamed(context, '/resetpass'),
                    child: Text('Forget password?'),
                  ),
                  RaisedButton(
                    onPressed: () => onSubmit(context),
                    child: Text('Login'),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
