import 'package:flutter/material.dart';

import './button.dart';

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
                  fontFamily: "Roboto",
                  fontWeight: FontWeight.w500,
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
