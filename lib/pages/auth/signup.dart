import 'package:class_resources/components/centered-appbar.dart';
import 'package:class_resources/components/illustrated-form.dart';
import 'package:class_resources/components/input.dart';
import 'package:class_resources/models/profile.model.dart';
import 'package:class_resources/models/user.model.dart';
import 'package:class_resources/pages/auth/update-profile.dart';
import 'package:class_resources/utils/route-transition.dart';
import 'package:class_resources/utils/validator.dart';
import 'package:flutter/material.dart';

class SignupPage extends StatefulWidget {
  final UserModel userModel;

  SignupPage(this.userModel);

  @override
  _SignupPageState createState() => _SignupPageState();
}

class _SignupPageState extends State<SignupPage> {
  final _formKey = GlobalKey<FormState>();
  TextEditingController _emailController = TextEditingController();
  TextEditingController _passwordController = TextEditingController();
  final _scaffoldKey = GlobalKey<ScaffoldState>();

  bool isLoading = false;

  void onError(err) {
    _scaffoldKey.currentState.showSnackBar(
      SnackBar(
        content: Text('${err?.message ?? err}'),
        action: SnackBarAction(
          label: 'Close',
          onPressed: () {},
        ),
      ),
    );
  }

  void onSubmit() async {
    setState(() => isLoading = true);
    if (_formKey.currentState.validate()) {
      try {
        var user = await widget.userModel.service
            .signUp(_emailController.text, _passwordController.text);
        setState(() => isLoading = false);
        Navigator.push(
          context,
          EnterExitRoute(
            exitPage: this.widget,
            enterPage: UpdateProfile(
              navigateToDashboard: true,
              profile: ProfileModel(user),
            ),
          ),
        );
      } catch (e) {
        setState(() => isLoading = false);
        onError(e);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      appBar: centeredAppBar(context, "Signup"),
      body: illustratedForm(
        imagePath: "assets/images/Login.png",
        isLoading: isLoading,
        key: _formKey,
        children: [
          PaddedInput(
            label: "Email",
            controller: _emailController,
            validator: emailValidator,
          ),
          PaddedInput(
            label: "Password",
            validator: passwordValidator,
            controller: _passwordController,
            obscureText: true,
          ),
          PaddedInput(
            label: "Confirm Password",
            validator: repasswordValidator(_passwordController),
            obscureText: true,
          ),
        ],
        primaryButton: RaisedButton(child: Text('Signup'), onPressed: onSubmit),
        secandaryButton: FlatButton(
          child: Text('Already have account?'),
          onPressed: () => Navigator.pushNamed(context, '/login'),
        ),
      ),
    );
  }
}
