import 'dart:convert';
import 'dart:io';

import 'package:client_app/apiservices/AccountService.dart';
import 'package:client_app/apiservices/TopicService.dart';
import 'package:client_app/apiservices/folderSerivce.dart';
import 'package:client_app/models/account.dart';
import 'package:client_app/models/folder.dart';
import 'package:client_app/models/topic.dart';
import 'package:client_app/models/word.dart';
import 'package:client_app/modules/callFunction.dart';
import 'package:client_app/page/topic/addtopic.dart';
import 'package:csv/csv.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:shared_preferences/shared_preferences.dart';

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
  final AccountService accountService = AccountService();
  final TopicService topicService = TopicService();
  final FolderService folderService = FolderService();
  late AccountModel currentAccount;
  bool? isFolderSelected;
  List<AccountModel> accountList = [];
  List<String> selectedTopics = [];
  List<String> exitingTopics = [];

  Future<void> getAllAccount() async {
    accountList = await accountService.getAllAccounts();
  }

  Future<void> getCurrentAccount() async {
    var pref = await SharedPreferences.getInstance();
    String? accountJson = pref.getString("Account");

    if (accountJson != null) {
      Map<String, dynamic> accountMap = jsonDecode(accountJson);
      currentAccount = AccountModel.fromJson(accountMap);
    }
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

  String convertWordsToCsv(List<Word> words) {
    List<List<dynamic>> rows = [];

    // Add headers
    rows.add(['từ', 'nghĩa']);

    // Add data
    for (Word word in words) {
      rows.add([word.mean1.title, word.mean2.title]);
    }

    return const ListToCsvConverter().convert(rows);
  }

  Future<File> writeStringToCsvFile(String csvString, String fileName) async {
    // Let the user pick a directory
    var status = await Permission.storage.request();

    String? directoryPath = await FilePicker.platform.getDirectoryPath();

    if (directoryPath != null) {
      final file = File('$directoryPath/$fileName.csv');

      return file.writeAsString(csvString);
    } else {
      return File('');
    }
  }

  @override
  void initState() {
    getCurrentAccount();
    getAllAccount();
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

    super.initState();
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
          case 3: // Remove from folder
            if (widget.mode.folderId != null) {
              await folderService.removeTopicFromFolder(
                  widget.mode.folderId!, topic.id!);
              setState(() {});
            }
            break;
          case 4:
            var status = await Permission.storage.status;
            if (!status.isGranted) {
              // Request storage permission
              status = await Permission.storage.request();
              print(status);
            }

            if (true) {
              // If permission is granted, proceed with exporting words to CSV
              String csvString = convertWordsToCsv(topic.words);
              var file = await writeStringToCsvFile(csvString, topic.topicName);
              if (file.path.isEmpty) {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text('Failed to export words to CSV')),
                );
                return;
              }
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(content: Text('Words exported to CSV successfully')),
              );
            } else {
              // If permission is not granted, show a message
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(content: Text('Storage permission is not granted')),
              );
            }
            break;
          default:
            break;
        }
      },
      itemBuilder: (BuildContext context) => <PopupMenuEntry<int>>[
        if (topic.authorID == currentAccount.id) ...[
          PopupMenuItem<int>(
            value: 1,
            child: Row(
              children: [
                Icon(Icons.edit),
                Text('Sửa'),
              ],
            ),
          ),
          PopupMenuItem<int>(
            value: 2,
            child: Row(
              children: [
                Icon(Icons.delete),
                Text('Xóa'),
              ],
            ),
          ),
        ],
        if (widget.mode.folderId != null)
          PopupMenuItem<int>(
            value: 3,
            child: Row(
              children: [
                Icon(Icons.remove),
                Text('xóa khỏi thư mục'),
              ],
            ),
          ),
        PopupMenuItem<int>(
          value: 4,
          child: Row(
            children: [
              Icon(Icons.file_upload),
              Text('xuất ra CSV'),
            ],
          ),
        )
      ],
    );
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
          return Text('Lỗi: ${snapshot.error}');
        } else {
          var topics = snapshot.data;
          if (topics == null || topics.isEmpty) {
            return Center(
              child: Text('Không có chủ đề nào được tìm thấy!'),
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
                      Text('Từ: ${topic.words.length}'),
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
                  onTap: (widget.mode.multiSelect)
                      ? () {
                          setState(() {
                            if (selectedTopics.contains(topic.id)) {
                              selectedTopics.remove(topic.id);
                            } else {
                              selectedTopics.add(topic.id!);
                            }
                          });
                        }
                      : () {
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
