import 'package:client_app/page/topic/topicStudy.dart';
import 'package:client_app/pages/typing_page.dart';
import 'package:flutter/material.dart';
import 'package:client_app/models/word.dart';

class TypingResultPage extends StatelessWidget {
  final int totalCorrect;
  final int totalQuestions;
  final List<Word> words;
  final List<String> userAnswers;

  TypingResultPage({
    required this.totalCorrect,
    required this.totalQuestions,
    required this.words,
    required this.userAnswers,
  });

  @override
  Widget build(BuildContext context) {
    double scorePercentage = (totalCorrect / totalQuestions) * 100;

    return Scaffold(
      appBar: AppBar(
        title: Text("Kết quả"),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: <Widget>[
            Text("Điểm số của bạn: ${scorePercentage.round()}%", style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold)),
            Text("Số câu đúng: $totalCorrect", style: TextStyle(fontSize: 18)),
            Text("Số câu sai: ${totalQuestions - totalCorrect}", style: TextStyle(fontSize: 18)),
            Expanded(
              child: ListView.builder(
                itemCount: words.length,
                itemBuilder: (context, index) {
                  Word word = words[index];
                  return ListTile(
                    title: Text("Câu hỏi: ${word.mean1.title} - ${word.mean2.title}"),
                    subtitle: Text("Câu trả lời của bạn: ${userAnswers[index]}\nCâu trả lời đúng: ${word.mean1.title}"),
                  );
                },
              ),
            ),
            
            ElevatedButton(
              onPressed: () {
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(builder: (context) => TypingPage(words: words)),
                );
              },
              child: Text('Làm lại'),
            ),
          ],
        ),
      ),
    );
  }
}
