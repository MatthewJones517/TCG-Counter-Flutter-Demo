/**
 * Handles loading and saving all data
 */

import 'prefs_provider.dart';

class Repository {
  PrefsProvider _prefsProvider = PrefsProvider();

  void saveScore({int playerNum, int score}) {
    _prefsProvider.savePlayerScore(
      playerNum: playerNum,
      score: score,
    );
  }

  Future<int> getScore({int playerNum}) async {
    return await _prefsProvider.getPlayerScore(
      playerNum: playerNum,
    );
  }

  void saveCtr({int playerNum, int ctr}) {
    _prefsProvider.savePlayerCounter(
      playerNum: playerNum,
      ctrAmt: ctr,
    );
  }

  Future<int> getCtr({int playerNum}) async {
    return _prefsProvider.getPlayerCtr(
      playerNum: playerNum,
    );
  }
}
