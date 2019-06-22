import 'package:class_resources/services/authentication.dart';
import 'package:flutter_masked_text/flutter_masked_text.dart';
import 'package:flutter/material.dart';

class LoginPage extends StatefulWidget {
  LoginPage({this.auth, this.onSignedIn, this.onResetPass, this.toSignup});

  final AuthService auth;
  final VoidCallback onSignedIn;
  final VoidCallback onResetPass;
  final VoidCallback toSignup;

  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final _formKey = GlobalKey<FormState>();
  var controller = new MaskedTextController(mask: 'AA00-AAA-000');

  String email;
  String password;
  bool showPass = false;

  String rollNumValidator(String text) {
    return null;
  }

  String passValidator(String text) {
    return null;
  }

  IconButton _getSuffixIcon(obscureText) {
    if (!obscureText) return null;
    return IconButton(
      onPressed: () {
        setState(() {
          showPass = !showPass;
        });
      },
      icon: Icon(Icons.visibility),
    );
  }

  Widget paddedInput(label, validator, obscureText, controller, onSave) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 15.0),
      child: TextFormField(
        validator: validator,
        decoration: InputDecoration(
          labelText: label,
          border: OutlineInputBorder(),
          suffixIcon: _getSuffixIcon(obscureText),
        ),
        controller: controller,
        obscureText: obscureText ? !showPass : false,
        onSaved: onSave,
      ),
    );
  }

  void onLogin(_) {
    widget.onSignedIn();
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
          .signIn(email + "@cuilahore.edu.pk", password)
          .then(onLogin)
          .catchError((err) => onError(ctx, err));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Login"),
        actions: <Widget>[
          PopupMenuButton(
            onSelected: (val) => widget.toSignup(),
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
              paddedInput(
                "Roll Number (AA00-AAA-000)",
                rollNumValidator,
                false,
                controller,
                (value) => email = value,
              ),
              paddedInput(
                "Password",
                passValidator,
                true,
                null,
                (value) => password = value,
              ),
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 15.0),
                child: Text(
                  "Please contact admins to get the passwords",
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
                        onPressed: () => widget.onResetPass(),
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
