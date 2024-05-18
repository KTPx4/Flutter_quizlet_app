import 'package:client_app/models/topic.dart';
import 'package:client_app/modules/callFunction.dart';
import 'package:client_app/page/topic/listTopicStudy.dart';
import 'package:client_app/pages/flashcard_page.dart';
import 'package:client_app/pages/quiz_page.dart';
import 'package:client_app/pages/typing_page.dart';
import 'package:flip_card/flip_card.dart';
import 'package:flutter/material.dart';

class TopicStudy extends StatefulWidget {
  final Topic topic;

  TopicStudy({required this.topic});

  @override
  State<TopicStudy> createState() => _TopicStudyState();
}

class _TopicStudyState extends State<TopicStudy>
    with SingleTickerProviderStateMixin {
  final CallFunction callFunction = CallFunction();
  int currentTab = 0;
  late final _tabController = TabController(length: 2, vsync: this);
  late var childLib;

  @override
  void initState() {
    super.initState();
  }

  List<Widget> buildListTiles() {
    return [
      Card(
        child: ListTile(
          title: Text('Flashcards'),
          leading: Icon(Icons.view_carousel),
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => FlashcardPage(words: widget.topic.words),
              ),
            );
          },
        ),
      ),
      Card(
        child: ListTile(
          title: Text('Learn'),
          leading: Icon(Icons.school),
          onTap: () {},
        ),
      ),
      Card(
        child: ListTile(
          title: Text('Quiz'),
          leading: Icon(Icons.question_answer),
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => QuizPage(
                  topic: widget.topic,
                  words: [],
                ),
              ),
            );
          },
        ),
      ),
      Card(
        child: ListTile(
          title: Text('Typing'),
          leading: Icon(Icons.compare_arrows),
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => TypingPage(words: widget.topic.words),
              ),
            );
          },
        ),
      ),
    ];
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(''), // Removed the topic name from here
        actions: [
          IconButton(
            icon: Icon(Icons.settings),
            onPressed: () {
              // Handle settings action
            },
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Container(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              // Flip card section
              if (widget.topic.words.isNotEmpty)
                SizedBox(
                  height: 200, // Adjust size accordingly
                  child: ListView.builder(
                    scrollDirection: Axis.horizontal,
                    itemCount: widget.topic.words.length,
                    itemBuilder: (context, index) {
                      return FlipCard(
                        front: Card(
                          child: Container(
                            width: 250,
                            alignment: Alignment.center,
                            child: Text(
                              '${widget.topic.words[index].mean1.title}',
                              style: TextStyle(fontSize: 18),
                            ),
                          ),
                        ),
                        back: Card(
                          child: Container(
                            width: 250,
                            alignment: Alignment.center,
                            child: Text(
                              '${widget.topic.words[index].mean2.title}',
                              style: TextStyle(fontSize: 18),
                            ),
                          ),
                        ),
                      );
                    },
                  ),
                ),
              SizedBox(height: 20),
              Padding(
                padding: const EdgeInsets.only(left: 20.0),
                child: Text(
                  widget.topic.topicName,
                  style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(left: 20.0),
                child: Text(
                  'Terms: ${widget.topic.words.length}',
                  style: TextStyle(fontSize: 16, color: Colors.grey[600]),
                ),
              ),
              SizedBox(height: 20),
              ...buildListTiles(),

              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Row(
                  children: [
                    Expanded(
                      child: Container(
                        decoration: BoxDecoration(
                          color: currentTab == 0 ? Colors.blue : Colors.grey,
                          border: Border.all(
                            color: Colors.black, // Set border color
                            width: 1, // Set border width
                          ),
                        ),
                        child: ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.transparent,
                            shadowColor: Colors.transparent,
                          ),
                          child: Text('Từ Trong Thư Mục'),
                          onPressed: () {
                            setState(() {
                              currentTab = 0;
                            });
                          },
                        ),
                      ),
                    ),
                    Expanded(
                      child: Container(
                        decoration: BoxDecoration(
                          color: currentTab == 1 ? Colors.blue : Colors.grey,
                          border: Border.all(
                            color: Colors.black, // Set border color
                            width: 1, // Set border width
                          ),
                        ),
                        child: ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.transparent,
                            shadowColor: Colors.transparent,
                          ),
                          child: Text('Từ Đánh Dấu'),
                          onPressed: () {
                            setState(() {
                              currentTab = 1;
                            });
                          },
                        ),
                      ),
                    ),
                    // Add more buttons here for additional tabs
                  ],
                ),
              ),
              currentTab == 0
                  ? ListTopicStudy(
                      markWords: false,
                      callFunction: callFunction,
                      topicId: widget.topic.id!,
                    )
                  : ListTopicStudy(
                      markWords: true,
                      callFunction: callFunction,
                      topicId: widget.topic.id!,
                    ),
            ],
          ),
        ),
      ),
    );
  }
}
