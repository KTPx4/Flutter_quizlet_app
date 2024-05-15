import 'package:client_app/apiservices/TopicService.dart';
import 'package:client_app/models/AccountService.dart';
import 'package:client_app/models/topic.dart';
import 'package:client_app/modules/callFunction.dart';
import 'package:client_app/page/topic/addtopic.dart';
import 'package:flutter/material.dart';

import 'topicStudy.dart';

class TopicPage extends StatefulWidget {
  final CallFunction callFunction;
  const TopicPage({super.key, required this.callFunction});

  @override
  State<TopicPage> createState() => _TopicPageState();
}

class _TopicPageState extends State<TopicPage> {
  List<Topic> topicList = [];
  String title = "topic";
  final AccountService accountService = AccountService();
  final TopicService topicService = TopicService();
  @override
  void initState() {
    super.initState();
    widget.callFunction.refreshWidget = () {
      setState(() {});
    };
  }

  Widget _buildTopicsListView() {
    return FutureBuilder<List<Topic>>(
      future: topicService.getAccountTopics(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return CircularProgressIndicator();
        } else if (snapshot.hasError) {
          return Text('Error: ${snapshot.error}');
        } else {
          var topics = snapshot.data;
          if (topics == null || topics.isEmpty) {
            return Center(
              child: Text('No topic found'),
            );
          }
          return ListView.builder(
            itemCount: topics.length,
            itemBuilder: (context, index) {
              var topic = topics[index];

              return Container(
                margin: EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(8),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.grey.withOpacity(0.5),
                      spreadRadius: 1,
                      blurRadius: 1,
                      offset: Offset(0, 1),
                    ),
                  ],
                ),
                child: ListTile(
                  title: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(topic.topicName),
                            IconButton(
                                onPressed: () {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) => AddTopicPage(
                                        topic: topic,
                                      ),
                                    ),
                                  );
                                },
                                icon: Icon(Icons.edit))
                          ]),
                      SizedBox(
                        height: 10,
                      ), // First row: Topic name
                      Text('Term: ${topic.words.length}'),
                      SizedBox(
                        height: 21,
                      ), // Second row: Term + number of questions
                      Row(
                        // Third row: Account avatar and account name
                        children: [
                          // CircleAvatar(
                          //   backgroundImage: NetworkImage(account.nameAvt),
                          //   radius: 16,
                          // ),
                          SizedBox(width: 8),
                          Text('Default Account'),
                        ],
                      ),
                    ],
                  ),
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => TopicStudy(topic: topic),
                      ),
                    );
                  },
                ),
              );
            },
          );
        }
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return _buildTopicsListView();
  }
}
