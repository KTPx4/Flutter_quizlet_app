
import 'package:flutter/material.dart';
import 'dart:math';
import 'package:client_app/models/word.dart';

class QuizPage extends StatefulWidget {
  final List<Word> words;
  final int numberOfQuestions;
  final bool showAnswersImmediately;
  final String answerType;

  QuizPage({
    Key? key,
    required this.words,
    required this.numberOfQuestions,
    required this.showAnswersImmediately,
    required this.answerType,
  }) : super(key: key);

  @override
  _QuizPageState createState() => _QuizPageState();
}

class _QuizPageState extends State<QuizPage> {
  List<Word> questions = [];
  Random rand = Random();
  int currentQuestionIndex = 0;

  @override
  void initState() {
    super.initState();
    initializeQuiz();  // Khởi tạo quiz khi state bắt đầu
  }

  // Hàm trợ giúp để khởi tạo và chờ đợi việc tạo danh sách câu hỏi
  Future<void> initializeQuiz() async {
    await _test();
    if (mounted) setState(() {});  // Cập nhật giao diện nếu widget vẫn tồn tại
  }

  Future<void> _test() async {
    if (widget.words.length >= widget.numberOfQuestions) {
      questions = List<Word>.from(widget.words)..shuffle();
      questions = questions.sublist(0, widget.numberOfQuestions);
    } else {
      questions = [...widget.words]..shuffle();
    }
  }

  List<String> _generateOptions(String correctAnswer, bool isTerm) {
  List<String> allAnswers = widget.words.map<String>((word) => isTerm ? word.mean1.title : word.mean2.title).toList();
  Set<String> options = {correctAnswer};
  while (options.length < 4) {
    options.add((allAnswers..shuffle()).first);
  }
  return options.toList()..shuffle();
}

  void _showAnswer(bool correct) {
  showDialog(
    context: context,
    builder: (_) => AlertDialog(
      title: Text(correct ? 'Correct!' : 'Incorrect!'),
      content: Text(correct ? 'You got it right!' : 'Oops! That was not right.'),
      actions: [
        TextButton(
          child: Text('OK'),
          onPressed: () {
            Navigator.of(context).pop(); // Close the dialog
          },
        ),
      ],
    ),
  );
}

  void _nextQuestion() {
  if (currentQuestionIndex < questions.length - 1) {
    setState(() {
      currentQuestionIndex++;
    });
  } else {
    // End of quiz
    Navigator.pop(context);
  }
}


  @override
  Widget build(BuildContext context) {
    // Chỉ xây dựng giao diện khi danh sách câu hỏi đã sẵn sàng và không rỗng
    if (questions.isEmpty) {
      return Scaffold(
        appBar: AppBar(title: Text("Quiz")),
        body: Center(child: Text("Không có đủ từ để tạo câu hỏi"))
      );
    }

    Word currentWord = questions[currentQuestionIndex];
    String questionText;
    List<String> options;

    switch (widget.answerType) {
      case 'Thuật ngữ':
        questionText = currentWord.mean2.title; // Definition is the question
        options = _generateOptions(currentWord.mean1.title, true);
        break;
      case 'Định nghĩa':
        questionText = currentWord.mean1.title; // Term is the question
        options = _generateOptions(currentWord.mean2.title, false);
        break;
      case 'Cả hai':
      default:
        questionText = rand.nextBool() ? currentWord.mean1.title : currentWord.mean2.title;
        options = _generateOptions(
          questionText == currentWord.mean1.title ? currentWord.mean2.title : currentWord.mean1.title,
          questionText == currentWord.mean1.title,
        );
        break;
    }

    return Scaffold(
      appBar: AppBar(title: Text("Quiz")),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(questionText, style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold)),
          Divider(),
          ...options.map((option) => ListTile(
            title: Text(option),
            onTap: () {
              bool correct = option == (questionText == currentWord.mean1.title ? currentWord.mean2.title : currentWord.mean1.title);
              if (widget.showAnswersImmediately) {
                _showAnswer(correct);
              }
              if (correct) _nextQuestion();
            },
          )).toList(),
        ],
      ),
    );
  }
}


