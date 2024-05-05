import 'package:flutter/material.dart';

class VocabPage extends StatelessWidget {
  final String subjectName;

  // This constructor cannot be const because it is initialized at runtime
  VocabPage({Key? key, required this.subjectName}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return const Placeholder();
  }
}