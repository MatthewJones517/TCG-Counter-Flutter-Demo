/**
 * Displays secondary counter widget
 */

import 'package:flutter/material.dart';
import '../blocs/provider.dart';

class SecondCounter extends StatelessWidget {
  final int playerNum;
  final double widgetWidth;

  SecondCounter({@required this.playerNum, @required this.widgetWidth});

  Widget build(context) {
    // Access Bloc
    Bloc _bloc = Provider.of(context);

    return StreamBuilder(
      stream: _bloc.secondaryCountersActive,
      builder: (BuildContext context, AsyncSnapshot<bool> snapshot) {
        // if we don't have anything, return an empty container
        if (!snapshot.hasData) {
          return Container();
        }

        // If the counters are turned off, show nothing
        if (snapshot.data == false) {
          return Container();
        }

        // Otherwise show the counters
        return GestureDetector(
          onTap: () {
            _bloc.toggleAltCtr(playerNum: playerNum);
          },
          child: Center(
            child: Container(
              width: widgetWidth * .15,
              height: widgetWidth * .15,
              margin: EdgeInsets.only(top: widgetWidth * .50),
              decoration: BoxDecoration(
                borderRadius:
                    BorderRadius.all(Radius.circular(widgetWidth * .02)),
                color: (playerNum == 1) ? Colors.red[300] : Colors.blue[300],
              ),
              child: Stack(
                children: <Widget>[
                  secondaryCounterScore(context, _bloc, widgetWidth),
                  altCtrDeactivatedOverlay(context, _bloc, widgetWidth),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  Widget altCtrDeactivatedOverlay(
      BuildContext context, Bloc _bloc, double widgetWidth) {
    return StreamBuilder(
      stream: _bloc.clickAreaStreams[
          _bloc.getAltCtrClickAreaStream(playerNum: playerNum)],
      builder: (BuildContext context, AsyncSnapshot<bool> snapshot) {
        // Deactivate clickarea
        if (!snapshot.hasData || snapshot.data == false) {
          return Container(
            decoration: BoxDecoration(
              borderRadius:
                  BorderRadius.all(Radius.circular(widgetWidth * .02)),
              color: Color.fromARGB(75, 0, 0, 0),
            ),
          );
        }

        // Activate clickarea
        return Container();
      },
    );
  }

  Widget secondaryCounterScore(
      BuildContext context, Bloc _bloc, double widgetWidth) {
    return StreamBuilder(
      stream: _bloc.getAltCtrScoreStream(playerNum: playerNum),
      builder: (BuildContext context, AsyncSnapshot<int> snapshot) {
        if (snapshot.hasData) {
          return Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Text(
                snapshot.data.toString(),
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: Colors.white,
                  fontSize: widgetWidth * .085,
                ),
              ),
            ],
          );
        }

        return Container();
      },
    );
  }
}
