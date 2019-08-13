import 'package:class_resources/components/centered-appbar.dart';
import 'package:class_resources/components/illustrated-form.dart';
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
  final _scaffoldKey = GlobalKey<ScaffoldState>();

  String email;
  String password;
  bool showPass = false;
  bool isLoading = false;

  void onLogin(ctx) {
    Navigator.pushNamedAndRemoveUntil(ctx, '/dashboard', (r) => false);
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
        await widget.auth.signIn(email, password);
        onLogin(ctx);
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
