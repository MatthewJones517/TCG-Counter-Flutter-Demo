import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../blocs/provider.dart';
import '../resources/themes.dart';
import '../widgets/menu_drawer.dart';

class Settings extends StatelessWidget {
  Widget build(context) {
    Bloc _bloc = Provider.of(context);

    return Scaffold(
      drawer: MenuDrawer(),
      appBar: AppBar(
        title: Text('Settings'),
        backgroundColor: Colors.grey[800],
      ),
      body: body(context, _bloc),
    );
  }

  Widget body(BuildContext context, Bloc _bloc) {
    return StreamBuilder(
      stream: _bloc.settings,
      builder:
          (BuildContext context, AsyncSnapshot<Map<String, dynamic>> snapshot) {
        if (!snapshot.hasData) {
          return Container();
        }

        return Stack(
          alignment: Alignment.topCenter,
          children: <Widget>[
            Container(
              color: Colors.grey[900],
            ),
            ListView(
              children: <Widget>[
                settingsHeading('Default Score:'),
                defaultScoreTextfield(_bloc, snapshot.data),
                settingsHeading('Secondary Counters:'),
                secondaryCounterSwitch(_bloc, snapshot.data),
                settingsHeading('Mirror Players:'),
                mirrorPlayersSwitch(_bloc, snapshot.data),
                settingsHeading('Player1 Theme:'),
                playerThemeSelection(1, _bloc, snapshot.data['player1Theme']),
                settingsHeading('Player2 Theme:'),
                playerThemeSelection(2, _bloc, snapshot.data['player2Theme']),
              ],
            ),
          ],
        );
      },
    );
  }

  Widget settingsHeading(String title) {
    return Container(
      padding: EdgeInsets.only(bottom: 10, top: 15),
      child: Text(
        title,
        textAlign: TextAlign.center,
        style: TextStyle(
          color: Colors.white,
          fontSize: 40,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }

  Widget defaultScoreTextfield(Bloc _bloc, Map<String, dynamic> snapshot) {
    TextEditingController _textController =
        TextEditingController(text: snapshot['defaultScore'].toString());

    return Align(
      alignment: Alignment.center,
      child: Container(
        width: 55,
        color: Colors.white,
        padding: EdgeInsets.all(10),
        child: TextField(
          decoration: InputDecoration.collapsed(
            border: InputBorder.none,
            hintText: '',
          ),
          controller: _textController,
          keyboardType: TextInputType.numberWithOptions(
            decimal: false,
            signed: false,
          ),
          inputFormatters: [
            LengthLimitingTextInputFormatter(2),
          ],
          style: TextStyle(
            fontSize: 28,
            fontWeight: FontWeight.bold,
          ),
          onChanged: (newDefault) {
            _bloc.updateSettings(
              newDefaultScore: int.parse(newDefault),
            );
          },
        ),
      ),
    );
  }

  Widget secondaryCounterSwitch(Bloc _bloc, Map<String, dynamic> snapshot) {
    return Align(
      alignment: Alignment.center,
      child: Container(
        width: 75,
        child: Switch(
          onChanged: (bool newValue) {
            _bloc.updateSettings(secondaryCounters: newValue);
          },
          value: snapshot['secondaryCounters'],
          activeColor: Colors.blue,
          inactiveTrackColor: Colors.blueGrey,
        ),
      ),
    );
  }

  Widget mirrorPlayersSwitch(Bloc _bloc, Map<String, dynamic> snapshot) {
    return Align(
      alignment: Alignment.center,
      child: Container(
        width: 75,
        child: Switch(
          onChanged: (bool newValue) {
            _bloc.updateSettings(
              mirrorPlayers: newValue,
            );
          },
          value: snapshot['mirrorPlayers'],
          activeColor: Colors.blue,
          inactiveTrackColor: Colors.blueGrey,
        ),
      ),
    );
  }

  Widget playerThemeSelection(int player, Bloc bloc, String activeTheme) {
    return Padding(
      padding: EdgeInsets.only(bottom: 20, top: 20),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: <Widget>[
          themeSwatch(
            theme: 'white',
            player: player,
            bloc: bloc,
            activeTheme: activeTheme,
          ),
          themeSwatch(
            theme: 'black',
            player: player,
            bloc: bloc,
            activeTheme: activeTheme,
          ),
          themeSwatch(
            theme: 'red',
            player: player,
            bloc: bloc,
            activeTheme: activeTheme,
          ),
          themeSwatch(
            theme: 'blue',
            player: player,
            bloc: bloc,
            activeTheme: activeTheme,
          ),
          themeSwatch(
            theme: 'green',
            player: player,
            bloc: bloc,
            activeTheme: activeTheme,
          ),
        ],
      ),
    );
  }

  Widget themeSwatch({String theme, int player, Bloc bloc, String activeTheme}) {
    Themes swatchThemes = Themes();

    Map<String, dynamic> colors = swatchThemes.choose(theme);

    return GestureDetector(
      onTap: () {
        bloc.updateSettings(
          player1Theme: (player == 1) ? theme : null,
          player2Theme: (player == 2) ? theme : null,
        );
      },
      child: Container(
        height: 50,
        width: 50,
        decoration: BoxDecoration(
          border: Border.all(
            width: (activeTheme == theme) ? 7 : 0,
            color: Colors.grey,
          ),
          color: colors['background'],
        ),
      ),
    );
  }
}
