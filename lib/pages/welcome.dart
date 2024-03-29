import 'package:class_resources/models/profile.model.dart';
import 'package:class_resources/models/user.model.dart';
import 'package:class_resources/utils/route-transition.dart';
import 'package:flutter/material.dart';

import '../components/buttons.dart';
import 'auth/update-profile.dart';

class WelcomePage extends StatelessWidget {
  final _scaffoldKey = GlobalKey<ScaffoldState>();
  final UserModel userModel;

  WelcomePage(this.userModel);

  final textShadows = [
    Shadow(
      offset: Offset(0.0, 0.0),
      blurRadius: 3.0,
      color: Color.fromARGB(255, 0, 0, 0),
    ),
    Shadow(
      offset: Offset(0.0, 0.0),
      blurRadius: 8.0,
      color: Color.fromARGB(255, 0, 0, 0),
    ),
    Shadow(
      offset: Offset(0.0, 0.0),
      blurRadius: 20.0,
      color: Color.fromARGB(255, 0, 0, 0),
    ),
  ];

  void loginWithGoogle(context) async {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return Center(
          child: CircularProgressIndicator(),
        );
      },
    );

    try {
      var user = await userModel.service.signinWithGoogle();
      var profileExists = await userModel.service.hasProfile(user.uid);

      if (profileExists) {
        Navigator.pushNamedAndRemoveUntil(context, "/dashboard", (_) => false);
      } else {
        Navigator.push(
          context,
          EnterExitRoute(
            exitPage: this,
            enterPage: UpdateProfile(
              navigateToDashboard: true,
              profile: ProfileModel(user),
            ),
          ),
        );
      }
    } catch (err) {
      Navigator.pop(context);
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
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      body: Container(
        decoration: BoxDecoration(
          image: DecorationImage(
            image: AssetImage("assets/images/welcome-bg.jpeg"),
            fit: BoxFit.cover,
          ),
        ),
        child: Column(
          children: <Widget>[
            Expanded(
              child: Center(),
              flex: 1,
            ),
            Column(
              children: <Widget>[
                // Icon(Icons.book, size: 45),
                Image(
                  image: AssetImage("assets/images/logo.png"),
                  fit: BoxFit.contain,
                  width: 85,
                  height: 85,
                ),
                Padding(
                  padding: EdgeInsets.symmetric(vertical: 20),
                  child: Text(
                    "Class Resources",
                    style: Theme.of(context).textTheme.headline.copyWith(
                      shadows: [textShadows[0], textShadows[1]],
                    ),
                  ),
                ),
                Text(
                  "A platform to share and manage your\n class learning resources.",
                  textAlign: TextAlign.center,
                  style: Theme.of(context).textTheme.body1.copyWith(
                        fontSize: 16,
                        shadows: textShadows,
                      ),
                ),
              ],
            ),
            Expanded(
              child: Center(),
              flex: 2,
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(30, 0, 30, 30),
              child: Column(
                children: <Widget>[
                  Padding(
                    padding: const EdgeInsets.symmetric(vertical: 7),
                    child: SizedBox(
                      width: double.infinity,
                      child: GoogleSignInButton(
                        onPressed: () => loginWithGoogle(context),
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(vertical: 7),
                    child: SizedBox(
                      width: double.infinity,
                      child: BorderedButton(
                        prefix: Icon(
                          Icons.email,
                          size: 20,
                          color: Colors.white.withOpacity(0.91),
                        ),
                        onPressed: () =>
                            Navigator.pushNamed(context, '/signup'),
                      ),
                    ),
                  ),
                  FlatButton(
                    child: Text("Already have Account?"),
                    onPressed: () => Navigator.pushNamed(context, '/login'),
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
