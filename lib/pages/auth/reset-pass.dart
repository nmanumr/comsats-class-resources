import 'package:class_resources/components/centered-appbar.dart';
import 'package:class_resources/components/illustrated-form.dart';
import 'package:class_resources/components/illustrated-page.dart';
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
  final _scaffoldKey = GlobalKey<ScaffoldState>();

  bool isLoading = false;

  String notEmptyValidator(String val) {
    return (val ?? "") != '' ? null : 'Field can not be empty';
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

  void onEmailSent() {
    _pageController.nextPage(
      curve: Curves.easeOutExpo,
      duration: Duration(milliseconds: 700),
    );
  }

  void onSubmit(ctx) async {
    setState(() => isLoading = true);
    try {
      await _authService.resetPassword(_controller.text);
      onEmailSent();
    } catch (err) {
      onError(ctx, err);
    }
    setState(() => isLoading = false);
  }

  Widget forgetPage() {
    return Builder(
      builder: (context) {
        return illustratedForm(
          imagePath: "assets/images/forget.png",
          isLoading: isLoading,
          children: [
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
          ],
          secandaryButton: RaisedButton.icon(
            label: Text("Back"),
            icon: Icon(Icons.keyboard_arrow_left),
            onPressed: () => Navigator.pop(context),
          ),
          primaryButton: RaisedButton.icon(
            label: Text("Submit"),
            icon: Icon(Icons.send),
            onPressed: () => onSubmit(context),
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
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
          IllustartedPage(
            headingText: "Reset email sent",
            subheadingText:
                "Password reset email has been sent to the provided email.",
            imagePath: "assets/images/sent.png",
            backButton: RaisedButton.icon(
              label: Text("Back"),
              icon: Icon(Icons.keyboard_arrow_left),
              onPressed: () => _pageController.previousPage(
                curve: Curves.easeOutExpo,
                duration: Duration(milliseconds: 700),
              ),
            ),
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
