import 'package:flutter/material.dart';
import 'screens/home_screen.dart';

class App extends StatelessWidget {
  build(context) {
    return MaterialApp(
      title: 'TCG Counter',
      home: Home(),
    );
  }
}
