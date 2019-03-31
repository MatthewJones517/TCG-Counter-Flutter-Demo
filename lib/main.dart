import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'src/app.dart';

void main() async {
  // Force portrait mode.
  await SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]);
  
  runApp(App());
}