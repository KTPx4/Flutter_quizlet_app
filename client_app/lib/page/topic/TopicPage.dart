import 'package:client_app/apiservices/AccountService.dart';
import 'package:client_app/apiservices/TopicService.dart';
import 'package:client_app/apiservices/folderSerivce.dart';
import 'package:client_app/models/account.dart';
import 'package:client_app/models/folder.dart';
import 'package:client_app/models/topic.dart';
import 'package:client_app/modules/callFunction.dart';
import 'package:client_app/page/topic/addtopic.dart';
import 'package:flutter/material.dart';

import 'TopicTabMode.dart';
import 'topicStudy.dart';

class TopicTab extends StatefulWidget {
  final CallFunction callFunction;
  final TopicTabMode mode;
  const TopicTab({super.key, required this.callFunction, required this.mode});

  @override
  State<TopicTab> createState() => _TopicTabState();
}

class _TopicTabState extends State<TopicTab> {
  String title = "topic";
  final AccountService accountService = AccountService();
  final TopicService topicService = TopicService();
  final FolderService folderService = FolderService();
  bool? isFolderSelected;
  List<AccountModel> accountList = [];
  List<String> selectedTopics = [];
  List<String> exitingTopics = [];

  Future<void> getAllAccount() async {
    accountList = await accountService.getAllAccounts();
  }

  @override
  void initState() {
    super.initState();
    isFolderSelected = !widget.mode.multiSelect;
    if (widget.mode.folderId != null && widget.mode.multiSelect) {
      selectCurrentFolder().then((value) {
        setState(() {
          isFolderSelected = true;
        });
      });
      widget.callFunction.AddTopicToFolder = addTopicToFolder;
    }
    widget.callFunction.refreshWidget = () {
      setState(() {});
    };

    getAllAccount();
  }

  void addTopicToFolder() async {
    await folderService.AddTopicsToFolder(
        exitingTopics, selectedTopics, widget.mode.folderId!);
    setState(() {});
    Navigator.pop(context);
  }

  Future<void> selectCurrentFolder() async {
    Folder folder = await folderService.getFolderById(widget.mode.folderId!);
    exitingTopics.addAll(folder.topics
        .where((topic) => topic.id != null)
        .map((topic) => topic.id!));
    selectedTopics.addAll(exitingTopics);
  }

  Widget buildPopupMenuButton(Topic topic) {
    return PopupMenuButton<int>(
      onSelected: (value) async {
        switch (value) {
          case 1: // Edit
            await Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => AddTopicPage(
                  topic: topic,
                ),
              ),
            );
            setState(() {});
            break;
          case 2: // Delete
            await topicService.deleteTopic(topic.id!);
            setState(() {});
            break;
          case 3: // Thêm Vào Thư Mục
            setState(() {
              if (selectedTopics.contains(topic.id)) {
                selectedTopics.remove(topic.id);
              } else {
                selectedTopics.add(topic.id!);
              }
            });
            break;
          default:
            break;
        }
      },
      itemBuilder: (BuildContext context) => <PopupMenuEntry<int>>[
        const PopupMenuItem<int>(
          value: 1,
          child: Row(
            children: [
              Icon(Icons.edit),
              Text('Edit'),
            ],
          ),
        ),
        const PopupMenuItem<int>(
          value: 2,
          child: Row(
            children: [
              Icon(Icons.delete),
              Text('Delete'),
            ],
          ),
        ),
        if (widget.mode.multiSelect)
          PopupMenuItem<int>(
            value: 3,
            child: Row(
              children: [
                Icon(Icons.folder),
                Text('Thêm Vào Thư Mục'),
              ],
            ),
          ),
      ],
    );
  }

  Future<List<Topic>> getTopics(TopicTabMode mode) async {
    if (mode.accountTopic) {
      return await topicService.getAccountTopics();
    }
    if (mode.publicTopic) {
      return await topicService.getPublicTopics();
    }
    if (mode.folderId != null) {
      return await topicService.getTopicsByFolderId(mode.folderId!);
    } else {
      return [];
    }
  }

  Widget _buildTopicsListView() {
    return FutureBuilder<List<Topic>>(
      future: getTopics(widget.mode),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting ||
            !isFolderSelected!) {
          return Center(
            child: CircularProgressIndicator(),
          );
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
            shrinkWrap: widget.mode.scrollable ? false : true,
            physics: widget.mode.scrollable
                ? AlwaysScrollableScrollPhysics()
                : NeverScrollableScrollPhysics(),
            itemCount: topics.length,
            itemBuilder: (context, index) {
              var topic = topics[index];
              var account = accountList
                  .firstWhere((element) => element.id == topic.authorID);
              return Container(
                margin: EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: (selectedTopics.contains(topic.id))
                      ? Colors.grey[200]
                      : Colors.white,
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
                          Flexible(
                            child: Text(topic.topicName),
                          ),
                          buildPopupMenuButton(
                            topic,
                          ),
                        ],
                      ),
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
                            backgroundImage: NetworkImage(
                                accountService.getAccountImageUrl(account)),
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

  @override
  Widget build(BuildContext context) {
    return _buildTopicsListView();
  }
}
