/**
 * Handles state management for the app. 
 */

import 'dart:async';
import 'package:rxdart/rxdart.dart';
import '../resources/repository.dart';

class Bloc {
  // We're putting these streams in maps to make them easier to access.
  final Map<String, BehaviorSubject<int>> scoreStreams =
      Map<String, BehaviorSubject<int>>();
  final Map<String, BehaviorSubject<bool>> clickAreaStreams =
      Map<String, BehaviorSubject<bool>>();

  // Streams for other settings
  final BehaviorSubject<bool> secondaryCountersActive = BehaviorSubject<bool>();
  final BehaviorSubject<bool> mirrorPlayers = BehaviorSubject<bool>();
  Function(bool) get updateSecondaryCountersActive =>
      secondaryCountersActive.sink.add;
  Function(bool) get mirrorPlayersToggle => mirrorPlayers.sink.add;

  // Timer used to autoincrement score as button is held down
  Timer _timer;
  int _timerStartingSpeed = 500;
  int _timerCurrentSpeed = 500;

  // Get repository
  Repository _repository = Repository();

  // Settings
  int defaultScore;

  Bloc() {
    init();
  }

  void init() async {
    // Set up streams
    scoreStreams['player1Score'] = BehaviorSubject<int>();
    scoreStreams['player2Score'] = BehaviorSubject<int>();
    scoreStreams['player1AltCtr'] = BehaviorSubject<int>();
    scoreStreams['player2AltCtr'] = BehaviorSubject<int>();
    clickAreaStreams['clickAreaP1Plus'] = BehaviorSubject<bool>();
    clickAreaStreams['clickAreaP1Minus'] = BehaviorSubject<bool>();
    clickAreaStreams['clickAreaP2Plus'] = BehaviorSubject<bool>();
    clickAreaStreams['clickAreaP2Minus'] = BehaviorSubject<bool>();
    clickAreaStreams['clickAreaP1AltCtr'] = BehaviorSubject<bool>();
    clickAreaStreams['clickAreaP2AltCtr'] = BehaviorSubject<bool>();

    // Get default score
    defaultScore = await _repository.getDefaultScore();

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

    scoreStreams['player1Score'].sink.add(
          (p1Score != null) ? p1Score : defaultScore,
        );
    scoreStreams['player2Score'].sink.add(
          (p2Score != null) ? p2Score : defaultScore,
        );

    // Set up secondary counters
    secondaryCountersActive.sink
        .add(await _repository.getSecondaryCounterStatus());

    // Set secondary counters
    scoreStreams['player1AltCtr'].sink.add(p1Ctr);
    scoreStreams['player2AltCtr'].sink.add(p2Ctr);
  }

  void updateScore({int player, bool addToScore}) async {
    // Choose the stream we're updating.
    String activeStreamName = getScoreStreamName(
      player: player,
    );

    // Update score accordingly
    int value = scoreStreams[activeStreamName].value;
    if (addToScore) {
      value++;
    } else {
      value--;
    }

    // Add new score to sink
    scoreStreams[activeStreamName].sink.add(value);

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
    scoreStreams['player1Score'].sink.add(defaultScore);
    scoreStreams['player2Score'].sink.add(defaultScore);
    scoreStreams['player1AltCtr'].sink.add(0);
    scoreStreams['player2AltCtr'].sink.add(0);
    clickAreaStreams['clickAreaP1AltCtr'].add(false);
    clickAreaStreams['clickAreaP2AltCtr'].add(false);

    // Reset saved values
    _repository.saveScore(playerNum: 1, score: defaultScore);
    _repository.saveScore(playerNum: 2, score: defaultScore);
    _repository.saveCtr(playerNum: 1, ctr: 0);
    _repository.saveCtr(playerNum: 2, ctr: 0);
  }

  String getScoreStreamName({int player}) {
    String activeStream;
    if (player == 1) {
      if (clickAreaStreams['clickAreaP1AltCtr'].value != true) {
        activeStream = 'player1Score';
      } else {
        activeStream = 'player1AltCtr';
      }
    } else {
      if (clickAreaStreams['clickAreaP2AltCtr'].value != true) {
        activeStream = 'player2Score';
      } else {
        activeStream = 'player2AltCtr';
      }
    }

    return activeStream;
  }

  void handleTapDown({int player, bool addToScore}) {
    // Choose stream we're updating.
    String activeStreamName = getClickAreaStream(
      player: player,
      addToScore: addToScore,
    );

    clickAreaStreams[activeStreamName].sink.add(true);
  }

  void handleTapUp({int player, bool addToScore}) {
    // Choose stream we're updating.
    String activeStream = getClickAreaStream(
      player: player,
      addToScore: addToScore,
    );

    // Set current value to null
    clickAreaStreams[activeStream].sink.add(null);

    // Get the stream that has the current score
    String scoreStreamName = getScoreStreamName(
      player: player,
    );

    if (scoreStreamName == 'player1Score' ||
        scoreStreamName == 'player2Score') {
      // Save player score
      _repository.saveScore(
        playerNum: player,
        score: scoreStreams[scoreStreamName].value,
      );
    } else {
      // Save player counter
      _repository.saveCtr(
        playerNum: player,
        ctr: scoreStreams[scoreStreamName].value,
      );
    }
  }

  String getClickAreaStream({int player, bool addToScore}) {
    // Choose the stream we're updating
    String activeStream;

    if (player == 1) {
      if (addToScore) {
        activeStream = 'clickAreaP1Plus';
      } else {
        activeStream = 'clickAreaP1Minus';
      }
    } else {
      if (addToScore) {
        activeStream = 'clickAreaP2Plus';
      } else {
        activeStream = 'clickAreaP2Minus';
      }
    }

    return activeStream;
  }

  void toggleAltCtr({int playerNum}) {
    String activeStreamName = getAltCtrClickAreaStream(playerNum: playerNum);

    if (clickAreaStreams[activeStreamName].value == null) {
      clickAreaStreams[activeStreamName].sink.add(true);
    } else {
      clickAreaStreams[activeStreamName]
          .sink
          .add(!clickAreaStreams[activeStreamName].value);
    }
  }

  String getAltCtrClickAreaStream({int playerNum}) {
    if (playerNum == 1) {
      return 'clickAreaP1AltCtr';
    }

    return 'clickAreaP2AltCtr';
  }

  BehaviorSubject<int> getAltCtrScoreStream({int playerNum}) {
    if (playerNum == 1) {
      return scoreStreams['player1AltCtr'];
    } else {
      return scoreStreams['player2AltCtr'];
    }
  }

  void updateDefaultScore(int newDefault) {
    _repository.saveDefaultScore(newDefault);
    defaultScore = newDefault;
  }

  void dispose() {
    scoreStreams['player1Score'].close();
    scoreStreams['player2Score'].close();
    scoreStreams['player1AltCtr'].close();
    scoreStreams['player2AltCtr'].close();
    clickAreaStreams['clickAreaP1Plus'].close();
    clickAreaStreams['clickAreaP1Minus'].close();
    clickAreaStreams['clickAreaP2Plus'].close();
    clickAreaStreams['clickAreaP2Minus'].close();
    clickAreaStreams['clickAreaP1AltCtr'].close();
    clickAreaStreams['clickAreaP2AltCtr'].close();
    secondaryCountersActive.close();
    mirrorPlayers.close();
  }
}
