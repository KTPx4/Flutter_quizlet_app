import 'package:flutter/material.dart';
import 'package:client_app/values/vocab_data.dart';


class VocabAnswersPage extends StatelessWidget {
  final List<Vocabulary> vocabList;
  final List<String> userAnswers;
  final bool isVietToEng;

  VocabAnswersPage(this.vocabList, this.userAnswers, this.isVietToEng);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Check Answers')),
      body: ListView.builder(
        itemCount: vocabList.length,
        itemBuilder: (context, index) {
          String question = isVietToEng ? vocabList[index].vietnamese : vocabList[index].english;
          String answer = isVietToEng ? vocabList[index].english : vocabList[index].vietnamese;
          String userAnswer = userAnswers.length > index ? (userAnswers[index].isEmpty ? "No answer provided" : userAnswers[index]) : "No answer provided";

          return ListTile(
            title: Text(question),
            subtitle: Text('Your Answer: $userAnswer\nCorrect Answer: $answer'),
          );
        },
      ),
    );
  }
}

