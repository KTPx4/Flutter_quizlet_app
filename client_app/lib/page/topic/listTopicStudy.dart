import 'package:client_app/apiservices/AccountService.dart';
import 'package:client_app/apiservices/TopicService.dart';
import 'package:client_app/apiservices/folderSerivce.dart';
import 'package:client_app/models/account.dart';
import 'package:client_app/models/word.dart';
import 'package:client_app/modules/callFunction.dart';
import 'package:flutter/material.dart';

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
  Future<void> getAllAccount() async {
    accountList = await accountService.getAllAccounts();
  }

  @override
  void initState() {
    getAllAccount();
    super.initState();
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
              return Card(
                child: ListTile(
                  title: Text(
                    word.mean1.title,
                    style:
                        TextStyle(fontSize: 20), // Increase the font size here
                  ),
                  subtitle: Text(
                    word.mean2.title,
                    style:
                        TextStyle(fontSize: 18), // Increase the font size here
                  ),
                  leading: IconButton(
                    icon: Icon(
                      word.isMark!
                          ? Icons.star
                          : Icons.star_border, // Use ternary operator here
                    ),
                    onPressed: () async {
                      await topicService.updateWordMark(
                          widget.topicId, word.id!, !word.isMark!);
                      setState(() {});
                    },
                    color: Colors.yellow,
                  ),
                  trailing: Icon(Icons.volume_up),
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
