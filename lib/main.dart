// Copyright 2018 The Flutter team. All rights reserved.
// Use of this source code is governed by a BSD-style license that can be
// found in the LICENSE file.

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:math';

void main() {
  runApp(const MyApp());
}

void showAlertDialog(BuildContext context, String text) {
  // set up the buttons
  Widget cancelButton = TextButton(
    child: Text("Cancel"),
    onPressed: () {
      Navigator.of(context).pop();
    },
  );
  Widget continueButton = TextButton(
    child: Text("Continue"),
    onPressed: () {
      Navigator.of(context).pop();
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

void endGame(BuildContext context, String message) async{
  final prefs = await SharedPreferences.getInstance();

  var totalPlayed = prefs.getInt('totalPlayed') ?? 0;
  totalPlayed++;
  prefs.setInt('totalPlayed', totalPlayed);

  var totalWins = prefs.getInt('totalWins') ?? 0;
  prefs.setInt('totalWins', totalWins);

  debugPrint('plays: ${totalPlayed} wins: ${totalWins}');

  String finalMessage = '${message}\nWin Rate: ${totalWins / totalPlayed}\n';
  for(var round = 1; round <= 5; round++){
    var roundWins = prefs.getInt('round${round}Wins') ?? 0;
    finalMessage += 'Round ${round} wins: ${roundWins}\n';
  }

  showAlertDialog(context, finalMessage);
}

void winGame(BuildContext context, int winningRound) async{
  debugPrint('winningRound: ${winningRound}');
  final prefs = await SharedPreferences.getInstance();

  var totalWins = prefs.getInt('totalWins') ?? 0;
  totalWins++;
  prefs.setInt('totalWins', totalWins);

  var updateRoundWins = prefs.getInt('round${winningRound}Wins') ?? 0;
  debugPrint('${updateRoundWins}');
  updateRoundWins++;
  prefs.setInt('round${winningRound}Wins', updateRoundWins);

  endGame(context, "You won!");
}

enum GuessStateEnum { unchecked, not_present, present, correct }

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

  final TextEditingController _controller = TextEditingController();

  @override
  void initState() {
    super.initState();
    for (var i = 0; i < 30; i++) {
      guessState.add(GuessStateEnum.unchecked);
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
          autofocus: true,
          autocorrect: false,
          enableSuggestions: false,
          keyboardType: TextInputType.visiblePassword,
          maxLength: 5,
          onChanged: (value) {
            setState(
              () {
                if (value.length > 0) {
                  for (var i = startGuess; i < startGuess + value.length; i++) {
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
          },
          onSubmitted: (value) {
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
                    winGame(context, (startGuess / wordLength).toInt() + 1);
                  } else {
                    startGuess += wordLength;
                    _controller.clear();
                  }
                } else if (startGuess == 25) {
                  if (wordsMatch) {
                    winGame(context,  (startGuess / wordLength).toInt() + 1);
                  } else {
                    endGame(context, "You lost.");
                  }
                }
              } else {
                showAlertDialog(context, 'Unrecognized word');
              }
            });
          },
          onEditingComplete: () {},
        ),
      ),
    );

    return Scaffold(
      appBar: AppBar(
        title: const Text('Wordle Clone'),
      ),
      backgroundColor: Color(0xFF000000),
      body: GridView.count(
          crossAxisCount: 5,
          padding: const EdgeInsets.all(20),
          crossAxisSpacing: 5,
          mainAxisSpacing: 5,
          children: gridViewChildren),
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
    final wordSelector = Random(1643945711103346 + (difference.inHours / 24).toInt());
    this.word = words[wordSelector.nextInt(words.length)];
    debugPrint(this.word);
  }
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(title: 'Wordle Clone', home: LetterGrid());
  }
}
