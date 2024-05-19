import 'package:client_app/models/topic.dart';
import 'package:client_app/models/word.dart';
import 'package:client_app/pages/typing_exercise_page.dart';
import 'package:flutter/material.dart';

class TypingPage extends StatefulWidget {
  final List<Word> words;
  final Topic topic;
  TypingPage({required this.words, required this.topic});

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
                if(widget.words.length < 1)
                {
                  ScaffoldMessenger.of(context).clearSnackBars();
                  ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("Không có từ vựng để học")));
                  return;
                }
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => TypingExercisePage(words: widget.words, isTerm: true, topic: widget.topic,),
                  ),
                );
              },
              child: Text('Trả lời bằng thuật ngữ'),
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                if(widget.words.length < 1)
                {
                  ScaffoldMessenger.of(context).clearSnackBars();
                  ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("Không có từ vựng để học")));
                  return;
                }
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => TypingExercisePage(words: widget.words, isTerm: false, topic: widget.topic,),
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
