import 'package:client_app/models/topic.dart';
import 'package:flutter/material.dart';

class TopicStudy extends StatelessWidget {
  final Topic topic;

  TopicStudy({required this.topic});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Topic Study'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Text(
              'Topic Name: ${topic.topicName}',
              style: TextStyle(fontSize: 20),
            ),
            SizedBox(height: 10),
            Text(
              'Number of Terms: ${topic.words.length}',
              style: TextStyle(fontSize: 16),
            ),
            // Add more fields as needed
          ],
        ),
      ),
    );
  }
}
