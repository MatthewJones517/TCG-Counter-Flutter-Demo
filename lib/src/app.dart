import 'package:flutter/material.dart';
import 'blocs/provider.dart';
import 'screens/home_screen.dart';

class App extends StatelessWidget {
  build(context) {
    return Provider(
      child: MaterialApp(
        title: 'TCG Counter',
        home: Home(),
      ),
    );
  }
}
