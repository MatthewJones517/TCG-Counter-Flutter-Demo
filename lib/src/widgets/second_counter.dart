/**
 * Displays secondary counter widget
 */

import 'package:flutter/material.dart';
import '../blocs/provider.dart';

class SecondCounter extends StatelessWidget {
  final int playerNum;

  SecondCounter({this.playerNum});

  Widget build(context) {
    // Access Bloc
    Bloc _bloc = Provider.of(context);

    // Get screen width. We use this to size the counter
    double screenWidth = MediaQuery.of(context).size.width;

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
            color: (playerNum == 1) ? Colors.red[300] : Colors.blue[300],
          ),
          child: Stack(
            children: <Widget>[
              secondaryCounterScore(context, _bloc, screenWidth),
              altCtrDeactivatedOverlay(context, _bloc, screenWidth),
            ],
          ),
        ),
      ),
    );
  }

  Widget altCtrDeactivatedOverlay(BuildContext context, Bloc _bloc, double screenWidth) {
    return StreamBuilder(
      stream: _bloc.clickAreaStreams[_bloc.getAltCtrClickAreaStream(playerNum: playerNum)],
      builder: (BuildContext context, AsyncSnapshot<bool> snapshot) {
        // Deactivate clickarea
        if (!snapshot.hasData || snapshot.data == false) {
          return Container(
            decoration: BoxDecoration(
              borderRadius:
                  BorderRadius.all(Radius.circular(screenWidth * .02)),
              color: Color.fromARGB(75, 0, 0, 0),
            ),
          );
        }

        // Activate clickarea
        return Container();
      },
    );
  }

  Widget secondaryCounterScore(BuildContext context, Bloc _bloc, double screenWidth) {
    return StreamBuilder(
      stream: _bloc.getAltCtrScoreStream(playerNum: playerNum),
      builder: (BuildContext context, AsyncSnapshot<int> snapshot) {
        if (snapshot.hasData) {
          return Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[Text(snapshot.data.toString(),
            textAlign: TextAlign.center,
            style: TextStyle(
              color: Colors.white,
              fontSize: screenWidth * .085,
            ),
          ),],);
        }

        return Container();
      },
    );  
  }
}
