/**
 * Handles state management for the app. 
 */

import 'dart:async';
import 'package:rxdart/rxdart.dart';
import '../resources/repository.dart';

class Bloc {
  // Streams
  final BehaviorSubject<int> _player1Score = BehaviorSubject<int>();
  final BehaviorSubject<int> _player2Score = BehaviorSubject<int>();
  final BehaviorSubject<int> _player1AltCtr = BehaviorSubject<int>();
  final BehaviorSubject<int> _player2AltCtr = BehaviorSubject<int>();
  final BehaviorSubject<bool> _clickAreaP1Plus = BehaviorSubject<bool>();
  final BehaviorSubject<bool> _clickAreaP1Minus = BehaviorSubject<bool>();
  final BehaviorSubject<bool> _clickAreaP2Plus = BehaviorSubject<bool>();
  final BehaviorSubject<bool> _clickAreaP2Minus = BehaviorSubject<bool>();
  final BehaviorSubject<bool> _clickAreaP1AltCtr = BehaviorSubject<bool>();
  final BehaviorSubject<bool> _clickAreaP2AltCtr = BehaviorSubject<bool>();

  // Stream Getters
  BehaviorSubject<int> get player1ScoreStream => _player1Score.stream;
  BehaviorSubject<int> get player2ScoreStream => _player2Score.stream;
  BehaviorSubject<int> get player1AltCtr => _player1AltCtr.stream;
  BehaviorSubject<int> get player2AltCtr => _player2AltCtr.stream;
  BehaviorSubject<bool> get clickAreaP1PlusStream => _clickAreaP1Plus.stream;
  BehaviorSubject<bool> get clickAreaP1MinusStream => _clickAreaP1Minus.stream;
  BehaviorSubject<bool> get clickAreaP2PlusStream => _clickAreaP2Plus.stream;
  BehaviorSubject<bool> get clickAreaP2MinusStream => _clickAreaP2Minus.stream;
  BehaviorSubject<bool> get clickAreaP1AltCtr => _clickAreaP1AltCtr.stream;
  BehaviorSubject<bool> get clickAreaP2AltCtr => _clickAreaP2AltCtr.stream;

  // Timer used to autoincrement score as button is held down
  Timer _timer;
  int _timerStartingSpeed = 500;
  int _timerCurrentSpeed = 500;

  // Get repository
  Repository _repository = Repository();

  // Settings
  int defaultScore = 20;

  Bloc() {
    init();
  }

  void init() async {
    // Set player scores to whatever value is saved in memory.
    int p1Score = await _repository.getScore(
      playerNum: 1,
    );

    int p2Score = await _repository.getScore(
      playerNum: 2,
    );

    int p1Ctr = await _repository.getCtr(
      playerNum: 1,
    );

    int p2Ctr = await _repository.getCtr(
      playerNum: 2,
    );

    _player1Score.sink.add(
      (p1Score != null) ? p1Score : defaultScore,
    );
    _player2Score.sink.add(
      (p2Score != null) ? p2Score : defaultScore,
    );

    // Set secondary counters
    _player1AltCtr.sink.add(p1Ctr);
    _player2AltCtr.sink.add(p2Ctr);
  }

  void updateScore({int player, bool addToScore}) async {
    // Choose the stream we're updating.
    BehaviorSubject<int> activeStream = getScoreStream(
      player: player,
    );

    // Update score accordingly
    int value = activeStream.value;
    if (addToScore) {
      value++;
    } else {
      value--;
    }

    // Add new score to sink
    activeStream.sink.add(value);

    // Update timer speed and call this method recursively
    _timer = new Timer(new Duration(milliseconds: _timerCurrentSpeed), () {
      // Keep deducting the time before the next increment by 50 seconds until we
      // get to the minimum amount of 100.
      if (_timerCurrentSpeed > 150) {
        _timerCurrentSpeed -= 50;
      }

      // Call this method recursively
      updateScore(
        player: player,
        addToScore: addToScore,
      );
    });
  }

