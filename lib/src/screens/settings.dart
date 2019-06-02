import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../blocs/provider.dart';
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
    return Stack(
      alignment: Alignment.topCenter,
      children: <Widget>[
        Container(
          color: Colors.grey[900],
        ),
        ListView(
          children: <Widget>[
            settingsHeading('DEFAULT SCORE'),
            defaultScoreTextfield(_bloc),
            settingsHeading('Secondary Counters'),
            settingsHeading('Mirror Players'),
            settingsHeading('Player Colors'),
          ],
        ),
      ],
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

  Widget defaultScoreTextfield(Bloc _bloc) {
    TextEditingController _textController =
        TextEditingController(text: _bloc.defaultScore.toString());

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
            _bloc.updateDefaultScore(int.parse(newDefault));
          },
        ),
      ),
    );
  }
}
