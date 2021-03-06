import 'package:flutter/material.dart';
import '../blocs/provider.dart';
import '../widgets/menu_drawer.dart';
import '../widgets/player.dart';

class Home extends StatelessWidget {
  Widget build(context) {
    Bloc _bloc = Provider.of(context);

    return Scaffold(
      drawer: MenuDrawer(),
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
      body: body(context),
    );
  }

  Widget body(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;
    double screenHeight = MediaQuery.of(context).size.height;

    if (screenHeight > screenWidth) {
      return Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        mainAxisAlignment: MainAxisAlignment.center,
        children: players(
          isPortrait: true,
        ),
      );
    } else {
      return Row(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        mainAxisAlignment: MainAxisAlignment.center,
        children: players(
          isPortrait: false,
        ),
      );
    }
  }

  List<Widget> players({bool isPortrait}) {
    return <Widget> [
      Player(
            playerNum: 1,
            isPortrait: isPortrait,
          ),
          Player(
            playerNum: 2,
            isPortrait: isPortrait,
          ),
    ];
  }
}
