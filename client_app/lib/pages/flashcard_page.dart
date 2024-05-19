import 'package:client_app/apiservices/topicAPI.dart';
import 'package:flutter/material.dart';
import 'package:flip_card/flip_card.dart';
import 'package:flutter_tts/flutter_tts.dart';
import 'package:client_app/models/word.dart';  
import 'package:client_app/pages/flashcard_settings.dart';

class FlashcardPage extends StatefulWidget {
  final List<Word> words;
  String idTopic;
  FlashcardPage({Key? key, required this.words, required this.idTopic}) : super(key: key);

  @override
  State<FlashcardPage> createState() => _FlashcardPageState();
}

class _FlashcardPageState extends State<FlashcardPage> {
  final FlutterTts flutterTts = FlutterTts();
  int _currIdx = 0;
  bool autoPronounce = false;

  @override
  void initState() {
    super.initState();
    flutterTts.setLanguage("en-US");
  }

  @override
  void dispose() {
    flutterTts.stop();
    super.dispose();
  }

  void _speak(String text) async {
    if (autoPronounce && text.isNotEmpty) {
      await flutterTts.speak(text);
    }
  }

  void _nextCard() {
    if (_currIdx < widget.words.length - 1) {
      setState(() {
        _currIdx++;
        _speak(widget.words[_currIdx].mean1.title);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Flashcards"),
        actions: <Widget>[
          IconButton(
            icon: Icon(Icons.settings),
            onPressed: () async {
              final result = await Navigator.of(context).push(
                MaterialPageRoute(
                  builder: (context) => FlashcardSettingsPage(),
                ),
              ) as Map<String, bool>?;
              if (result != null) {
                setState(() {
                  autoPronounce = result['autoPronounce'] ?? false;
                  _speak(widget.words[_currIdx].mean1.title);
                });
              }
            },
          ),
        ],
      ),
      body: widget.words.isNotEmpty ? Column(
        children: <Widget>[
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: LinearProgressIndicator(
              value: (_currIdx + 1) / widget.words.length,
              backgroundColor: Colors.grey[300],
              valueColor: AlwaysStoppedAnimation<Color>(Colors.deepPurple),
            ),

          ),
          Expanded(
            child: FlipCard(
              direction: FlipDirection.HORIZONTAL,
              flipOnTouch: true,
              front: _cardContent(widget.words[_currIdx], true),
              back: _cardContent(widget.words[_currIdx], false),
            ),
          ),
          navigationButtons(),
        ],
      ) : Center(child: Text("No flashcards available")),
    );
  }

  Widget _cardContent(Word word, bool front) {
    return Card(
      elevation: 12,
      shadowColor: Colors.deepPurpleAccent,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
      child: Container(
        width: 350,
        height: 250,
        alignment: Alignment.center,
        child: Stack(
          children: [
            Align(
              alignment: Alignment.center,
              child: Text(
                front ? word.mean1.title : word.mean2.title,
                style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold),
                textAlign: TextAlign.center,
              ),
            ),
            if (front) Align(
              alignment: Alignment.bottomRight,
              child: IconButton(
                icon: Icon(Icons.volume_up, size: 24, color: Colors.blue),
                onPressed: () => _speak(word.mean1.title),
              ),
            )
          ],
        ),
      ),
    );
  }

  Widget navigationButtons() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: <Widget>[
        IconButton(
          icon: Icon(Icons.arrow_back, size: 36, color: Colors.deepPurple),
          onPressed: _currIdx > 0 ? () async{            
            setState(() {
              _currIdx--;
              _speak(widget.words[_currIdx].mean1.title);
            });            
          } : null,
        ),
        IconButton(
          icon: Icon(Icons.arrow_forward, size: 36, color: Colors.deepPurple),
          onPressed: _nextCard,
        ),
      ],
    );
  }
}
