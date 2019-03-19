import 'package:flutter/material.dart';
import '../widgets/player.dart';

class Home extends StatelessWidget {
  Widget build(context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('TCG Counter'),
        backgroundColor: Colors.grey[800],
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          Player(
            playerNum: 1,
            playerColor: Colors.red,
          ),
          Player(
            playerNum: 2,
            playerColor: Colors.blue,
          ),
        ],
      ),
    );
  }
}
