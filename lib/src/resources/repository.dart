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

  void _saveDefaultScore(int defaultScore) {
    _prefsProvider.saveDefaultScore(defaultScore);
  }

  Future<int> _getDefaultScore() {
    return _prefsProvider.getDefaultScore();
  }

  Future<bool> _getSecondaryCounterStatus() async {
    bool status = await _prefsProvider.getSecondaryCounterStatus();

    // Counters are off by default.
    return (status != null) ? status : false;
  }

  void _updateSecondaryCounterStatus(bool countersOn) {
    _prefsProvider.updateSecondaryCounterStatus(countersOn);
  }

  // Defaults to on
  Future<bool> _getMirrorPlayerStatus() async {
    
    bool status = await _prefsProvider.getMirrorPlayerStatus();
    return (status != null) ? status : true;
  }

  void _updateMirrorPlayerStatus(bool mirrorPlayer) {
    _prefsProvider.updateMirrorPlayerStatus(mirrorPlayer);
  }

  Future<Map<String, dynamic>> getSettings() async {
    return {
      "defaultScore": await _getDefaultScore(),
      "mirrorPlayers": await _getMirrorPlayerStatus(),
      "secondaryCounters": await _getSecondaryCounterStatus(),
    };
  }

  void updateSettings({int defaultScore, bool mirrorPlayers, bool secondaryCounters}) {
    if (defaultScore != null) {
      _saveDefaultScore(defaultScore);
    }

    if (mirrorPlayers != null) {
      _updateMirrorPlayerStatus(mirrorPlayers);
    } 

    if (secondaryCounters!= null) {
      _updateSecondaryCounterStatus(secondaryCounters);
    }
  }
}
