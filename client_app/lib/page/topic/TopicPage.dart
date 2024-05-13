
import 'package:client_app/models/AccountService.dart';
import 'package:client_app/modules/callFunction.dart';
import 'package:client_app/page/topic/questionPage.dart';
import 'package:client_app/values/topic.dart';
import 'package:flutter/material.dart';

class TopicPage extends StatefulWidget {
  final CallFunction callFunction;
  const TopicPage({super.key, required this.callFunction});


  @override
  State<TopicPage> createState() => _TopicPageState();
}

class _TopicPageState extends State<TopicPage> {

  String title = "topic";

  @override
  void initState() {
    super.initState();
    widget.callFunction.refreshWidget = () {
      setState(() {});
    };
  }

  final AccountService accountService = AccountService();

  Widget _buildTopicsListView() {
    return ListView.builder(
      itemBuilder: (context, index) {
        var topic = topicList[index];
        var account = accountService.getAccountById(topic.accountID);
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
            onLongPress: () {
              setState(() {
                MaterialPageRoute(
                  builder: (context) => QuestionPage(),
                );
              });
            },
            title: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(topic.topicName),
                SizedBox(
                  height: 10,
                ), // First row: Topic name
                Text('Term: ${topic.questions.length}'),
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
                    Text(account.fullName),
                  ],
                ),
              ],
            ),
            onTap: () {
              setState(() {});
            },
          ),
        );
      },
      itemCount: topicList.length,
    );
  }

  @override
  Widget build(BuildContext context) {
    return _buildTopicsListView();
  }
}

