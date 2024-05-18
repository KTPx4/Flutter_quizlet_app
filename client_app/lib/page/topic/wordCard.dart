import 'package:client_app/models/word.dart';
import 'package:flutter/material.dart';

class QuestionCard extends StatefulWidget {
  final Word word;
  final Function onDelete;
  final formKey;
  QuestionCard({
    required this.word,
    required this.onDelete,
    required this.formKey,
  });

  @override
  _QuestionCardState createState() => _QuestionCardState();
}

class _QuestionCardState extends State<QuestionCard> {
  @override
  Widget build(BuildContext context) {
    return Card(
      margin: EdgeInsets.only(bottom: 16),
      child: Stack(children: [
        Padding(
          padding: EdgeInsets.all(16),
          child: Form(
            key: widget.formKey,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                TextFormField(
                  autovalidateMode: AutovalidateMode.onUserInteraction,
                  initialValue: widget.word.mean1.title,
                  decoration: InputDecoration(
                    labelText: "từ",
                    hintText: "Nhập từ vào đây",
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'cần phải nhập từ';
                    }
                    return null;
                  },
                  onSaved: (value) {
                    widget.word.mean1.title = value ?? "";
                  },
                ),
                SizedBox(height: 10),
                TextFormField(
                  autovalidateMode: AutovalidateMode.onUserInteraction,
                  initialValue: widget.word.mean2.title,
                  decoration: InputDecoration(
                    labelText: "nghĩa",
                    hintText: "Nhập nghĩa vào đây",
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'cần phải nhập nghĩa';
                    }
                    return null;
                  },
                  onSaved: (value) {
                    widget.word.mean2.title = value ?? "";
                  },
                ),
                SizedBox(height: 10),
              ],
            ),
          ),
        ),
        Positioned(
          right: 0,
          child: IconButton(
            icon: Icon(Icons.close),
            onPressed: () {
              widget.onDelete();
            },
          ),
        ),
      ]),
    );
  }
}
