import 'package:flutter/material.dart';

class HexColor extends Color {
  static int _getColorFromHex(String hexColor) {
    hexColor = hexColor.toUpperCase().replaceAll("#", "");
    if (hexColor.length == 6) {
      hexColor = "FF" + hexColor;
    }
    return int.parse(hexColor, radix: 16);
  }

  HexColor(final String hexColor) : super(_getColorFromHex(hexColor));
}

String rgbToHex(num r, num g, num b) {
  var rHex = r.toInt().toRadixString(16).padLeft(2, '0');
  var gHex = g.toInt().toRadixString(16).padLeft(2, '0');
  var bHex = b.toInt().toRadixString(16).padLeft(2, '0');
  return '#$rHex$gHex$bHex';
}

String hslToHex(List<num> hsl) {
  List<num> rgb = [0, 0, 0];

  num hue = hsl[0] / 360 % 1;
  num saturation = hsl[1] / 100;
  num luminance = hsl[2] / 100;

  if (hue < 1 / 6) {
    rgb[0] = 1;
    rgb[1] = hue * 6;
  } else if (hue < 2 / 6) {
    rgb[0] = 2 - hue * 6;
    rgb[1] = 1;
  } else if (hue < 3 / 6) {
    rgb[1] = 1;
    rgb[2] = hue * 6 - 2;
  } else if (hue < 4 / 6) {
    rgb[1] = 4 - hue * 6;
    rgb[2] = 1;
  } else if (hue < 5 / 6) {
    rgb[0] = hue * 6 - 4;
    rgb[2] = 1;
  } else {
    rgb[0] = 1;
    rgb[2] = 6 - hue * 6;
  }

  rgb = rgb.map((val) => val + (1 - saturation) * (0.5 - val)).toList();

  if (luminance < 0.5) {
    rgb = rgb.map((val) => luminance * 2 * val).toList();
  } else {
    rgb = rgb.map((val) => luminance * 2 * (1 - val) + 2 * val - 1).toList();
  }

  rgb = rgb.map((val) => (val * 255).round()).toList();

  return rgbToHex(rgb[0], rgb[1], rgb[2]);
}

String generateColor(String text, {s: 80, l: 45}) {
  var code = text.hashCode;
  return hslToHex([code % 360, s, l]);
}
