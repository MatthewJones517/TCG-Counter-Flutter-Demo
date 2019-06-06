/** This widget handles the player fields on the home screen */
import 'dart:math' as math;
import 'package:flutter/material.dart';
import 'package:rxdart/rxdart.dart';
import 'second_counter.dart';
import '../blocs/provider.dart';

class Player extends StatelessWidget {
  // Widget properties
  final Color playerColor;
  final int playerNum;
  final bool isPortrait;

  Player(
      {@required this.playerColor,
      @required this.playerNum,
      @required this.isPortrait});

  Widget build(context) {
    // Set up properties
    Bloc _bloc = Provider.of(context);

    // Figure out player widget width. We have to divide the screen width in half if we're in landscape.
    double widgetWidth;
    if (isPortrait) {
      widgetWidth = MediaQuery.of(context).size.width;
    } else {
      widgetWidth = MediaQuery.of(context).size.width / 2;
    }

    // Return the actual player area. This is a stack made up of several elements.
    return Expanded(
      flex: 5,
      child: Container(
        color: playerColor,
        child: Transform.rotate(
          angle: ((_bloc.mirrorPlayers.value == true || _bloc.mirrorPlayers.value == null) && playerNum == 1) ? math.pi : 0,
          child: SafeArea(
            left: true,
            right: true,
            top: false,
            bottom: false,
            child: Stack(
              children: <Widget>[
                // Player name and score
                playerInfo(_bloc, widgetWidth),
                // Plus and minus indicators
                plusMinus(),
                // Activates when an area is tapped as UI feedback
                tapIndicators(_bloc),
                // Catches user taps
                tapAreas(_bloc),
                // Secondary Counter
                SecondCounter(
                  playerNum: playerNum,
                  widgetWidth: widgetWidth,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  // Display player title and current score
  Widget playerInfo(Bloc _bloc, double widgetWidth) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      mainAxisAlignment: MainAxisAlignment.center,
      children: <Widget>[
        playerTitle(widgetWidth),
        playerScore(_bloc, widgetWidth),
      ],
    );
  }

  Widget playerTitle(double widgetWidth) {
    return Padding(
      padding: EdgeInsets.only(bottom: (widgetWidth * .0025)),
      child: Text(
        "Player ${playerNum.toString()}",
        textAlign: TextAlign.center,
        style: TextStyle(
          fontWeight: FontWeight.bold,
          fontSize: widgetWidth * .1,
          color: Colors.white,
        ),
      ),
    );
  }

  Widget playerScore(Bloc _bloc, double widgetWidth) {
    // Get the appropriate stream
    String scoreStreamName = _bloc.getScoreStreamName(player: playerNum);

    // Return the score as a streambuilder
    return StreamBuilder(
      stream: _bloc.scoreStreams[scoreStreamName].stream,
      builder: (BuildContext context, AsyncSnapshot<int> snapshot) {
        if (!snapshot.hasData) {
          return Container();
        }

        return Padding(
          // Add padding to bottom if secondary counters are active. 
          padding: (_bloc.secondaryCountersActive.value == true) ? EdgeInsets.only(bottom: widgetWidth * .15) : EdgeInsets.only(bottom: 0),
          child: Text(
            snapshot.data.toString(),
            textAlign: TextAlign.center,
            style: TextStyle(
              color: Colors.white,
              fontSize: widgetWidth * .3,
              fontWeight: FontWeight.bold,
            ),
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
  Widget tapIndicators(Bloc _bloc) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: <Widget>[
        tapAreaIndicator(
            stream: _bloc.clickAreaStreams[_bloc.getClickAreaStream(
                addToScore: false, player: playerNum)]),
        tapAreaIndicator(
            stream: _bloc.clickAreaStreams[
                _bloc.getClickAreaStream(addToScore: true, player: playerNum)]),
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
  Widget tapAreas(Bloc _bloc) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: <Widget>[
        tapArea(
          _bloc,
          isPlus: false,
        ),
        tapArea(
          _bloc,
          isPlus: true,
        ),
      ],
    );
  }

  Widget tapArea(Bloc _bloc, {bool isPlus}) {
    return Expanded(
      flex: 5,
      child: GestureDetector(
        onTapDown: (_) {
          _bloc.handleTapDown(
            player: playerNum,
            addToScore: isPlus,
          );

          _bloc.updateScore(
            player: playerNum,
            addToScore: isPlus,
          );
        },
        onTapUp: (_) {
          _bloc.handleTapUp(
            player: playerNum,
            addToScore: isPlus,
          );

          _bloc.stopTimer();
        },
        // This has to be defined or else the area doesn't deactivate if the user
        // slides their finger off it after tapping down.
        onTapCancel: () {
          _bloc.handleTapUp(
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
