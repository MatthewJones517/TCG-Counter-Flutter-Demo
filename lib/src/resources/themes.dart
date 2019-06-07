// Player color themes, based of MtG
import 'package:flutter/material.dart';

class Themes {
  final Map<String, Color> _black = {
    "background": Colors.black,
    "text": Colors.white,
    "secondaryCounterColor": Colors.black87,
  };

  final Map<String, Color> _red = {
    "background": Colors.red,
    "text": Colors.white,
    "secondaryCounterColor": Colors.red[300],
  };

  final Map<String, Color> _white = {
    "background": Colors.white,
    "text": Colors.black,
    "secondaryCounterColor": Colors.white70,
  };

  final Map<String, Color> _blue = {
    "background": Colors.blue,
    "text": Colors.white,
    "secondaryCounterColor": Colors.blue[300],
  };

  final Map<String, Color> _green = {
    "background": Colors.green,
    "text": Colors.white,
    "secondaryCounterColor": Colors.green[300],
  };

  Map<String, Color> choose(String color) {
    color = color.toLowerCase();

    switch (color) {
      case 'black':
        return _black;
        break;
      case 'red':
        return _red;
        break;
      case 'white':
        return _white;
        break;
      case 'blue':
        return _blue;
        break;
      case 'green':
        return _green;
        break;
      default:
        return null;
        break;
    }
  }
}
