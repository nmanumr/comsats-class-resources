import 'package:flutter/material.dart';

class SuccessView extends StatelessWidget {
  final String imagePath;
  final String headingText;
  final String subheadingText;
  final Widget backButton;
  final Widget nextButton;

  SuccessView({
    @required this.imagePath,
    @required this.headingText,
    this.subheadingText,
    this.backButton,
    this.nextButton,
  });

  @override
  Widget build(BuildContext context) {
    return ListView(
      children: <Widget>[
        SizedBox(height: 50),
        Image.asset(
          imagePath,
          height: 230,
        ),
        SizedBox(height: 50),
        Align(
          alignment: Alignment.center,
          child: Text(
            headingText,
            style: Theme.of(context).textTheme.headline,
          ),
        ),
        SizedBox(height: 20),
        Align(
          alignment: Alignment.center,
          child: Opacity(
            opacity: .7,
            child: Text(
              subheadingText ?? " ",
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
              backButton ?? Text(" "),
              nextButton ?? Text(" "),
            ],
          ),
        )
      ],
    );
  }
}

// RaisedButton.icon(
//                 label: Text("Back"),
//                 icon: Icon(Icons.keyboard_arrow_left),
//                 onPressed: () => _pageController.previousPage(
//                   curve: Curves.easeOutExpo,
//                   duration: Duration(milliseconds: 700),
//                 ),
//               )

// RaisedButton.icon(
//                 label: Text("OK"),
//                 icon: Icon(Icons.done),
//                 onPressed: () => Navigator.pop(context),
//               )
