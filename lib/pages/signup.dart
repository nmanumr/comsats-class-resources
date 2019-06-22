import 'dart:async';

import 'package:class_resources/services/authentication.dart';
import 'package:flutter_masked_text/flutter_masked_text.dart';
import 'package:flutter/material.dart';

class SignupPage extends StatefulWidget {
  SignupPage({this.auth, this.onSignedIn, this.toLogin});

  final AuthService auth;
  final VoidCallback onSignedIn;
  final VoidCallback toLogin;

  @override
  _SignupPageState createState() => _SignupPageState();
}

class _SignupPageState extends State<SignupPage> {
  final _formKey = GlobalKey<FormState>();
  var controller = new MaskedTextController(mask: 'AA00-AAA-000');

  Profile profile = Profile();

  String password2;
  String klass;
  List<String> _klasses = <String>[
    '',
    'FA18-BCS-A',
    'FA18-BCS-B',
    'FA18-BCS-C',
    'FA18-BCS-D',
    'FA18-BCS-E'
  ];
  bool showPass = false;

  String notEmptyValidator(String val) {
    return (val ?? "") != '' ? null : 'Field can not be empty';
  }

  String rePassValicator(String val) {
    if (val != profile.password) return "Password not matched";
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

  FutureOr<dynamic> onSignedUp(void x) {
    widget.onSignedIn();
  }

  void onSubmit(ctx) {
    _formKey.currentState.save();
    if (_formKey.currentState.validate()) {
      setState(() {
        profile.email = profile.rollNum + "@cuilahore.edu.pk";
      });
      widget.auth
          .signUp(profile)
          // .then(onSignedUp)
          .catchError((err) => onError(ctx, err));
      // widget.auth
      //     .signIn(email + "@cuilahore.edu.pk", password)
      //     .then(onLogin)
      //     .catchError((err) => onError(ctx, err));
    }
  }

  Widget classesDropDown() {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 15.0),
      child: FormField(
        validator: (_) {
          return (klass ?? "") != '' ? null : 'Field can not be empty';
        },
        builder: (FormFieldState state) {
          return InputDecorator(
            decoration: InputDecoration(
              border: OutlineInputBorder(),
              labelText: 'Classes',
              errorText: state.hasError ? state.errorText : null,
            ),
            isEmpty: klass == '' || klass == null,
            child: new DropdownButtonHideUnderline(
              child: new DropdownButton(
                value: klass,
                isDense: true,
                onChanged: (String newValue) {
                  setState(() {
                    klass = newValue;
                    profile.klass = newValue;
                  });
                },
                items: _klasses.map((String value) {
                  return new DropdownMenuItem(
                    value: value,
                    child: new Text(value),
                  );
                }).toList(),
              ),
            ),
          );
        },
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Signup"),
      ),
      body: Form(
        key: _formKey,
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16.0),
          child: ListView(
            children: <Widget>[
              paddedInput(
                "Roll Number (AA00-AAA-000)",
                notEmptyValidator,
                false,
                controller,
                (value) => profile.rollNum = value,
              ),
              paddedInput(
                "Your Name",
                notEmptyValidator,
                false,
                null,
                (value) => profile.name = value,
              ),
              paddedInput(
                "Password",
                notEmptyValidator,
                true,
                null,
                (value) => profile.password = value,
              ),
              paddedInput(
                "Confirm Password",
                rePassValicator,
                true,
                null,
                (value) => password2 = value,
              ),
              classesDropDown(),
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 15.0),
                child: Text(
                  "Class can not be changed once logged in.",
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
                        child: Text('Already have account?'),
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
