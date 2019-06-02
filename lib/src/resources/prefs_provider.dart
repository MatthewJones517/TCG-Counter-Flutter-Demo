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

    int score = prefs.getInt('player' + playerNum.toString() + 'Score');
    
    if (score != null) {
      return score;
    }

    return null;
  }

  void savePlayerCounter({int playerNum, int ctrAmt}) async {
    await prefsReady;
    prefs.setInt('player' + playerNum.toString() + 'ctr', ctrAmt);
  }

  Future<int> getPlayerCtr({int playerNum}) async {
    await prefsReady;

    int ctr = prefs.getInt('player' + playerNum.toString() + 'ctr');

    if (ctr != null) {
      return ctr;
    }

    return 0;
  }

  void saveDefaultScore(int defaultScore) async {
    await prefsReady;
    prefs.setInt('defaultscore', defaultScore);
  }

  Future<int> getDefaultScore() async {
    await prefsReady;

    int defaultScore = prefs.getInt('defaultscore');

    return (defaultScore != null) ? defaultScore : 20;
  }
}
