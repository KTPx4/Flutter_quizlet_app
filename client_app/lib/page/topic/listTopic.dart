import 'package:client_app/apiservices/TopicService.dart';
import 'package:client_app/models/account.dart';
import 'package:client_app/models/topic.dart';
import 'package:client_app/page/topic/topicStudy.dart';
import 'package:flutter/material.dart';

import 'addtopic.dart';

class TopicsListView extends StatefulWidget {
  final TopicService topicService;
  final List<AccountModel> accountList;

  TopicsListView({required this.topicService, required this.accountList});

  @override
  State<TopicsListView> createState() => _TopicsListViewState();
}

class _TopicsListViewState extends State<TopicsListView> {
  Widget buildPopupMenuButton(Topic topic) {
    return PopupMenuButton<String>(
      onSelected: (value) async {
        if (value == 'Edit') {
          await Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => AddTopicPage(
                topic: topic,
              ),
            ),
          );
          setState(() {});
        } else if (value == 'Delete') {
          await widget.topicService.deleteTopic(topic.id!);
          setState(() {});
        }
      },
      itemBuilder: (BuildContext context) => <PopupMenuEntry<String>>[
        const PopupMenuItem<String>(
          value: 'Edit',
          child: Row(
            children: [
              Icon(Icons.edit),
              Text('Edit'),
            ],
          ),
        ),
        const PopupMenuItem<String>(
          value: 'Delete',
          child: Row(
            children: [
              Icon(Icons.delete),
              Text('Delete'),
            ],
          ),
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<List<Topic>>(
      future: widget.topicService.getAccountTopics(),
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
              var account = widget.accountList
                  .firstWhere((element) => element.id == topic.authorID);
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
                            buildPopupMenuButton(
                              topic,
                            ),
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
                          CircleAvatar(
                            backgroundImage: NetworkImage(account.nameAvt),
                            radius: 16,
                          ),
                          SizedBox(width: 8),
                          Text(account.user),
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
}
