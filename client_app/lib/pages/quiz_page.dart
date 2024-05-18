import 'package:client_app/models/topic.dart';
import 'package:client_app/models/word.dart';
import 'package:client_app/pages/quiz_question_page.dart';
import 'package:flutter/material.dart';

class QuizPage extends StatefulWidget {
  final Topic topic;

  QuizPage({required this.topic, required List<Word> words});

  @override
  _QuizPageState createState() => _QuizPageState();
}

class _QuizPageState extends State<QuizPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Quiz - ${widget.topic.topicName}'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            // Trong QuizPage, khi bạn muốn chuyển đến QuizQuestionPage
            ElevatedButton(
              onPressed: () {
                // Giả sử bạn đang gọi QuizQuestionPage từ đây
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => QuizQuestionPage(
                      words: widget.topic.words, // Truyền danh sách từ
                      showTermAsQuestion:
                          false, // Hoặc false, tùy vào nút được bấm
                      topic: widget.topic, // Đây là tham số topic bạn cần thêm
                    ),
                  ),
                );
              },
              child: Text('Trả lời bằng thuật ngữ'),
            ),

            SizedBox(height: 20),
            // Trong QuizPage, khi bạn muốn chuyển đến QuizQuestionPage
            ElevatedButton(
              onPressed: () {
                // Giả sử bạn đang gọi QuizQuestionPage từ đây
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => QuizQuestionPage(
                      words: widget.topic.words, // Truyền danh sách từ
                      showTermAsQuestion:
                          true, // Hoặc false, tùy vào nút được bấm
                      topic: widget.topic, // Đây là tham số topic bạn cần thêm
                    ),
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
