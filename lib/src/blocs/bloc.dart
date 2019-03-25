/**
 * Handles state management for the app. 
 */

import 'dart:async';
import 'package:rxdart/rxdart.dart';

class Bloc {
  // Streams
  final BehaviorSubject<int> _player1Score = BehaviorSubject<int>();
  final BehaviorSubject<int> _player2Score = BehaviorSubject<int>();
  final BehaviorSubject<bool> _clickAreaP1Plus = BehaviorSubject<bool>();
  final BehaviorSubject<bool> _clickAreaP1Minus = BehaviorSubject<bool>();
  final BehaviorSubject<bool> _clickAreaP2Plus = BehaviorSubject<bool>();
  final BehaviorSubject<bool> _clickAreaP2Minus = BehaviorSubject<bool>();

  // Stream Getters
  BehaviorSubject<int> get player1ScoreStream => _player1Score.stream;
  BehaviorSubject<int> get player2ScoreStream => _player2Score.stream;
  BehaviorSubject<bool> get clickAreaP1PlusStream => _clickAreaP1Plus.stream;
  BehaviorSubject<bool> get clickAreaP1MinusStream => _clickAreaP1Minus.stream;
  BehaviorSubject<bool> get clickAreaP2PlusStream => _clickAreaP2Plus.stream;
  BehaviorSubject<bool> get clickAreaP2MinusStream => _clickAreaP2Minus.stream;

  // Timer used to autoincrement score as button is held down
  Timer _timer;
  int _timerStartingSpeed = 500;
  int _timerCurrentSpeed = 500;

  Bloc() {
    init();
  }

  void init() async {
    // Set player scores to defaults
    _player1Score.sink.add(20);
    _player2Score.sink.add(20);
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
    _player1Score.sink.add(20);
    _player2Score.sink.add(20);
  }

  BehaviorSubject<int> getScoreStream({int player}) {
    BehaviorSubject<int> activeStream;
    if (player == 1) {
      activeStream = _player1Score;
    } else {
      activeStream = _player2Score;
    }

    return activeStream;
  }

  void activateClickArea({int player, bool addToScore}) {
    // Choose stream we're updating.
    BehaviorSubject<bool> activeStream = getClickAreaStream(
      player: player,
      addToScore: addToScore,
    );

    activeStream.sink.add(true);
  }

  void deactivateClickArea({int player, bool addToScore}) {
    // Choose stream we're updating.
    BehaviorSubject<bool> activeStream = getClickAreaStream(
      player: player,
      addToScore: addToScore,
    );

    // Set current value to null
    activeStream.sink.add(null);
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

  void dispose() {
    _player1Score.close();
    _player2Score.close();
    _clickAreaP1Plus.close();
    _clickAreaP1Minus.close();
    _clickAreaP2Plus.close();
    _clickAreaP2Minus.close();
  }
}
