import 'package:flutter/material.dart';
import 'package:flip_card/flip_card.dart';
import 'package:flutter_tts/flutter_tts.dart';
import 'package:client_app/values/flashcard_data.dart';


class FlashcardPage extends StatefulWidget {  // Đã đổi tên class từ MyApp thành FlashcardPage
  const FlashcardPage({super.key, required String subjectName});

  @override
  State<FlashcardPage> createState() => _FlashcardPageState();
}

class _FlashcardPageState extends State<FlashcardPage> {
  final FlutterTts flutterTts = FlutterTts();
  final List<Map<String, String>> _data = FlashcardData.flashcards;
  int _currentIndex = 0;

  @override
  void initState() {
    super.initState();
    flutterTts.setLanguage("en-US");
  }

  void _speak(String text) async {
    if (text.isNotEmpty) {
      await flutterTts.speak(text);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Flashcard'),
        backgroundColor: Colors.deepPurple,
      ),
      body: Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            FlipCard(
              direction: FlipDirection.HORIZONTAL,
              front: buildCardFace(),
              back: buildCardBack(),
            ),
            SizedBox(height: 30), // Adds spacing between the card and the buttons
            navigationButtons(),
          ],
        ),
      ),
    );
  }

  Widget buildCardFace() {
  var currentCard = _data[_currentIndex];
  return Card(
    elevation: 12,
    shadowColor: Colors.deepPurpleAccent,
    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
    child: Container(
      width: 350,
      height: 250,
      padding: EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(15),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          Text(currentCard['word']!,
              textAlign: TextAlign.center, // Đảm bảo văn bản được căn giữa
              style: TextStyle(
                  fontSize: 28,
                  color: Colors.black,
                  fontWeight: FontWeight.bold)),
          SizedBox(height: 10),
          Text(currentCard['phonetic']!,
              textAlign: TextAlign.center, // Đảm bảo văn bản được căn giữa
              style: TextStyle(
                  fontSize: 20,
                  color: Colors.grey[700],
                  fontStyle: FontStyle.italic)),
          Spacer(),
          Align(
            alignment: Alignment.bottomRight,
            child: InkWell(
              onTap: () => _speak(currentCard['word']!),
              child: Icon(Icons.volume_up, size: 36, color: Colors.blue),
            ),
          ),
        ],
      ),
    ),
  );
}

Widget buildCardBack() {
  var currentCard = _data[_currentIndex];
  return Card(
    elevation: 12,
    shadowColor: Colors.deepPurpleAccent,
    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
    child: Container(
      width: 350,
      height: 250,
      padding: EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(15),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center, // Căn giữa nội dung trong Column
        children: <Widget>[
          Text(currentCard['translation']!,
              textAlign: TextAlign.center, // Đảm bảo văn bản được căn giữa trên card
              style: TextStyle(fontSize: 24, color: Colors.black)),
        ],
      ),
    ),
  );
}


  Widget navigationButtons() {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 20.0), // Thêm lề cho Row
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: <Widget>[
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.deepPurple, // Màu nền cho nút
              foregroundColor: Colors.white, // Màu chữ
              padding: EdgeInsets.symmetric(horizontal: 32, vertical: 12),
              shape: RoundedRectangleBorder(
                // Chỉnh hình dạng nút
                borderRadius: BorderRadius.circular(10), // Bán kính góc bo tròn
              ),
            ),
            onPressed: _currentIndex > 0
                ? () => setState(() => _currentIndex--)
                : null,
            child: Text('Previous'),
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.deepPurple, // Màu nền cho nút
              foregroundColor: Colors.white, // Màu chữ
              padding: EdgeInsets.symmetric(horizontal: 32, vertical: 12),
              shape: RoundedRectangleBorder(
                // Chỉnh hình dạng nút
                borderRadius: BorderRadius.circular(10), // Bán kính góc bo tròn
              ),
            ),
            onPressed: _currentIndex < _data.length - 1
                ? () => setState(() => _currentIndex++)
                : null,
            child: Text('Next'),
          ),
        ],
      ),
    );
  }
}