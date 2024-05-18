import 'package:client_app/models/word.dart';
import 'package:client_app/pages/typing_exercise_page.dart';
import 'package:flutter/material.dart';

class TypingPage extends StatefulWidget {
  final List<Word> words;

  TypingPage({required this.words});

  @override
  _TypingPageState createState() => _TypingPageState();
}

class _TypingPageState extends State<TypingPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Typing Exercise"),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            ElevatedButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => TypingExercisePage(words: widget.words, isTerm: true),
                  ),
                );
              },
              child: Text('Trả lời bằng thuật ngữ'),
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => TypingExercisePage(words: widget.words, isTerm: false),
                  ),
                );
              },
              child: Text('Trả lời bằng định nghĩa'),
            ),
          ],
        ),
      ),
    );
  }
}
