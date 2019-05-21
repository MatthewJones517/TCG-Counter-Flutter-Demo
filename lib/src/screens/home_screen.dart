import 'package:flutter/material.dart';
import '../widgets/player.dart';
import '../blocs/provider.dart';

class Home extends StatelessWidget {
  Widget build(context) {
    Bloc _bloc = Provider.of(context);

    return Scaffold(
      drawer: Drawer(
        child:Container(
          color: Colors.grey[900],
        )
      ),
      appBar: AppBar(
        title: Text('TCG Counter'),
        actions: <Widget>[
          IconButton(
              icon: Icon(Icons.refresh),
              tooltip: 'Reset Scores',
              onPressed: () {
                _bloc.resetScores();
              }),
        ],
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
