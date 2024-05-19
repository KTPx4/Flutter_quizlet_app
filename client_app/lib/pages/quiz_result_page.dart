import 'package:client_app/apiservices/topicAPI.dart';
import 'package:flutter/material.dart';
import 'package:client_app/models/topic.dart';  // Đảm bảo đường dẫn đúng
import 'package:client_app/models/word.dart';
import 'package:client_app/pages/quiz_page.dart';  // Đảm bảo đường dẫn đúng

class QuizResultPage extends StatelessWidget {
  final int score;
  final List<Word> words;
  final List<String> userAnswers;
  final Topic topic;
  final bool showTermAsQuestion;

  QuizResultPage({
    required this.score,
    required this.words,
    required this.userAnswers,
    required this.topic,
    required this.showTermAsQuestion,
  });

  void _initStudy(context, id, correct, sum) async
  {
    
    if(correct == sum)
    {           
      var res = await TopicAPI.studyTopic(id: id);
      if(res["success"] == true)
      {
        ScaffoldMessenger.of(context).clearSnackBars();
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(res["message"])));
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    int correctCount = calculateCorrectAnswers();
    _initStudy(context ,topic.id, correctCount, words.length);
    double percentScore = (correctCount / words.length) * 100;

    List<Widget> answerDetails = [];
    for (int i = 0; i < words.length; i++) {
      bool isCorrect = (showTermAsQuestion ? words[i].mean2.title : words[i].mean1.title) == userAnswers[i];
      answerDetails.add(Column(
        children: <Widget>[
          Text('Câu hỏi: ${showTermAsQuestion ? words[i].mean1.title : words[i].mean2.title}'),
          Text('Câu trả lời của bạn: ${userAnswers[i]}'),
          Text('Câu trả lời đúng: ${showTermAsQuestion ? words[i].mean2.title : words[i].mean1.title}'),
          Divider(),
        ],
      ));
    }   
    return Scaffold(
      appBar: AppBar(title: Text('Kết quả Quiz')),
      body: SingleChildScrollView(
        child: Column(
          children: <Widget>[
            Text('Điểm số của bạn: ${percentScore.round()}%'),
            Text('Số câu đúng: $correctCount'),
            Text('Số câu sai: ${words.length - correctCount}'),
            ...answerDetails,
            ElevatedButton(
              onPressed: () {
                Navigator.pushAndRemoveUntil(
                  context,
                  MaterialPageRoute(builder: (context) => QuizPage(topic: topic, words: topic.words)),
                  (Route<dynamic> route) => false,
                );
              },
              child: Text('Làm lại'),
            ),
          ],
        ),
      ),
    );
  }

  int calculateCorrectAnswers() {
    int correctCount = 0;
    for (int i = 0; i < words.length; i++) {
      if ((showTermAsQuestion ? words[i].mean2.title : words[i].mean1.title) == userAnswers[i]) {
        correctCount++;
      }
    }    
    return correctCount;
  }
}



