import 'package:flutter/material.dart';
import 'package:client_app/models/word.dart';
import 'package:client_app/models/topic.dart'; // Import Topic model
import 'quiz_result_page.dart'; // Đảm bảo rằng bạn đã import trang kết quả QuizResultPage

class QuizQuestionPage extends StatefulWidget {
  final List<Word> words;
  final bool showTermAsQuestion;
  final Topic topic; // Thêm topic vào đây

  QuizQuestionPage(
      {required this.words,
      required this.showTermAsQuestion,
      required this.topic});

  @override
  _QuizQuestionPageState createState() => _QuizQuestionPageState();
}

class _QuizQuestionPageState extends State<QuizQuestionPage> {
  int currentQuestionIndex = 0;
  List<String> choices = [];
  List<String> userAnswers = []; // Danh sách lưu các câu trả lời của người dùng

  @override
  void initState() {
    super.initState();
    generateChoices();
  }

  void generateChoices() {
  List<String> allChoices = widget.words
      .map((word) => widget.showTermAsQuestion ? word.mean2.title : word.mean1.title)
      .toList();
  
  // Đáp án đúng cho câu hỏi hiện tại
  String correctAnswer = widget.showTermAsQuestion
      ? widget.words[currentQuestionIndex].mean2.title
      : widget.words[currentQuestionIndex].mean1.title;

  // Xóa đáp án đúng khỏi danh sách tạm thời để tránh trùng lặp
  allChoices.remove(correctAnswer);

  // Trộn danh sách và lấy ba đáp án sai
  allChoices.shuffle();
  List<String> wrongAnswers = allChoices.sublist(0, 3);

  // Kết hợp đáp án đúng và sai, sau đó trộn lần nữa
  choices = [...wrongAnswers, correctAnswer];
  choices.shuffle();
}


  void showAnswerDialog(String userAnswer) {
    bool isCorrect = userAnswer ==
        (widget.showTermAsQuestion
            ? widget.words[currentQuestionIndex].mean2.title
            : widget.words[currentQuestionIndex].mean1.title);
    userAnswers.add(userAnswer); // Lưu câu trả lời của người dùng

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text(isCorrect ? 'Bạn đã trả lời đúng' : 'Bạn đã trả lời sai'),
          actions: <Widget>[
            TextButton(
              child: Text('Ok'),
              onPressed: () {
                Navigator.of(context).pop();
                if (currentQuestionIndex + 1 < widget.words.length) {
                  // Chỉ tăng chỉ số nếu còn câu hỏi
                  setState(() {
                    currentQuestionIndex++;
                    generateChoices();
                  });
                } else {
                  // Kết thúc quiz và chuyển đến trang kết quả
                  Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(
                      builder: (context) => QuizResultPage(
                        score: calculateScore(),
                        words: widget.words,
                        userAnswers: userAnswers,
                        topic: widget.topic,
                        showTermAsQuestion:
                            widget.showTermAsQuestion, // Truyền giá trị này
                      ),
                    ),
                  );
                }
              },
            ),
          ],
        );
      },
    );
  }

  int calculateScore() {
    int score = 0;
    for (int i = 0; i < widget.words.length; i++) {
      String correctAnswer = widget.showTermAsQuestion
          ? widget.words[i].mean2.title
          : widget.words[i].mean1.title;
      if (userAnswers[i] == correctAnswer) {
        score++;
      }
    }
    return score;
  }

  @override
  Widget build(BuildContext context) {
    Word currentWord = widget.words[currentQuestionIndex];
    String question = widget.showTermAsQuestion
        ? currentWord.mean1.title
        : currentWord.mean2.title;
    String correctAnswer = widget.showTermAsQuestion
        ? currentWord.mean2.title
        : currentWord.mean1.title;

    return Scaffold(
      appBar: AppBar(
        title: Text('Quiz Question'),
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          Padding(
            padding: const EdgeInsets.all(20.0),
            child: Text('$question',
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
          ),
          Column(
            children: choices.map((choice) {
              return Padding(
                padding: const EdgeInsets.symmetric(vertical: 10.0),
                child: ElevatedButton(
                  onPressed: () {
                    showAnswerDialog(choice);
                  },
                  child: Text(choice, style: TextStyle(fontSize: 18)),
                  style: ElevatedButton.styleFrom(
                    minimumSize:
                        Size(double.infinity, 50), // set min width and height
                  ),
                ),
              );
            }).toList(),
          ),
        ],
      ),
    );
  }
}