import 'package:flutter/material.dart';

class TypingSettingsPage extends StatefulWidget {
  final bool initialFeedbackSetting;

  TypingSettingsPage({Key? key, required this.initialFeedbackSetting}) : super(key: key);

  @override
  _TypingSettingsPageState createState() => _TypingSettingsPageState();
}

class _TypingSettingsPageState extends State<TypingSettingsPage> {
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
        title: Text("Tuỳ Chọn Typing"),
      ),
      body: ListView(
        children: <Widget>[
          SwitchListTile(
            title: Text('Hiển thị phản hồi ngay'),
            value: showImmediateFeedback,
            onChanged: (bool value) {
              setState(() {
                showImmediateFeedback = value;
              });
            },
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.pop(context, showImmediateFeedback);
            },
            child: Text('Áp dụng và quay lại'),
          ),
        ],
      ),
    );
  }
}

