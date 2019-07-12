import 'package:flutter/material.dart';

import '../components/bordered-button.dart';
import '../components/google-button.dart';

class WelcomePage extends StatelessWidget {
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
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
                      child: GoogleSignInButton(onPressed: () => {}),
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
                        onPressed: () => {},
                      ),
                    ),
                  ),
                  FlatButton(
                    child: Text("Already have Account?"),
                    onPressed: () => {},
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