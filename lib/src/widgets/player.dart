/** This widget handles the player fields on the home screen */
import 'dart:math' as math;
import 'package:flutter/material.dart';
import 'package:rxdart/rxdart.dart';
import '../blocs/provider.dart';

class Player extends StatelessWidget {
  // Widget properties
  final Color playerColor;
  final int playerNum;
  double screenWidth;
  Bloc _bloc;

  Player({@required this.playerColor, @required this.playerNum});

  Widget build(context) {
    // Set up properties
    _bloc = Provider.of(context);
    screenWidth = MediaQuery.of(context).size.width;

    // Return the actual player area. This is a stack made up of several elements.
    return Expanded(
      flex: 5,
      child: Transform.rotate(
        angle: (playerNum == 1) ? math.pi : 0,
        child: Stack(
          children: <Widget>[
            // Player name and score
            playerInfo(),
            // Plus and minus indicators
            plusMinus(),
            // Activates when an area is tapped as UI feedback
            tapIndicators(),
            // Catches user taps
            tapAreas(),
          ],
        ),
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
      padding: EdgeInsets.only(bottom: (screenWidth * .0025)),
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
    // Get the appropriate stream
    BehaviorSubject<int> scoreStream = _bloc.getScoreStream(player: playerNum);

    // Return the score as a streambuilder
    return StreamBuilder(
      stream: scoreStream.stream,
      builder: (BuildContext context, AsyncSnapshot<int> snapshot) {
        if (!snapshot.hasData) {
          return Container();
        }

        return Text(
          snapshot.data.toString(),
          textAlign: TextAlign.center,
          style: TextStyle(
            color: Colors.white,
            fontSize: screenWidth * .3,
            fontWeight: FontWeight.bold,
          ),
        );
      },
    );
  }

  Widget plusMinus() {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: <Widget>[
        Container(
          margin: EdgeInsets.only(
            left: 20.0,
            right: 20.0,
          ),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              Text(
                '-',
                style: plusMinusFormatting(),
              ),
              Text(
                '+',
                style: plusMinusFormatting(),
              ),
            ],
          ),
        ),
      ],
    );
  }

  TextStyle plusMinusFormatting() {
    return TextStyle(
      fontSize: 40.0,
      color: Colors.white,
    );
  }

  // Returns the tap area indicators, which is just a semi-transparent black box. We have
  // to define colors for the containers or else they have no size, so we just define
  // transparent colors.
  Widget tapIndicators() {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: <Widget>[
        tapAreaIndicator(
            stream:
                _bloc.getClickAreaStream(addToScore: false, player: playerNum)),
        tapAreaIndicator(
            stream:
                _bloc.getClickAreaStream(addToScore: true, player: playerNum)),
      ],
    );
  }

  // Returns a single tap area indicator.
  Widget tapAreaIndicator({@required BehaviorSubject<bool> stream}) {
    return StreamBuilder(
      stream: stream.stream,
      builder: (BuildContext context, AsyncSnapshot<bool> snapshot) {
        // If we don't have any data, just return a transparent container
        if (!snapshot.hasData) {
          return Expanded(
            flex: 5,
            child: Container(
              color: Color.fromRGBO(0, 0, 0, 0),
            ),
          );
        }

        // If we do have data, return a slightly darkened rectangle.
        return Expanded(
          flex: 5,
          child: Container(
            color: Color.fromRGBO(0, 0, 0, 0.25),
          ),
        );
      },
    );
  }

  // This sets up the areas the user can tap to increment or decrement the score.
  Widget tapAreas() {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: <Widget>[
        tapArea(
          isPlus: false,
        ),
        tapArea(
          isPlus: true,
        ),
      ],
    );
  }

  Widget tapArea({bool isPlus}) {
    return Expanded(
      flex: 5,
      child: GestureDetector(
        onTapDown: (_) {
          _bloc.activateClickArea(
            player: playerNum,
            addToScore: isPlus,
          );

          _bloc.updateScore(
            player: playerNum,
            addToScore: isPlus,
          );
        },
        onTapUp: (_) {
          _bloc.deactivateClickArea(
            player: playerNum,
            addToScore: isPlus,
          );

          _bloc.stopTimer();
        },
        // This has to be defined or else the area doesn't deactivate if the user
        // slides their finger off it after tapping down.
        onTapCancel: () {
          _bloc.deactivateClickArea(
            player: playerNum,
            addToScore: isPlus,
          );

          _bloc.stopTimer();
        },
        child: Container(
          color: Color.fromRGBO(0, 0, 0, 0),
        ),
      ),
    );
  }
}
