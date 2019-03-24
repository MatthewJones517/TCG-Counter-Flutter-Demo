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
      addToScore: addToScore,
    );

    // Update score accordingly
    if (addToScore) {
      activeStream.sink.add(activeStream.value++);
    } else {
      activeStream.sink.add(activeStream.value--);
    }

    activeStream.close();
  }

  BehaviorSubject<int> getScoreStream({int player, bool addToScore}) {
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

    activeStream.close();
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
