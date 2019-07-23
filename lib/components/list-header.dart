import 'package:flutter/material.dart';

class ListHeader extends StatelessWidget {
  ListHeader({@required this.text});

  final String text;

  @override
  Widget build(BuildContext context) {
    return ListTile(
      title: Opacity(
        opacity: .54,
        child: Text(
          this.text,
          style: TextStyle(fontSize: 14, fontWeight: FontWeight.w500),
        ),
      ),
    );
  }
}
