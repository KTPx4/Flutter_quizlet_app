import 'package:flutter/material.dart';
import 'package:client_app/pages/result_page.dart';
import 'package:client_app/values/quiz_data.dart';

class QuizPage extends StatefulWidget {
  final String catName;

  QuizPage({Key? key, required this.catName}) : super(key: key);

  @override
  _QuizPageState createState() => _QuizPageState();
}

class _QuizPageState extends State<QuizPage> {
  int _currQuestIdx = 0;
  int _score = 0;
  String? _isSelected;
  List<String> userAnswers = []; 

  void _nextQuestion() {
    if (_isSelected != null) {
      userAnswers.add(_isSelected!); 
      if (_isSelected == questionsData[_currQuestIdx].answer) {
        _score++;
      }
    }

    if (_currQuestIdx < questionsData.length - 1) {
      setState(() {
        _currQuestIdx++;
        _isSelected = null; 
      });
    } else {
      
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (context) => ResultsPage(
            score: _score,
            totalQuestions: questionsData.length,
            userAnswers: userAnswers,
          ),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final question = questionsData[_currQuestIdx];
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.catName),
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: <Widget>[
          Padding(
            padding: EdgeInsets.symmetric(vertical: 8),
            child: Column(
              children: [
                Text(
                  'Question ${_currQuestIdx + 1}/${questionsData.length}',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
                LinearProgressIndicator(
                  value: (_currQuestIdx + 1) / questionsData.length,
                  backgroundColor: Colors.grey[300],
                  valueColor: AlwaysStoppedAnimation<Color>(Colors.blue),
                ),
              ],
            ),
          ),
          Padding(
            padding: EdgeInsets.all(20),
            child: Text(
              question.question,
              style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
            ),
          ),
          Expanded(
            child: ListView(
              children: question.options
                  .map((option) => RadioListTile<String>(
                        title: Text(option),
                        value: option,
                        groupValue: _isSelected,
                        onChanged: (value) {
                          setState(() {
                            _isSelected = value;
                          });
                        },
                      ))
                  .toList(),
            ),
          ),
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 150, vertical: 30),
            child: ElevatedButton(
              onPressed: _isSelected == null ? null : _nextQuestion,
              child: Text('Next'),
              style: ElevatedButton.styleFrom(
                padding: EdgeInsets.symmetric(horizontal: 10, vertical: 8),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
