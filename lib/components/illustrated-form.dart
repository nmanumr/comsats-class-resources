import 'package:flutter/material.dart';

// Why not a StatelessWidget? It causes following
// https://github.com/flutter/flutter/issues/16630

Widget illustratedForm({
  @required String imagePath,
  @required List<Widget> children,
  @required Widget primaryButton,
  Widget secandaryButton,
  bool isLoading = false,
  Key key,
}) {
  return Form(
    key: key,
    child: ListView(
      children: <Widget>[
        isLoading ? LinearProgressIndicator() : SizedBox(height: 6),
        SizedBox(height: 30),
        Image.asset(
          imagePath,
          height: 230,
        ),
        SizedBox(height: 30),
        ...children,
        Padding(
          padding: const EdgeInsets.symmetric(vertical: 15.0, horizontal: 20),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              secandaryButton ?? Text(" "),
              primaryButton,
            ],
          ),
        ),
      ],
    ),
  );
}
