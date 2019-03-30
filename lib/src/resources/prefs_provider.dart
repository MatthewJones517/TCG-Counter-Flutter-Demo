import 'package:shared_preferences/shared_preferences.dart';

class PrefsProvider {
  SharedPreferences prefs;
  Future prefsReady;

  PrefsProvider() {
    // We can't make a constructor async, so we call an init method. 
    prefsReady = init();
  }

  // Initiate shared prefs instance.
  Future init() async {
    prefs = await SharedPreferences.getInstance();
    return true;
  }

  void savePlayerScore({
    int playerNum,
    int score,
  }) async {
    // Make sure the shared preferences object has initialized before doing anything.
    await prefsReady;

    // Save Score.
    prefs.setInt('player' + playerNum.toString() + 'Score', score);
  }

  Future<int> getPlayerScore({int playerNum}) async {
    await prefsReady;

    int score = await prefs.getInt('player' + playerNum.toString() + 'Score');
    
    if (score != null) {
      return score;
    }

    return null;
  }
}
