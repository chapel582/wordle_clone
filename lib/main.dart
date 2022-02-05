// Copyright 2018 The Flutter team. All rights reserved.
// Use of this source code is governed by a BSD-style license that can be
// found in the LICENSE file.

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:math';
import 'dart:async';

void main() {
  runApp(const MyApp());
}

enum GuessStateEnum { unchecked, not_present, present, correct }

void copyResults(List<GuessStateEnum> guessState) {
  String resultsText = '';
  for (var i = 0; i < guessState.length; i++) {
    if (guessState[i] == GuessStateEnum.unchecked) {
      break;
    } else if (guessState[i] == GuessStateEnum.not_present) {
      resultsText += '⬛';
    } else if (guessState[i] == GuessStateEnum.present) {
      resultsText += '🟨';
    } else if (guessState[i] == GuessStateEnum.correct) {
      resultsText += '🟩';
    }

    if ((i % 5) == 4) {
      resultsText += '\n';
    }
  }
  Clipboard.setData(ClipboardData(text: resultsText));
}

void showAlertDialog(BuildContext context, String text) {
  Widget cancelButton = TextButton(
    child: Text("Dismiss"),
    onPressed: () {
      Navigator.of(context).pop();
    },
  );

  // set up the AlertDialog
  AlertDialog alert = AlertDialog(
    title: Text("Alert"),
    content: Text(text),
    actions: [cancelButton],
  );

  // show the dialog
  showDialog(
    context: context,
    builder: (BuildContext context) {
      return alert;
    },
  );
}

void showEndGameAlert(
  BuildContext context,
  String text,
  List<GuessStateEnum> guessState,
) {
  // set up the buttons
  Widget cancelButton = TextButton(
    child: Text("Dismiss"),
    onPressed: () {
      Navigator.of(context).pop();
    },
  );
  Widget continueButton = TextButton(
    child: Text("Copy results"),
    onPressed: () {
      copyResults(guessState);
    },
  );

  // set up the AlertDialog
  AlertDialog alert = AlertDialog(
    title: Text("Results"),
    content: Text(text),
    actions: [
      cancelButton,
      continueButton,
    ],
  );

  // show the dialog
  showDialog(
    context: context,
    builder: (BuildContext context) {
      return alert;
    },
  );
}

void endGame(
  BuildContext context,
  String message,
  List<GuessStateEnum> guessState,
) async {
  final prefs = await SharedPreferences.getInstance();

  prefs.setString('lastPlayedTime', DateTime.now().toString());

  var totalPlayed = prefs.getInt('totalPlayed') ?? 0;
  totalPlayed++;
  prefs.setInt('totalPlayed', totalPlayed);

  var totalWins = prefs.getInt('totalWins') ?? 0;
  prefs.setInt('totalWins', totalWins);

  debugPrint('plays: ${totalPlayed} wins: ${totalWins}');

  String finalMessage = '${message}\nWin Rate: ${totalWins / totalPlayed}\n';
  for (var round = 1; round <= 5; round++) {
    var roundWins = prefs.getInt('round${round}Wins') ?? 0;
    finalMessage += 'Round ${round} wins: ${roundWins}\n';
  }

  showEndGameAlert(context, finalMessage, guessState);
}

void winGame(
  BuildContext context,
  int winningRound,
  List<GuessStateEnum> guessState,
) async {
  debugPrint('winningRound: ${winningRound}');
  final prefs = await SharedPreferences.getInstance();

  var totalWins = prefs.getInt('totalWins') ?? 0;
  totalWins++;
  prefs.setInt('totalWins', totalWins);

  var updateRoundWins = prefs.getInt('round${winningRound}Wins') ?? 0;
  debugPrint('${updateRoundWins}');
  updateRoundWins++;
  prefs.setInt('round${winningRound}Wins', updateRoundWins);

  endGame(context, "You won!", guessState);
}

class LetterGrid extends StatefulWidget {
  const LetterGrid({Key? key}) : super(key: key);

  @override
  _LetterGridState createState() => _LetterGridState();
}

class _LetterGridState extends State<LetterGrid> {
  var guesses = <String>[];
  var guessState = <GuessStateEnum>[];
  final charBoxDecorations = <BoxDecoration>[
    BoxDecoration(color: Color(0xFF5F5F5F)),
    BoxDecoration(color: Color(0xFF2F2F2F)),
    BoxDecoration(color: Color(0xFFFFDF00)),
    BoxDecoration(color: Color(0xFF32CD32)),
  ];
  int startGuess = 0;
  final wordLength = 5;
  String word = '';
  var words = <String>[];
  bool canPlay = true;

  final TextEditingController _controller = TextEditingController();
  FocusNode _focusNode = FocusNode();

  @override
  void initState() {
    super.initState();
    _updateCanPlay();
    for (var i = 0; i < 30; i++) {
      guessState.add(GuessStateEnum.unchecked);
    }
  }

  @override
  void dispose() {
    _focusNode.dispose();
    super.dispose();
  }

  void _deleteRecord() async{
    final prefs = await SharedPreferences.getInstance();
    prefs.clear();
    _updateCanPlay();
  }

  void _copyResults() {
    copyResults(guessState);
  }

  void _loseGame() {
    canPlay = false;
    endGame(context, 'You lost.', guessState);
  }

  void _winGame(int winningRound) {
    canPlay = false;
    winGame(context, winningRound, guessState);
  }

