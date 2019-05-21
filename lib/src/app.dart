import 'package:flutter/material.dart';
import 'blocs/provider.dart';
import 'screens/home_screen.dart';
import 'screens/settings.dart';

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
        return pageRoute(
          routeName: '/',
          child: Home(),
        );
        break;

      case '/settings':
        return pageRoute(
          routeName: '/settings',
          child: Settings(),
        );
        break;

      default:
        return pageRoute(
          routeName: '/',
          child: Home(),
        );
        break;
    }
  }

  // Return page route
  MaterialPageRoute pageRoute({String routeName, Widget child}) {
    return MaterialPageRoute(
      settings: RouteSettings(
        name: routeName,
      ),
      builder: (context) {
        return child;
      },
    );
  }
}
