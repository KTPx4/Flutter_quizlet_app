import 'package:client_app/pages/typing_result_page.dart';
import 'package:flutter/material.dart';
import 'package:client_app/models/word.dart';
import 'package:diacritic/diacritic.dart';

class TypingExercisePage extends StatefulWidget {
  final List<Word> words;
  final bool isTerm;

  TypingExercisePage({required this.words, required this.isTerm});

  @override
  _TypingExercisePageState createState() => _TypingExercisePageState();
}

class _TypingExercisePageState extends State<TypingExercisePage> {
  int currentIndex = 0;
  final TextEditingController controller = TextEditingController();
  List<String> userAnswers = [];

String normalizeText(String input) {
  return removeDiacritics(input).toLowerCase();
}

  void handleAnswer(String value) {
  Word currentWord = widget.words[currentIndex];
  String correctAnswer = widget.isTerm ? currentWord.mean1.title : currentWord.mean2.title;
  userAnswers.add(value);  // Store the user answer for later use

  showDialog(
    context: context,
    builder: (ctx) => AlertDialog(
      title: Text(normalizeText(value.trim()) == normalizeText(correctAnswer) ? "Chính xác!" : "Sai rồi!"),
      content: Text(normalizeText(value.trim()) == normalizeText(correctAnswer) ?
        "Bạn đã chọn đáp án đúng." : "Đáp án chính xác là: $correctAnswer"),
      actions: <Widget>[
        TextButton(
          onPressed: () {
            Navigator.of(ctx).pop();
            if (currentIndex < widget.words.length - 1) {
              // Not the last question, so move to the next one
              setState(() {
                currentIndex++;
                controller.clear();
              });
            } else {
              // Last question, so calculate results and navigate to results page
              int totalCorrect = calculateCorrectAnswers();
              Navigator.push(context, MaterialPageRoute(builder: (context) => TypingResultPage(
                totalCorrect: totalCorrect,
                totalQuestions: widget.words.length,
                words: widget.words,
                userAnswers: userAnswers,
              )));
            }
          },
          child: Text("OK"),
        ),
      ],
    ),
  );
}

int calculateCorrectAnswers() {
  int totalCorrect = 0;
  for (int i = 0; i < widget.words.length; i++) {
    if (normalizeText(userAnswers[i]) == normalizeText(widget.isTerm ? widget.words[i].mean1.title : widget.words[i].mean2.title)) {
      totalCorrect++;
    }
  }
  return totalCorrect;
}


  @override
  Widget build(BuildContext context) {
    Word currentWord = widget.words[currentIndex];
    String question = widget.isTerm ? currentWord.mean2.title : currentWord.mean1.title;

    return Scaffold(
      appBar: AppBar(
        title: Text("Typing Exercise"),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Text('$question', style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold)),
            TextField(
              controller: controller,
              decoration: InputDecoration(
                labelText: 'Nhập câu trả lời của bạn',
              ),
              onSubmitted: handleAnswer,
            ),
          ],
        ),
      ),
    );
  }
}
