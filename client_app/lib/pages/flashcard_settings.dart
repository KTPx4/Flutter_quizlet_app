import 'package:flutter/material.dart';

class FlashcardSettingsPage extends StatefulWidget {
  @override
  _FlashcardSettingsPageState createState() => _FlashcardSettingsPageState();
}

class _FlashcardSettingsPageState extends State<FlashcardSettingsPage> {
  bool autoPronounce = false;

  void _popSettings() {
    Navigator.pop(context, {'autoPronounce': autoPronounce});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Tùy chọn Flashcard"),
        leading: IconButton(
          icon: Icon(Icons.arrow_back),
          onPressed: _popSettings,
        ),
      ),
      body: ListView(
        children: <Widget>[
          SwitchListTile(
            title: Text("Âm thanh"),
            subtitle: Text("Tự động phát âm khi xem thẻ"),
            value: autoPronounce,
            onChanged: (bool value) {
              setState(() {
                autoPronounce = value;
              });
            },
          ),
          // Remove any other settings not required
        ],
      ),
    );
  }
}
