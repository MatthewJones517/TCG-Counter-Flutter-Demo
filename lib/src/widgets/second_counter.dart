/**
 * Displays secondary counter widget
 */

import 'package:flutter/material.dart';
import '../blocs/provider.dart';

class SecondCounter extends StatelessWidget {
  Bloc _bloc;
  double screenWidth;
  int playerNum;

  SecondCounter({this.playerNum});

  Widget build(context) {
    // Access Bloc
    _bloc = Provider.of(context);

    // Get screen width. We use this to size the counter
    screenWidth = MediaQuery.of(context).size.width;

    // Create widget
    return GestureDetector(
      onTap: () {
        _bloc.toggleAltCtr(playerNum: playerNum);
      },
      child: Center(
        child: Container(
          width: screenWidth * .15,
          height: screenWidth * .15,
          margin: EdgeInsets.only(top: screenWidth * .50),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.all(Radius.circular(screenWidth * .02)),
            color: (playerNum == 1) ? Colors.red[100] : Colors.blue[200],
          ),
        ),
      ),
    );
  }
}
