// Copyright 2018 The Flutter team. All rights reserved.
// Use of this source code is governed by a BSD-style license that can be
// found in the LICENSE file.

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

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

  final TextEditingController _controller = TextEditingController();

  @override
  Widget build(BuildContext context) {
    const charBoxDecoration = BoxDecoration(
      color: Color(0xFF5F5F5F),
    );
    const charStyle = TextStyle(color: Color(0xFFFFFFFF));

    for(var i = 0; i < 30; i++){
      guesses.add('');
    }

    var gridViewChildren = <Widget>[];
    
    for (var i = 0; i < 30; i++) {
      gridViewChildren.add(Container(
        child: Align(
            alignment: Alignment.center, child: Text(guesses[i], style: charStyle)),
        decoration: charBoxDecoration,
      ));
    }

    gridViewChildren.add(Visibility(
        visible: false,
        maintainState: true,
        maintainAnimation: true,
        maintainSize: true,
        maintainInteractivity: true,
        child: TextField(
            controller: _controller,
            autofocus: true,
            autocorrect: false,
            maxLength: 5,
            onChanged: (value) {
              debugPrint('${value}, ${startGuess}, ${guesses}');
              setState((){
                if(value.length > 0){
                  for(var i = startGuess; i < startGuess + value.length; i++){
                    guesses[i] = value[i % wordLength];
                  }
                  for(var i = startGuess + value.length; i < startGuess + wordLength; i++){
                    guesses[i] = '';
                  }
                }
                else{
                  for(var i = startGuess; i < startGuess + wordLength; i++){
                    guesses[i] = '';
                  }
                }
              });
            },
            onSubmitted: (value) {
              setState((){
                debugPrint('resetting text field?');
                startGuess += wordLength;
                // TODO: handle reaching the end
                _controller.clear();
              });
            },
            onEditingComplete: () {}
        )));

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
            children: gridViewChildren));
  }
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(title: 'Startup name generator', home: LetterGrid());
  }
}

// import 'package:flutter/material.dart';

// void main() => runApp(const MyApp());

// class MyApp extends StatelessWidget {
//   const MyApp({Key? key}) : super(key: key);

//   @override
//   Widget build(BuildContext context) {
//     return const MaterialApp(
//       title: 'Text Field Focus',
//       home: MyCustomForm(),
//     );
//   }
// }

// // Define a custom Form widget.
// class MyCustomForm extends StatefulWidget {
//   const MyCustomForm({Key? key}) : super(key: key);

//   @override
//   _MyCustomFormState createState() => _MyCustomFormState();
// }

// // Define a corresponding State class.
// // This class holds data related to the form.
// class _MyCustomFormState extends State<MyCustomForm> {
//   // Define the focus node. To manage the lifecycle, create the FocusNode in
//   // the initState method, and clean it up in the dispose method.
//   late FocusNode myFocusNode;

//   @override
//   void initState() {
//     super.initState();

//     myFocusNode = FocusNode();
//   }

//   @override
//   void dispose() {
//     // Clean up the focus node when the Form is disposed.
//     myFocusNode.dispose();

//     super.dispose();
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: const Text('Text Field Focus'),
//       ),
//       body: Padding(
//         padding: const EdgeInsets.all(16.0),
//         child: Column(
//           children: [
//             // The first text field is focused on as soon as the app starts.
//             const TextField(
//               autofocus: true,
//             ),
//             // The second text field is focused on when a user taps the
//             // FloatingActionButton.
//             TextField(
//               focusNode: myFocusNode,
//             ),
//           ],
//         ),
//       ),
//       floatingActionButton: FloatingActionButton(
//         // When the button is pressed,
//         // give focus to the text field using myFocusNode.
//         onPressed: () => myFocusNode.requestFocus(),
//         tooltip: 'Focus Second Text Field',
//         child: const Icon(Icons.edit),
//       ), // This trailing comma makes auto-formatting nicer for build methods.
//     );
//   }
// }
