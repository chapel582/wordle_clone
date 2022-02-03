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
  var guess = '';

  @override
  Widget build(BuildContext context) {
    const charBoxDecoration = BoxDecoration(
      color: Color(0xFF5F5F5F),
    );
    const charStyle = TextStyle(color: Color(0xFFFFFFFF));
    return Scaffold(
        appBar: AppBar(
          title: const Text('Wordle Clone'),
        ),
        backgroundColor: Color(0xFF000000),
        body: GestureDetector(
            child: GridView.count(
                crossAxisCount: 5,
                padding: const EdgeInsets.all(20),
                crossAxisSpacing: 5,
                mainAxisSpacing: 5,
                children: <Widget>[
              Container(
                child: Align(
                    alignment: Alignment.center,
                    child: Text('', style: charStyle)),
                decoration: charBoxDecoration,
              ),
              Container(
                  child: Align(
                      alignment: Alignment.center,
                      child: Text('', style: charStyle)),
                  decoration: charBoxDecoration),
              Container(
                  child: Align(
                      alignment: Alignment.center,
                      child: Text('', style: charStyle)),
                  decoration: charBoxDecoration),
              Container(
                  child: Align(
                      alignment: Alignment.center,
                      child: Text('', style: charStyle)),
                  decoration: charBoxDecoration),
              Container(
                  child: Align(
                      alignment: Alignment.center,
                      child: Text('', style: charStyle)),
                  decoration: charBoxDecoration),
              Container(
                  child: Align(
                      alignment: Alignment.center,
                      child: Text('F', style: charStyle)),
                  decoration: charBoxDecoration),
              Container(
                  child: Align(
                      alignment: Alignment.center,
                      child: Text('G', style: charStyle)),
                  decoration: charBoxDecoration),
              Container(
                  child: Align(
                      alignment: Alignment.center,
                      child: Text('H', style: charStyle)),
                  decoration: charBoxDecoration),
              Container(
                  child: Align(
                      alignment: Alignment.center,
                      child: Text('I', style: charStyle)),
                  decoration: charBoxDecoration),
              Container(
                  child: Align(
                      alignment: Alignment.center,
                      child: Text('J', style: charStyle)),
                  decoration: charBoxDecoration),
              Container(
                  child: Align(
                      alignment: Alignment.center,
                      child: Text('K', style: charStyle)),
                  decoration: charBoxDecoration),
              Container(
                  child: Align(
                      alignment: Alignment.center,
                      child: Text('L', style: charStyle)),
                  decoration: charBoxDecoration),
              Container(
                  child: Align(
                      alignment: Alignment.center,
                      child: Text('M', style: charStyle)),
                  decoration: charBoxDecoration),
              Container(
                  child: Align(
                      alignment: Alignment.center,
                      child: Text('N', style: charStyle)),
                  decoration: charBoxDecoration),
              Container(
                  child: Align(
                      alignment: Alignment.center,
                      child: Text('O', style: charStyle)),
                  decoration: charBoxDecoration),
              Container(
                  child: Align(
                      alignment: Alignment.center,
                      child: Text('P', style: charStyle)),
                  decoration: charBoxDecoration),
              Container(
                  child: Align(
                      alignment: Alignment.center,
                      child: Text('Q', style: charStyle)),
                  decoration: charBoxDecoration),
              Container(
                  child: Align(
                      alignment: Alignment.center,
                      child: Text('R', style: charStyle)),
                  decoration: charBoxDecoration),
              Container(
                  child: Align(
                      alignment: Alignment.center,
                      child: Text('S', style: charStyle)),
                  decoration: charBoxDecoration),
              Container(
                  child: Align(
                      alignment: Alignment.center,
                      child: Text('T', style: charStyle)),
                  decoration: charBoxDecoration),
              Container(
                  child: Align(
                      alignment: Alignment.center,
                      child: Text('U', style: charStyle)),
                  decoration: charBoxDecoration),
              Container(
                  child: Align(
                      alignment: Alignment.center,
                      child: Text('V', style: charStyle)),
                  decoration: charBoxDecoration),
              Container(
                  child: Align(
                      alignment: Alignment.center,
                      child: Text('W', style: charStyle)),
                  decoration: charBoxDecoration),
              Container(
                  child: Align(
                      alignment: Alignment.center,
                      child: Text('X', style: charStyle)),
                  decoration: charBoxDecoration),
              Container(
                  child: Align(
                      alignment: Alignment.center,
                      child: Text('Y', style: charStyle)),
                  decoration: charBoxDecoration),
              Container(
                  child: Align(
                      alignment: Alignment.center,
                      child: Text('Z', style: charStyle)),
                  decoration: charBoxDecoration),
              Container(
                  child: Align(
                      alignment: Alignment.center,
                      child: Text('A', style: charStyle)),
                  decoration: charBoxDecoration),
              Container(
                  child: Align(
                      alignment: Alignment.center,
                      child: Text('B', style: charStyle)),
                  decoration: charBoxDecoration),
              Container(
                  child: Align(
                      alignment: Alignment.center,
                      child: Text('C', style: charStyle)),
                  decoration: charBoxDecoration),
              Container(
                  child: Align(
                      alignment: Alignment.center,
                      child: Text('D', style: charStyle)),
                  decoration: charBoxDecoration),
              Visibility(
                  visible: false,
                  maintainState: true,
                  maintainAnimation: true,
                  maintainSize: true,
                  maintainInteractivity: true,
                  child: TextField(
                    autofocus: true,
                    autocorrect: false,
                    onChanged: (value) {
                      debugPrint(value);
                    }))
            ])));
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
