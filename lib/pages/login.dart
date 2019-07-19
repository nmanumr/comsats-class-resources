import 'package:class_resources/components/centered-appbar.dart';
import 'package:flutter/material.dart';

import 'package:class_resources/components/paddedInput.dart';
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

  String notEmptyValidator(String val) {
    return (val ?? "") != '' ? null : 'Field can not be empty';
  }

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
        child: Padding(
          padding: EdgeInsets.symmetric(vertical: 15.0, horizontal: 20.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              PaddedInput(
                label: "Email",
                validator: notEmptyValidator,
                onSave: (value) => email = value,
              ),
              PaddedInput(
                label: "Password",
                validator: notEmptyValidator,
                obscureText: true,
                onSave: (value) => password = value,
              ),
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 15.0),
                child: Builder(builder: (ctx) {
                  return Row(
                    children: <Widget>[
                      FlatButton(
                        padding: EdgeInsets.symmetric(
                            vertical: 12.0, horizontal: 25.0),
                        onPressed: () {},
                        child: Text('Forget password?'),
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
                        child: Text('Login'),
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
