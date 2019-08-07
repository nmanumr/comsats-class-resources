import 'package:class_resources/components/centered-appbar.dart';
import 'package:class_resources/components/input.dart';
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
  PageController _pageController = PageController();
  var controller = new MaskedTextController(mask: 'AA00-AAA-000');

  String email;

  String notEmptyValidator(String val) {
    return (val ?? "") != '' ? null : 'Field can not be empty';
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

  void onSubmit() {
    _pageController.nextPage(
      curve: Curves.easeOutExpo,
      duration: Duration(milliseconds: 700),
    );
    // _formKey.currentState.save();
    // if (_formKey.currentState.validate()) {
    //   widget.auth
    //       .resetPassword(email)
    //       .then((val) => onEmailSent(ctx))
    //       .catchError((err) => onError(ctx, err));
    // }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: centeredAppBar(
        context,
        "",
        leading: IconButton(
          icon: Icon(Icons.close),
          onPressed: () => Navigator.of(context).pop(),
        ),
      ),
      body: PageView(
        controller: _pageController,
        physics: NeverScrollableScrollPhysics(),
        children: <Widget>[
          ListView(
            children: <Widget>[
              SizedBox(height: 30),
              Image.asset(
                "assets/images/forget.png",
                height: 230,
              ),
              SizedBox(height: 30),
              Align(
                alignment: Alignment.center,
                child: Text(
                  "Forget Password?",
                  style: Theme.of(context).textTheme.headline,
                ),
              ),
              SizedBox(height: 20),
              Align(
                alignment: Alignment.center,
                child: Opacity(
                  opacity: .7,
                  child: Text(
                    "Write your email below and we will contact you shortly.",
                    style: Theme.of(context).textTheme.subhead,
                  ),
                ),
              ),
              SizedBox(height: 20),
              PaddedInput(
                label: "Email",
                validator: notEmptyValidator,
                onSave: (value) => email = value,
              ),
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 20, vertical: 20),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: <Widget>[
                    RaisedButton.icon(
                      label: Text("Back"),
                      icon: Icon(Icons.keyboard_arrow_left),
                      onPressed: () => Navigator.pop(context),
                    ),
                    RaisedButton.icon(
                      label: Text("Submit"),
                      icon: Icon(Icons.send),
                      onPressed: onSubmit,
                    ),
                  ],
                ),
              )
            ],
          ),
          ListView(
            children: <Widget>[
              SizedBox(height: 50),
              Image.asset(
                "assets/images/sent.png",
                height: 230,
              ),
              SizedBox(height: 50),
              Align(
                alignment: Alignment.center,
                child: Text(
                  "Reset email sent",
                  style: Theme.of(context).textTheme.headline,
                ),
              ),
              SizedBox(height: 20),
              Align(
                alignment: Alignment.center,
                child: Opacity(
                  opacity: .7,
                  child: Text(
                    "Password reset email has been sent to the provided email.",
                    style: Theme.of(context).textTheme.subhead,
                  ),
                ),
              ),
              SizedBox(height: 40),
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 20, vertical: 20),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: <Widget>[
                    RaisedButton.icon(
                      label: Text("Back"),
                      icon: Icon(Icons.keyboard_arrow_left),
                      onPressed: () => _pageController.previousPage(
                        curve: Curves.easeOutExpo,
                        duration: Duration(milliseconds: 700),
                      ),
                    ),
                    RaisedButton.icon(
                      label: Text("OK"),
                      icon: Icon(Icons.done),
                      onPressed: () => Navigator.pop(context),
                    ),
                  ],
                ),
              )
            ],
          )
        ],
      ),
      // body: Form(
      //   key: _formKey,
      //   child: Padding(
      //     padding: EdgeInsets.symmetric(vertical: 15.0, horizontal: 20.0),
      //     child: Column(
      //       crossAxisAlignment: CrossAxisAlignment.start,
      //       children: <Widget>[
      //         Image.asset(
      //           "assets/images/forget.png",
      //           height: 230,
      //         ),
      //         PaddedInput(
      //           label: "Email",
      //           validator: notEmptyValidator,
      //           onSave: (value) => email = value,
      //         ),
      //         Padding(
      //           padding: const EdgeInsets.symmetric(vertical: 15.0),
      //           child: Text(
      //             "Password reset email will be sent to your university email (i.e., AA00-AAA-000@cuilahore.edu.pk)",
      //             style: TextStyle(
      //                 fontStyle: FontStyle.italic,
      //                 color: Theme.of(context).textTheme.caption.color),
      //           ),
      //         ),
      //         Padding(
      //           padding: const EdgeInsets.symmetric(vertical: 15.0),
      //           child: Builder(builder: (ctx) {
      //             return Row(
      //               children: <Widget>[
      //                 FlatButton(
      //                   padding: EdgeInsets.symmetric(
      //                       vertical: 12.0, horizontal: 25.0),
      //                   onPressed: () => widget.toLogin(),
      //                   child: Text('Goto Login'),
      //                 ),
      //                 Expanded(
      //                   child: Text(" "),
      //                 ),
      //                 RaisedButton(
      //                   textColor: Colors.white,
      //                   color: Theme.of(context).primaryColor,
      //                   padding: EdgeInsets.symmetric(
      //                       vertical: 12.0, horizontal: 25.0),
      //                   onPressed: () => onSubmit(ctx),
      //                   child: Text('Send'),
      //                 ),
      //               ],
      //             );
      //           }),
      //         ),
      //       ],
      //     ),
      //   ),
      // ),
    );
  }
}
