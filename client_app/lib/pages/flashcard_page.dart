import 'package:flutter/material.dart';
import 'package:flip_card/flip_card.dart';
import 'package:flutter_tts/flutter_tts.dart';
import 'package:client_app/values/flashcard_data.dart';


class FlashcardPage extends StatefulWidget {  
  const FlashcardPage({super.key, required String catName});

  @override
  State<FlashcardPage> createState() => _FlashcardPageState();
}

class _FlashcardPageState extends State<FlashcardPage> {
  final FlutterTts flutterTts = FlutterTts();
  final List<Map<String, String>> _data = FlashcardData.flashcards;
  int _currIdx = 0;

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
    ),
    body: Column(
      children: <Widget>[
        SizedBox(height: 10), 
        Padding(
          padding: EdgeInsets.symmetric(horizontal: 16.0),
          child: Column(
            children: [
              Text(
                "Card ${_currIdx + 1}/${_data.length}", 
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: Colors.deepPurple,
                ),
              ),
              SizedBox(height: 4),
              LinearProgressIndicator(
                value: (_currIdx + 1) / _data.length,
                backgroundColor: Colors.grey[300],
                valueColor: AlwaysStoppedAnimation<Color>(Colors.deepPurple),
              ),
            ],
          ),
        ),
        Expanded(
          child: Center(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: <Widget>[
                FlipCard(
                  direction: FlipDirection.HORIZONTAL,
                  front: FrontCard(),
                  back: BackCard(),
                ),
                SizedBox(height: 30),
                navigationButtons(),
              ],
            ),
          ),
        ),
      ],
    ),
  );
}





  Widget FrontCard() {
  var currCard = _data[_currIdx];
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
          Text(currCard['word']!,

              textAlign: TextAlign.center,

              style: TextStyle(
                  fontSize: 28,
                  color: Colors.black,
                  fontWeight: FontWeight.bold)),
          SizedBox(height: 10),
          Text(currCard['phonetic']!,

              textAlign: TextAlign.center,

              style: TextStyle(
                  fontSize: 20,
                  color: Colors.grey[700],
                  fontStyle: FontStyle.italic)),
          Spacer(),
          Align(
            alignment: Alignment.bottomRight,
            child: InkWell(
              onTap: () => _speak(currCard['word']!),
              child: Icon(Icons.volume_up, size: 36, color: Colors.blue),
            ),
          ),
        ],
      ),
    ),
  );
}

Widget BackCard() {
  var currCard = _data[_currIdx];
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
          Text(currCard['translation']!,
              textAlign: TextAlign.center,

              style: TextStyle(fontSize: 24, color: Colors.black)),
        ],
      ),
    ),
  );
}






  Widget navigationButtons() {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 20.0), 
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: <Widget>[
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.deepPurple, 
              foregroundColor: Colors.white,
              padding: EdgeInsets.symmetric(horizontal: 32, vertical: 12),
              shape: RoundedRectangleBorder(
                
                borderRadius: BorderRadius.circular(10), 
              ),
            ),
            onPressed: _currIdx > 0
                ? () => setState(() => _currIdx--)
                : null,
            child: Text('Previous'),
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(

              backgroundColor: Colors.deepPurple, 
              foregroundColor: Colors.white, 
              padding: EdgeInsets.symmetric(horizontal: 32, vertical: 12),
              shape: RoundedRectangleBorder(
                // Chỉnh hình dạng nút
                borderRadius: BorderRadius.circular(10),

              ),
            ),
            onPressed: _currIdx < _data.length - 1
                ? () => setState(() => _currIdx++)
                : null,
            child: Text('Next'),
          ),
        ],
      ),
    );
  }
}