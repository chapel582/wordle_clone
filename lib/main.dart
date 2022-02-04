// Copyright 2018 The Flutter team. All rights reserved.
// Use of this source code is governed by a BSD-style license that can be
// found in the LICENSE file.

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'dart:math';

void main() {
  runApp(const MyApp());
}

class LetterGrid extends StatefulWidget {
  const LetterGrid({Key? key}) : super(key: key);

  @override
  _LetterGridState createState() => _LetterGridState();
}

class _LetterGridState extends State<LetterGrid> {
  var guesses = <String>[];
  int startGuess = 0;
  final wordLength = 5;
  String word = '';

  final TextEditingController _controller = TextEditingController();

  @override
  Widget build(BuildContext context) {
    loadWords();
    const charBoxDecoration = BoxDecoration(
      color: Color(0xFF5F5F5F),
    );
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
          decoration: charBoxDecoration,
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
            setState(
              () {
                if (startGuess < 25) {
                  startGuess += wordLength;
                  // TODO: handle reaching the end
                  _controller.clear();
                } else if (startGuess == 25) {}
              },
            );
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
    final words = rawWords.split('\n');
    final wordSelector = Random(1643945711103346);
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
