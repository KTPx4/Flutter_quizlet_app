import 'package:flutter/material.dart';
import 'package:client_app/models/word.dart';
import 'package:client_app/pages/quiz_page.dart';

class QuizSettingsPage extends StatefulWidget {
  final List<Word> words;

  QuizSettingsPage({Key? key, required this.words}) : super(key: key);

  @override
  _QuizSettingsPageState createState() => _QuizSettingsPageState();
}

class _QuizSettingsPageState extends State<QuizSettingsPage> {
  bool showAnswersImmediately = false;
  String answerType = 'Thuật ngữ'; // Default answer type
  final TextEditingController _questionNumberController = TextEditingController(text: "10"); // Default to 10 questions

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Thiết lập bài kiểm tra"),
      ),
      body: ListView(
        children: <Widget>[
          ListTile(
            title: Text('Số câu hỏi'),
            subtitle: TextField(
              controller: _questionNumberController,
              keyboardType: TextInputType.number,
              decoration: InputDecoration(
                hintText: "Nhập số câu hỏi",
              ),
            ),
          ),
          SwitchListTile(
            title: Text("Hiển thị đáp án ngay"),
            value: showAnswersImmediately,
            onChanged: (bool value) {
              setState(() {
                showAnswersImmediately = value;
              });
            },
          ),
          ListTile(
            title: Text('Trả lời bằng'),
            trailing: DropdownButton<String>(
              value: answerType,
              onChanged: (newValue) {
                setState(() {
                  answerType = newValue ?? 'Thuật ngữ';
                });
              },
              items: <String>['Thuật ngữ', 'Định nghĩa', 'Cả hai'].map<DropdownMenuItem<String>>((String value) {
                return DropdownMenuItem<String>(
                  value: value,
                  child: Text(value),
                );
              }).toList(),
            ),
          ),
          ElevatedButton(
            onPressed: () {
              final int numberOfQuestions = int.tryParse(_questionNumberController.text) ?? 10; // Default if parsing fails
              if (numberOfQuestions > 0) {
                var args = {
                  "words": widget.words,
                  "numberOfQuestions": numberOfQuestions,
                  "showAnswersImmediately": showAnswersImmediately,
                  "answerType": answerType,
                };

                // Hide keyboard before navigation
                FocusScope.of(context).unfocus();

                Navigator.of(context).push(PageRouteBuilder(
                  pageBuilder: (context, animation, secondaryAnimation) => QuizPage(
                    words: widget.words,
                    numberOfQuestions: numberOfQuestions,
                    showAnswersImmediately: showAnswersImmediately,
                    answerType: answerType,
                  ),
                  transitionsBuilder: (context, animation, secondaryAnimation, child) {
                    return FadeTransition(opacity: animation, child: child);
                  },
                ));
              } else {
                // Optionally show an error message
                ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                  content: Text("Please enter a valid number of questions"),
                ));
              }
            },
            child: Text('Bắt đầu làm bài'),
          ),
        ],
      ),
    );
  }

  @override
  void dispose() {
    _questionNumberController.dispose();
    super.dispose();
  }
}