  void _updateCanPlay() async {
    final prefs = await SharedPreferences.getInstance();

    String lastPlayedTimeStr = prefs.getString('lastPlayedTime') ?? '';
    if (lastPlayedTimeStr != '') {
      final lastPlayedTime = DateTime.parse(lastPlayedTimeStr);
      final now = DateTime.now();
      final todayMidnight = DateTime(now.year, now.month, now.day);
      canPlay = lastPlayedTime.isBefore(todayMidnight);
    } else {
      canPlay = true;
    }
    if (canPlay) {
      setState(() {
        startGuess = 0;
        for (var i = 0; i < 30; i++) {
          guesses[i] = '';
        }
        for (var i = 0; i < 30; i++) {
          guessState[i] = GuessStateEnum.unchecked;
        }
      });
      _controller.clear();
    }
  }

  @override
  Widget build(BuildContext context) {
    loadWords();
    const charStyle = TextStyle(color: Color(0xFFFFFFFF), fontSize: 40);

    for (var i = 0; i < 30; i++) {
      guesses.add('');
    }

    var gridViewChildren = <Widget>[];

    for (var i = 0; i < 30; i++) {
      gridViewChildren.add(
        Container(
          child: Align(
              alignment: Alignment.center,
              child: Text(guesses[i], style: charStyle)),
          decoration: charBoxDecorations[guessState[i].index],
        ),
      );
    }

    gridViewChildren.add(
      Visibility(
        visible: false,
        maintainState: true,
        maintainAnimation: true,
        maintainSize: true,
        maintainInteractivity: true,
        child: TextField(
          controller: _controller,
          focusNode: _focusNode,
          autofocus: true,
          autocorrect: false,
          enableSuggestions: false,
          keyboardType: TextInputType.visiblePassword,
          maxLength: 5,
          onChanged: (value) {
            if (canPlay) {
              setState(
                () {
                  if (value.length > 0) {
                    for (var i = startGuess;
                        i < startGuess + value.length;
                        i++) {
                      guesses[i] = value[i % wordLength].toUpperCase();
                    }
                    for (var i = startGuess + value.length;
                        i < startGuess + wordLength;
                        i++) {
                      guesses[i] = '';
                    }
                  } else {
                    for (var i = startGuess; i < startGuess + wordLength; i++) {
                      guesses[i] = '';
                    }
                  }
                },
              );
            }
          },
          onSubmitted: (value) {
            if (canPlay) {
              setState(() {
                if (value.length == 5 && words.contains(value.toUpperCase())) {
                  bool wordsMatch = true;
                  for (var i = startGuess; i < startGuess + wordLength; i++) {
                    if (guesses[i] == word[i % wordLength]) {
                      guessState[i] = GuessStateEnum.correct;
                    } else if (word.contains(guesses[i])) {
                      guessState[i] = GuessStateEnum.present;
                    } else {
                      guessState[i] = GuessStateEnum.not_present;
                      wordsMatch = false;
                    }
                  }

                  if (startGuess < 25) {
                    if (wordsMatch) {
                      _winGame((startGuess / wordLength).toInt() + 1);
                    } else {
                      startGuess += wordLength;
                      _controller.clear();
                    }
                  } else if (startGuess == 25) {
                    if (wordsMatch) {
                      _winGame((startGuess / wordLength).toInt() + 1);
                    } else {
                      _loseGame();
                    }
                  }
                } else {
                  showAlertDialog(context, 'Unrecognized word');
                }
              });
            }
          },
          onEditingComplete: () {},
        ),
      ),
    );

    return Scaffold(
      appBar: AppBar(
        title: const Text('Wordle Clone'),
        actions: [
          IconButton(
            icon: const Icon(Icons.share),
            onPressed: _copyResults,
            tooltip: 'Copy results',
          ),
          IconButton(
              icon: const Icon(Icons.refresh),
              onPressed: _updateCanPlay,
              tooltip: 'Check for new game',),
          IconButton(
            icon: const Icon(Icons.delete),
            onPressed: _deleteRecord,
            tooltip: 'Delete game records'
          )
        ],
      ),
      backgroundColor: Color(0xFF000000),
      body: GridView.count(
          crossAxisCount: 5,
          padding: const EdgeInsets.all(10),
          crossAxisSpacing: 5,
          mainAxisSpacing: 5,
          children: gridViewChildren),
      resizeToAvoidBottomInset: false,
      floatingActionButton: FloatingActionButton(
        child: const Icon(Icons.keyboard),
        onPressed: () {
          setState(() {
            debugPrint('requesting focus???');
            FocusScope.of(context).unfocus();
            Timer(const Duration(milliseconds: 1), () {
              FocusScope.of(context).requestFocus(_focusNode);
            });
          });
        },
      ),
    );
  }

  void loadWords() async {
    String rawWords = await rootBundle.loadString('assets/words.txt');
    words = rawWords.split('\n');
    for (var i = 0; i < words.length; i++) {
      words[i] = words[i].trim().toUpperCase();
    }
    final now = DateTime.now();
    final difference = now.difference(DateTime(2022, DateTime.february, 3));
    final wordSelector =
        Random(1643945711103346 + (difference.inHours / 24).toInt());
    this.word = words[wordSelector.nextInt(words.length)];
  }
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(title: 'Wordle Clone', home: LetterGrid());
  }
}
