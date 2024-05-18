import 'package:flutter/material.dart';

class QuizSettingsPage extends StatefulWidget {
  final bool initialFeedbackSetting;

  QuizSettingsPage({Key? key, required this.initialFeedbackSetting}) : super(key: key);

  @override
  _QuizSettingsPageState createState() => _QuizSettingsPageState();
}

class _QuizSettingsPageState extends State<QuizSettingsPage> {
  late bool showImmediateFeedback;

  @override
  void initState() {
    super.initState();
    showImmediateFeedback = widget.initialFeedbackSetting;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Tuỳ chọn Quiz'),
      ),
      body: ListView(
        children: <Widget>[
          ListTile(
            title: Text('Hiển thị phản hồi ngay'),
            trailing: Switch(
              value: showImmediateFeedback,
              onChanged: (bool value) {
                setState(() {
                  showImmediateFeedback = value;
                });
              },
            ),
          ),
          Padding(
            padding: EdgeInsets.all(16.0),
            child: ElevatedButton(
              onPressed: () {
                // Trả về giá trị mới cho QuizQuestionPage và quay lại
                Navigator.pop(context, showImmediateFeedback);
              },
              child: Text('Áp dụng và quay lại'),
              style: ElevatedButton.styleFrom(
                foregroundColor: Colors.white, backgroundColor: Theme.of(context).primaryColor,
                textStyle: TextStyle(fontSize: 18),
              ),
            ),
          ),
        ],
      ),
    );
  }
}




