import 'dart:async';
import 'dart:math';
import 'package:client_app/pages/vocab_answers_page.dart';
import 'package:flutter/material.dart';
import 'package:client_app/values/vocab_data.dart';
import 'package:diacritic/diacritic.dart';

class TypingPractice extends StatefulWidget {
  final bool isVietToEng;
  TypingPractice({required this.isVietToEng});

  @override
  _TypingPracticeState createState() => _TypingPracticeState();
}

class _TypingPracticeState extends State<TypingPractice> {
  int currIdx = 0;
  final TextEditingController _controller = TextEditingController();
  int correctAnswers = 0;
  bool inputEnabled = true;
  List<String> userAnswers = [];

  @override
  void initState() {
    super.initState();
    vocabList.shuffle(Random());
  }

  bool isAnswerCorrect(String userAnswer, String correctAnswer) {
    String usAnswerLower = removeDiacritics(userAnswer.toLowerCase().trim());
    String crtAnswerLower =
        removeDiacritics(correctAnswer.toLowerCase().trim());
    List<String> keyAnswer = crtAnswerLower.split(' ');
    return keyAnswer.any((keyword) => usAnswerLower.contains(keyword));
  }

  void nextQuestion() {
    if (currIdx < vocabList.length - 1) {
      setState(() {
        currIdx++;
        inputEnabled = true;
      });
    } else {
      showCompletionDialog();
    }
  }

  void showCompletionDialog() {
    double percentage = correctAnswers / vocabList.length * 100;
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Well done!'),
        content: Text('Your Score: ${percentage.round()}%'),
        actions: <Widget>[
          TextButton(
            child: Text('OK'),
            onPressed: () {
              Navigator.of(context).pop();
              reset();
            },
          ),
          TextButton(
            child: Text('Check Answers'),
            onPressed: () {
              Navigator.of(context).pop();
              Navigator.of(context).push(MaterialPageRoute(
                  builder: (_) => VocabAnswersPage(
                      vocabList, userAnswers, widget.isVietToEng)));
            },
          ),
        ],
      ),
    );
  }

  void reset() {
    setState(() {
      currIdx = 0;
      correctAnswers = 0;
      userAnswers.clear();
      inputEnabled = true;
      vocabList.shuffle(Random());
    });
  }

  void checkAnswer() {
    String userAnswer = _controller.text;
    userAnswers.add(userAnswer);

    String correctAnswer = widget.isVietToEng
        ? vocabList[currIdx].english
        : vocabList[currIdx].vietnamese;
    bool answerIsCorrect = isAnswerCorrect(userAnswer, correctAnswer);

    ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(answerIsCorrect ? 'Correct!' : 'Incorrect!')));
    if (answerIsCorrect) {
      correctAnswers++;
    }

    _controller.clear();
    setState(() {
      inputEnabled = false;
    });
    Future.delayed(Duration(seconds: 4), () {
      if (currIdx < vocabList.length - 1) {
        setState(() {
          currIdx++;
          inputEnabled = true;
        });
      } else {
        showCompletionDialog();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
          title: Text(widget.isVietToEng
              ? "Vietnamese to English"
              : "English to Vietnamese")),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          Text(
              widget.isVietToEng
                  ? vocabList[currIdx].vietnamese
                  : vocabList[currIdx].english,
              style: TextStyle(fontSize: 24)),
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: TextField(
              controller: _controller,
              enabled: inputEnabled,
              onSubmitted: (value) => checkAnswer(),
              decoration: InputDecoration(
                labelText: "Type your answer",
                border: OutlineInputBorder(),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
