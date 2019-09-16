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
          // colorScheme: Theme.of(context).buttonTheme.colorScheme.copyWith(
          //       brightness: this.isBordered ? Brightness.dark: Brightness.light,
          //     ),
          child: this.isBordered
              ? OutlineButton(
                  onPressed: onPressed,
                  color: buttonColor,
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: contents,
                  ),
                  highlightedBorderColor: buttonColor,
                  borderSide: BorderSide(color: buttonColor, width: 1),
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

/// A sign in button that matches Google's design guidelines.
///
/// The button text can be overridden, however the default text is recommended
/// in order to be compliant with the design guidelines and to maximise
/// conversion.
class BorderedButton extends StatelessWidget {
  final String text;
  final double borderRadius;
  final Widget prefix;
  final VoidCallback onPressed;

  /// Creates a new button. Set [darkMode] to `true` to use the dark
  /// blue background variant with white text, otherwise an all-white background
  /// with dark text is used.
  BorderedButton(
      {this.onPressed,
      this.text = 'Sign up with Email',
      this.borderRadius = defaultBorderRadius,
      this.prefix,
      Key key})
      : assert(text != null),
        super(key: key);

  @override
  Widget build(BuildContext context) {
    return StretchableButton(
      isBordered: true,
      buttonColor: Colors.white,
      borderRadius: borderRadius,
      onPressed: onPressed,
      buttonPadding: 0.0,
      children: <Widget>[
        // The Google design guidelines aren't consistent. The dark mode
        // seems to have a perfect square of white around the logo, with a
        // thin 1dp (ish) border. However, since the height of the button
        // is 40dp and the logo is 18dp, it suggests the bottom and top
        // padding is (40 - 18) * 0.5 = 11. That's 10dp once we account for
        // the thin border.
        //
        // The design guidelines suggest 8dp padding to the left of the
        // logo, which doesn't allow us to center the image (given the 10dp
        // above). Something needs to give - either the 8dp is wrong or the
        // 40dp should be 36dp. I've opted to increase left padding to 10dp.
        Padding(
          padding: const EdgeInsets.fromLTRB(10, 1, 1, 1),
          child: Container(
            height: 50.0, // 40dp - 2*1dp border
            width: 38.0, // matches above
            child: Center(
              child: prefix,
            ),
          ),
        ),
        Expanded(
          child: Center(
            child: Padding(
              padding: const EdgeInsets.fromLTRB(0.0, 8.0, 8.0, 8.0),
              child: Text(
                text,
                style: TextStyle(
                  fontSize: 18.0,
                  fontWeight: FontWeight.w600,
                  color: Colors.white.withOpacity(0.91),
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }
}

/// A sign in button that matches Google's design guidelines.
///
/// The button text can be overridden, however the default text is recommended
/// in order to be compliant with the design guidelines and to maximise
/// conversion.
class GoogleSignInButton extends StatelessWidget {
  final String text;
  final double borderRadius;
  final VoidCallback onPressed;

  /// Creates a new button. Set [darkMode] to `true` to use the dark
  /// blue background variant with white text, otherwise an all-white background
  /// with dark text is used.
  GoogleSignInButton(
      {this.onPressed,
      this.text = 'Sign up with Google',
      // Google doesn't specify a border radius, but this looks about right.
      this.borderRadius = defaultBorderRadius,
      Key key})
      : assert(text != null),
        super(key: key);

  @override
  Widget build(BuildContext context) {
    return StretchableButton(
      buttonColor: Colors.white,
      borderRadius: borderRadius,
      onPressed: onPressed,
      buttonPadding: 0.0,
      children: <Widget>[
        // The Google design guidelines aren't consistent. The dark mode
        // seems to have a perfect square of white around the logo, with a
        // thin 1dp (ish) border. However, since the height of the button
        // is 40dp and the logo is 18dp, it suggests the bottom and top
        // padding is (40 - 18) * 0.5 = 11. That's 10dp once we account for
        // the thin border.
        //
        // The design guidelines suggest 8dp padding to the left of the
        // logo, which doesn't allow us to center the image (given the 10dp
        // above). Something needs to give - either the 8dp is wrong or the
        // 40dp should be 36dp. I've opted to increase left padding to 10dp.
        Padding(
          padding: const EdgeInsets.fromLTRB(10, 1, 1, 1),
          child: Container(
            height: 50.0, // 40dp - 2*1dp border
            width: 38.0, // matches above
            child: Center(
              child: Image(
                image: AssetImage(
                  "assets/images/google-logo.png",
                ),
                height: 18.0,
                width: 18.0,
              ),
            ),
          ),
        ),
        Expanded(
          child: Center(
            child: Padding(
              padding: const EdgeInsets.fromLTRB(0.0, 8.0, 8.0, 8.0),
              child: Text(
                text,
                style: TextStyle(
                  fontSize: 18.0,
                  fontWeight: FontWeight.w600,
                  color: Colors.black.withOpacity(0.54),
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }
}
