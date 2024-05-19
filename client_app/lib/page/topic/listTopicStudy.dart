import 'package:client_app/apiservices/AccountService.dart';
import 'package:client_app/apiservices/TopicService.dart';
import 'package:client_app/apiservices/folderSerivce.dart';
import 'package:client_app/models/account.dart';
import 'package:client_app/models/word.dart';
import 'package:client_app/modules/callFunction.dart';
import 'package:flutter/material.dart';
import 'package:flutter_tts/flutter_tts.dart';

class ListTopicStudy extends StatefulWidget {
  final String topicId;
  final CallFunction callFunction;
  final bool markWords;
  ListTopicStudy(
      {super.key,
      required this.topicId,
      required this.callFunction,
      required this.markWords});

  @override
  State<ListTopicStudy> createState() => _ListTopicStudyState();
}

class _ListTopicStudyState extends State<ListTopicStudy> {
  final AccountService accountService = AccountService();
  final TopicService topicService = TopicService();
  final FolderService folderService = FolderService();
  late AccountModel currentAccount;
  bool? isFolderSelected;
  final ScrollController _scrollController = ScrollController();
  List<AccountModel> accountList = [];
  List<String> markTopics = [];
  final flutterTts = FlutterTts();
  bool isSpeaking = false;
  Future<void> getAllAccount() async {
    accountList = await accountService.getAllAccounts();
  }

  @override
  void initState() {
    super.initState();
    flutterTts.setVolume(1.0);
    getAllAccount();
  }

  Future<List<Word>> WordInTopic(topicId) async {
    if (widget.markWords) {
      return await topicService.getMarkedWordsInTopic(topicId);
    } else {
      return await topicService.getWordsInTopic(topicId);
    }
  }

  Widget _buildWordsListView() {
    return FutureBuilder(
      future: WordInTopic(widget.topicId),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return Center(
            child: CircularProgressIndicator(),
          );
        } else if (snapshot.hasError) {
          return Text('Error: ${snapshot.error}');
        } else {
          var words = snapshot.data;
          if (words == null || words.isEmpty) {
            return Center(
              child: Text('No words found!'),
            );
          }

          return ListView.builder(
            shrinkWrap: true,
            controller: _scrollController,
            itemCount: words.length,
            itemBuilder: (context, index) {
              var word = words[index];
              String studyStatus;
              Color chipColor;
              if (word.studyCount == 0) {
                studyStatus = 'chưa học';
                chipColor = Colors.red;
              } else if (word.studyCount! > 0 && word.studyCount! <= 3) {
                studyStatus = 'đang học';
                chipColor = Colors.yellow;
              } else {
                studyStatus = 'thành thạo';
                chipColor = Colors.green;
              }
              return Card(
                child: ListTile(
                  title: GestureDetector(
                    child: Text(
                      word.mean1.title,
                      style: TextStyle(fontSize: 20),
                    ),
                    onTap: () async {
                      isSpeaking = true;
                      await flutterTts.speak(word.mean1.title);
                      isSpeaking = false;
                    },
                  ),
                  subtitle: GestureDetector(
                    child: Text(
                      word.mean2.title,
                      style: TextStyle(fontSize: 18),
                    ),
                    onTap: () async {
                      isSpeaking = true;
                      await flutterTts.speak(word.mean2.title);
                      isSpeaking = false;
                    },
                  ),
                  leading: IconButton(
                    icon: Icon(
                      word.isMark! ? Icons.star : Icons.star_border,
                    ),
                    onPressed: () async {
                      await topicService.updateWordMark(
                          widget.topicId, word.id!, !word.isMark!);
                      setState(() {});
                    },
                    color: Colors.yellow,
                  ),
                  trailing: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(
                        isSpeaking ? Icons.volume_up : Icons.volume_up_outlined,
                      ),
                      SizedBox(width: 8),
                      Chip(
                        backgroundColor: chipColor,
                        label: Text(
                          studyStatus,
                          style: TextStyle(color: Colors.black),
                        ),
                      )
                    ],
                  ),
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
    return _buildWordsListView();
  }
}
