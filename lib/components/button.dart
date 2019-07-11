import 'package:flutter/material.dart';

const double defaultBorderRadius = 40.0;

class StretchableButton extends StatelessWidget {
  final VoidCallback onPressed;
  final double borderRadius;
  final bool isBordered;
  final double buttonPadding;
  final Color buttonColor;
  final Color buttonBorderColor;
  final List<Widget> children;

  StretchableButton({
    @required this.buttonColor,
    @required this.borderRadius,
    @required this.children,
    this.isBordered = false,
    this.buttonBorderColor,
    this.onPressed,
    this.buttonPadding,
  });

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        var contents = List<Widget>.from(children);

        BorderSide bs;
        if (buttonBorderColor != null) {
          bs = BorderSide(
            color: buttonBorderColor,
          );
        } else {
          bs = BorderSide.none;
        }

        return ButtonTheme(
          height: 40.0,
          padding: EdgeInsets.all(buttonPadding),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(borderRadius),
            side: bs,
          ),
          colorScheme: Theme.of(context).buttonTheme.colorScheme.copyWith(
                brightness: this.isBordered ? Brightness.dark: Brightness.light,
              ),
          child: this.isBordered
              ? OutlineButton(
                  onPressed: onPressed,
                  color: buttonColor,
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: contents,
                  ),
                  highlightedBorderColor: buttonColor,
                  borderSide: BorderSide(
                    color: buttonColor,
                    width: 1
                  ),
                )
              : RaisedButton(
                  onPressed: onPressed,
                  color: buttonColor,
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: contents,
                  )),
        );
      },
    );
  }
}
