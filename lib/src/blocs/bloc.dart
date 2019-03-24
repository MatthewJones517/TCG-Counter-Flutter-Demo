/**
 * Handles state management for the app. 
 */

import 'dart:async';
import 'package:rxdart/rxdart.dart';

class Bloc {

  // Streams
  final BehaviorSubject<int> _player1Score = BehaviorSubject<int>();
  final BehaviorSubject<int> _player2Score = BehaviorSubject<int>();

  // Stream Getters
  BehaviorSubject<int> get player1ScoreStream => _player1Score.stream;
  BehaviorSubject<int> get player2ScoreStream => _player2Score.stream;

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
    BehaviorSubject<int> activeStream;
    if (player == 1) {
      activeStream = player1ScoreStream;
    } else {
      activeStream = player2ScoreStream;
    }

    // Update score accordingly
    if (addToScore) {
      activeStream.sink.add(activeStream.value++);
    } else {
      activeStream.sink.add(activeStream.value--);
    }
  }

}