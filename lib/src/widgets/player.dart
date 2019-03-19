/** This widget handles the player fields on the home screen */
import 'package:flutter/material.dart';

class Player extends StatelessWidget {
  final Color playerColor;
  final int playerNum;
  double screenWidth;

  Player({@required this.playerColor, @required this.playerNum});

  Widget build(context) {
    screenWidth = MediaQuery.of(context).size.width;

    return Expanded(
      flex: 5,
      child: Stack(
        children: <Widget>[
          playerInfo(),
          plusMinus(),
        ],
      ),
    );
  }

  Widget playerInfo() {
    return Container(
      color: playerColor,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          playerTitle(),
          playerScore(),
        ],
      ),
    );
  }

  Widget playerTitle() {
    return Padding(
      padding: EdgeInsets.only(bottom: (screenWidth * .05)),
      child: Text(
        "Player ${playerNum.toString()}",
        textAlign: TextAlign.center,
        style: TextStyle(
          fontWeight: FontWeight.bold,
          fontSize: screenWidth * .1,
          color: Colors.white,
        ),
      ),
    );
  }

  Widget playerScore() {
    return Text(
      '20',
      textAlign: TextAlign.center,
      style: TextStyle(
        color: Colors.white,
        fontSize: screenWidth * .3,
        fontWeight: FontWeight.bold,
      ),
    );
  }

  Widget plusMinus() {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: <Widget>[
        Text('-'),
        Text('+'),
      ],
    );
  }
}
