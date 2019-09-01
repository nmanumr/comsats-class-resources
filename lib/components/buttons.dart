import 'package:flutter/material.dart';


class PrimaryFlatButton extends StatelessWidget {

  const PrimaryFlatButton({
    @required this.onPressed,
    this.onHighlightChanged,
    this.textTheme,
    this.disabledTextColor,
    this.color,
    this.disabledColor,
    this.focusColor,
    this.hoverColor,
    this.highlightColor,
    this.splashColor,
    this.colorBrightness,
    this.padding,
    this.shape,
    this.focusNode,
    this.materialTapTargetSize,
    @required this.child,
  });

  final VoidCallback onPressed;
  final ValueChanged<bool> onHighlightChanged;
  final ButtonTextTheme textTheme;
  final Color disabledTextColor;
  final Color color;
  final Color disabledColor;
  final Color focusColor;
  final Color hoverColor;
  final Color highlightColor;
  final Color splashColor;
  final Brightness colorBrightness;
  final EdgeInsetsGeometry padding;
  final ShapeBorder shape;
  final FocusNode focusNode;
  final MaterialTapTargetSize materialTapTargetSize;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    return FlatButton(
      onPressed: this.onPressed,
      onHighlightChanged: this.onHighlightChanged,
      textTheme: this.textTheme,
      textColor: Theme.of(context).accentColor,
      disabledTextColor: this.disabledTextColor,
      color: this.color,
      disabledColor: this.disabledColor,
      focusColor: this.focusColor,
      hoverColor: this.hoverColor,
      highlightColor: this.highlightColor,
      splashColor: this.splashColor,
      colorBrightness: this.colorBrightness,
      padding: this.padding,
      shape: this.shape,
      focusNode: this.focusNode,
      materialTapTargetSize: this.materialTapTargetSize,
      child: this.child,
    );
  }
}
