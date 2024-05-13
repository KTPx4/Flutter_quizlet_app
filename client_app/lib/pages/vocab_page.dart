
import 'package:client_app/pages/typing_page.dart';
import 'package:flutter/material.dart';


class VocabPage extends StatelessWidget {
  final String catName; 

  VocabPage({Key? key, required this.catName}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Typing Practice"),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            ElevatedButton(
              child: Text('English to Vietnamese'),
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => TypingPractice(isVietToEng: false)),
                );
              },
            ),
            SizedBox(height: 20),
            ElevatedButton(
              child: Text('Vietnamese to English'),
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => TypingPractice(isVietToEng: true)),
                );
              },
            ),
          ],
        ),
      ),
    );

  }
}
