import 'package:flutter/material.dart';

class EmptyState extends StatelessWidget {
  EmptyState({this.icon, this.text, this.button});

  final IconData icon;
  final String text;
  final Widget button;

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Center(
          child: Column(
            children: <Widget>[
              ...(icon != null
                  ? [
                      Icon(
                        this.icon,
                        size: 65,
                        color: Theme.of(context).iconTheme.color.withAlpha(100),
                      ),
                    ]
                  : []),
              Padding(
                padding: EdgeInsets.only(top: 20),
                child: Text(
                  this.text,
                  style: TextStyle(
                    color:
                        Theme.of(context).textTheme.body1.color.withAlpha(180),
                  ),
                ),
              ),
              this.button ?? Center()
            ],
          ),
        ),
      ],
    );
  }
}
