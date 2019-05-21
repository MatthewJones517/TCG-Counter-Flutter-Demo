import 'package:flutter/material.dart';
import '../blocs/provider.dart';
import '../widgets/menu_drawer.dart';

class Settings extends StatelessWidget {
  Widget build(context) {
    Bloc _bloc = Provider.of(context);

    return Scaffold(
      drawer: MenuDrawer(),
      appBar: AppBar(
        title: Text('Settings'),
        backgroundColor: Colors.grey[800],
      ),
      body: body(context),
    );
  }

  Widget body(BuildContext context) {
    return Column(children: <Widget>[
      Text('Default Score'),
      Text('Secondary Counters'),
      Text('Mirror Players'),
      Text('Player Colors'),
    ],);
  }
}