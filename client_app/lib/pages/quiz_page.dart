import 'package:flutter/material.dart';

class QuizPage extends StatelessWidget {
  final String subjectName;

  // This constructor cannot be const because it is initialized at runtime
  QuizPage({Key? key, required this.subjectName}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Hello'),),
    );
  }
}