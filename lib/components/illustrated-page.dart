import 'package:flutter/material.dart';

class IllustartedPage extends StatelessWidget {
  final String imagePath;
  final String headingText;
  final String subheadingText;
  final Widget backButton;
  final Widget centerButton;
  final Widget nextButton;

  IllustartedPage({
    @required this.imagePath,
    @required this.headingText,
    this.centerButton,
    this.subheadingText,
    this.backButton,
    this.nextButton,
  });

  @override
  Widget build(BuildContext context) {
    return ListView(
      children: <Widget>[
        Image.asset(
          imagePath,
          height: 230,
        ),
        Padding(
          padding: const EdgeInsets.fromLTRB(20, 50, 20, 20),
          child: Text(
            headingText,
            style: Theme.of(context).textTheme.headline,
            textAlign: TextAlign.center,
          ),
        ),
        Padding(
          padding: const EdgeInsets.fromLTRB(20, 0, 20, 40),
          child: Opacity(
            opacity: .7,
            child: Text(
              subheadingText ?? " ",
              style: Theme.of(context).textTheme.subhead,
              textAlign: TextAlign.center,
            ),
          ),
        ),
        Center(
          child: centerButton != null ? centerButton : Text(""),
        ),
        Padding(
          padding: EdgeInsets.symmetric(horizontal: 20, vertical: 20),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              backButton ?? Text(" "),
              nextButton ?? Text(" "),
            ],
          ),
        ),
      ],
    );
  }
}
