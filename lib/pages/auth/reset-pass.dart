import 'package:class_resources/components/centered-appbar.dart';
import 'package:class_resources/components/input.dart';
import 'package:class_resources/services/authentication.dart';
import 'package:class_resources/utils/validator.dart';
import 'package:flutter/material.dart';

class ResetPassPage extends StatefulWidget {
  ResetPassPage();

  @override
  _ResetPassPageState createState() => _ResetPassPageState();
}

class _ResetPassPageState extends State<ResetPassPage> {
  PageController _pageController = PageController();
  AuthService _authService = AuthService();
  TextEditingController _controller = TextEditingController();

  String notEmptyValidator(String val) {
    return (val ?? "") != '' ? null : 'Field can not be empty';
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

  void onEmailSent() {
    _pageController.nextPage(
      curve: Curves.easeOutExpo,
      duration: Duration(milliseconds: 700),
    );
  }

  void onSubmit(ctx) {
    _authService
        .resetPassword(_controller.text)
        .then((val) => onEmailSent())
        .catchError((err) => onError(ctx, err));
  }

  Widget forgetPage() {
    return Builder(
      builder: (context) => ListView(
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
            controller: _controller,
            validator: emailValidator,
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
                  onPressed: () => onSubmit(context),
                ),
              ],
            ),
          )
        ],
      ),
    );
  }

  Widget emailSent() {
    return Builder(
      builder: (context) => ListView(
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
      ),
    );
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
          forgetPage(),
          emailSent(),
        ],
      ),
    );
  }
}
