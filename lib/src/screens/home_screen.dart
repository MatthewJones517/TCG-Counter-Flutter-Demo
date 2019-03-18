import 'package:flutter/material.dart';

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
          player(1, Colors.red),
          player(2, Colors.blue),
        ],
      ),
    );
  }

  Widget player(int playerNum, Color playerColor) {
    return Expanded(
      flex: 5,
      child: Container(
        color: playerColor,
        child: Text("Player ${playerNum}"),
      ),
    );
  }
}
