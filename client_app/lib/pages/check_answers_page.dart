import 'package:client_app/values/quiz_data.dart';
import 'package:flutter/material.dart';


class CheckAnswersPage extends StatelessWidget {
  final List<String> userAnswers;

  CheckAnswersPage({Key? key, required this.userAnswers}) : super(key: key);

 
@override
Widget build(BuildContext context) {
  return Scaffold(
    appBar: AppBar(
      title: Text("Check Answers"),
    ),
    body: userAnswers.isEmpty
      ? Center(child: Text("There is no answer"))
      : ListView.builder(
          itemCount: questionsData.length,
          itemBuilder: (context, index) {
            final question = questionsData[index];
            return ListTile(
              title: Text(question.question, style: TextStyle(fontWeight: FontWeight.bold)),
              subtitle: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Text('Your Answer: ${index < userAnswers.length ? userAnswers[index] : "No answer"}', style: TextStyle(color: Colors.red)),
                  Text('Correct Answer: ${question.answer}', style: TextStyle(color: Colors.green)),
                ],
              ),
            );
          },
        ),
  );
}

}

