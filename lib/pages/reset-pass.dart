import 'package:class_resources/services/authentication.dart';
import 'package:flutter_masked_text/flutter_masked_text.dart';
import 'package:flutter/material.dart';

class ResetPassPage extends StatefulWidget {
  ResetPassPage({this.auth, this.toLogin});

  final AuthService auth;
  final VoidCallback toLogin;

  @override
  _ResetPassPageState createState() => _ResetPassPageState();
}

class _ResetPassPageState extends State<ResetPassPage> {
  final _formKey = GlobalKey<FormState>();
  var controller = new MaskedTextController(mask: 'AA00-AAA-000');

  String email;

  String rollNumValidator(String text) {
    return null;
  }

  Widget paddedInput(label, validator, obscureText, controller, onSave) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 15.0),
      child: TextFormField(
        validator: validator,
        decoration: InputDecoration(
          labelText: label,
          border: OutlineInputBorder(),
        ),
        controller: controller,
        onSaved: onSave,
      ),
    );
  }

  void onEmailSent(ctx) {
    Scaffold.of(ctx).showSnackBar(
      SnackBar(
        content: Text('Email has been sent to "$email@cuilahore.edu.pk"'),
        action: SnackBarAction(
          label: 'Login',
          onPressed: () => widget.toLogin(),
        ),
      ),
    );
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
          .resetPassword(email + "@cuilahore.edu.pk")
          .then((val) => onEmailSent(ctx))
          .catchError((err) => onError(ctx, err));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Reset Password"),
      ),
      body: Form(
        key: _formKey,
        child: Padding(
          padding: EdgeInsets.symmetric(vertical: 15.0, horizontal: 20.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              paddedInput(
                "Roll Number (AA00-AAA-000)",
                rollNumValidator,
                false,
                controller,
                (value) => email = value,
              ),
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 15.0),
                child: Text(
                  "Password reset email will be sent to your university email (i.e., AA00-AAA-000@cuilahore.edu.pk)",
                  style: TextStyle(
                      fontStyle: FontStyle.italic,
                      color: Theme.of(context).textTheme.caption.color),
                ),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 15.0),
                child: Builder(builder: (ctx) {
                  return Row(
                    children: <Widget>[
                      FlatButton(
                        padding: EdgeInsets.symmetric(
                            vertical: 12.0, horizontal: 25.0),
                        onPressed: () => widget.toLogin(),
                        child: Text('Goto Login'),
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
                        child: Text('Send'),
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
