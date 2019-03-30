/**
 * Displays secondary counter widget
 */

import 'package:flutter/material.dart';
import '../blocs/provider.dart';

class SecondCounter extends StatelessWidget {
  Bloc _bloc;
  double screenWidth;

  Widget build(context) {
    // Access Bloc
    _bloc = Provider.of(context);

    // Get screen width. We use this to size the counter
    screenWidth = MediaQuery.of(context).size.width;

    // Create widget
    return Center(
      child: Container(
        color: Colors.black,
        width: screenWidth * .15,
        height: screenWidth * .15,
        margin: EdgeInsets.only(top:screenWidth * .50),
      ),
    );
  }
}
