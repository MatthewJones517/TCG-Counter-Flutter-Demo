import 'package:flutter/material.dart';
import 'blocs/provider.dart';
import 'screens/home_screen.dart';

class App extends StatelessWidget {
  build(context) {
    return Provider(
      child: MaterialApp(
        title: 'TCG Counter',
        debugShowCheckedModeBanner: false,
        home: Home(),
        onGenerateRoute: routes,
      ),
    );
  }

  Route routes(RouteSettings settings) {
    switch (settings.name) {
      case '/':
        return homePage();
        break;

      default:
        return homePage();
        break;
    }
  }

  // Return the Home Page widget
  MaterialPageRoute homePage() {
    return MaterialPageRoute(
      settings: RouteSettings(
        name: '/',
      ),
      builder: (context) {
        return Home();
      },
    );
  }
}
