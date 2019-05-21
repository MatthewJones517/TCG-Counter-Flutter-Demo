import 'package:flutter/material.dart';
import '../blocs/provider.dart';

class MenuDrawer extends StatelessWidget {
  Widget build(context) {
    Bloc bloc = Provider.of(context);

    return Drawer(
      child: Container(
        color: Colors.grey[900],
        padding: EdgeInsets.all(15),
        child: SafeArea(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: <Widget>[
              menuItem(
                context,
                title: 'HOME',
                route: '/',
                bloc: bloc,
              ),
              menuItem(
                context,
                title: 'SETTINGS',
                route: '/settings',
                bloc: bloc,
              ),
              menuItem(
                context,
                title: 'RESET',
                route: '/reset',
                bloc: bloc,
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget menuItem(BuildContext context, {String title, String route, Bloc bloc}) {
    return GestureDetector(
      onTap: () {
        if (route == '/reset') {
          // Reset all counters
          bloc.resetScores();

          // Close menu
          Navigator.of(context).pop();
          
        } else {
          Navigator.pushNamed(context, route);
        }
      },
      child: Text(
        title,
        textAlign: TextAlign.left,
        style: TextStyle(
          color: Colors.white,
          fontWeight: FontWeight.bold,
          fontSize: 46,
        ),
      ),
    );
  }
}