  void stopTimer() {
    _timer.cancel();
    _timerCurrentSpeed = _timerStartingSpeed;
  }

  void resetScores() {
    // Reset Stream
    _player1Score.sink.add(defaultScore);
    _player2Score.sink.add(defaultScore);
    _player1AltCtr.sink.add(0);
    _player2AltCtr.sink.add(0);
    _clickAreaP1AltCtr.add(false);
    _clickAreaP2AltCtr.add(false);

    // Reset saved values
    _repository.saveScore(playerNum: 1, score: defaultScore);
    _repository.saveScore(playerNum: 2, score: defaultScore);
    _repository.saveCtr(playerNum: 1, ctr: 0);
    _repository.saveCtr(playerNum: 2, ctr: 0);
  }

  BehaviorSubject<int> getScoreStream({int player}) {
    BehaviorSubject<int> activeStream;
    if (player == 1) {
      if (_clickAreaP1AltCtr.value != true) {
        activeStream = _player1Score;
      } else {
        activeStream = _player1AltCtr;
      }
    } else {
      if (_clickAreaP2AltCtr.value != true) {
        activeStream = _player2Score;
      } else {
        activeStream = _player2AltCtr;
      }
    }

    return activeStream;
  }

  void handleTapDown({int player, bool addToScore}) {
    // Choose stream we're updating.
    BehaviorSubject<bool> activeStream = getClickAreaStream(
      player: player,
      addToScore: addToScore,
    );

    activeStream.sink.add(true);
  }

  void handleTapUp({int player, bool addToScore}) {
    // Choose stream we're updating.
    BehaviorSubject<bool> activeStream = getClickAreaStream(
      player: player,
      addToScore: addToScore,
    );

    // Set current value to null
    activeStream.sink.add(null);

    // Get the stream that has the current score
    BehaviorSubject<int> scoreStream = getScoreStream(
      player: player,
    );

    if (scoreStream == _player1Score || scoreStream == _player2Score) {
      // Save player score
      _repository.saveScore(
        playerNum: player,
        score: scoreStream.value,
      );
    } else {
      // Save player counter
      _repository.saveCtr(
        playerNum: player,
        ctr: scoreStream.value,
      );
    }
  }

  BehaviorSubject<bool> getClickAreaStream({int player, bool addToScore}) {
    // Choose the stream we're updating
    BehaviorSubject<bool> activeStream;

    if (player == 1) {
      if (addToScore) {
        activeStream = _clickAreaP1Plus;
      } else {
        activeStream = _clickAreaP1Minus;
      }
    } else {
      if (addToScore) {
        activeStream = _clickAreaP2Plus;
      } else {
        activeStream = _clickAreaP2Minus;
      }
    }

    return activeStream;
  }

  void toggleAltCtr({int playerNum}) {
    BehaviorSubject<bool> activeStream =
        getAltCtrClickAreaStream(playerNum: playerNum);

    if (activeStream.value == null) {
      activeStream.sink.add(true);
    } else {
      activeStream.sink.add(!activeStream.value);
    }
  }

  BehaviorSubject<bool> getAltCtrClickAreaStream({int playerNum}) {
    if (playerNum == 1) {
      return _clickAreaP1AltCtr;
    }

    return _clickAreaP2AltCtr;
  }

  BehaviorSubject<int> getAltCtrScoreStream({int playerNum}) {
    if (playerNum == 1) {
      return _player1AltCtr;
    } else {
      return _player2AltCtr;
    }
  }

  void dispose() {
    _player1Score.close();
    _player2Score.close();
    _clickAreaP1Plus.close();
    _clickAreaP1Minus.close();
    _clickAreaP2Plus.close();
    _clickAreaP2Minus.close();
    _player1AltCtr.close();
    _player2AltCtr.close();
  }
}
