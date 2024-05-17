import 'package:client_app/modules/callFunction.dart';
import 'package:client_app/page/topic/TopicPage.dart';
import 'package:client_app/page/topic/TopicTabMode.dart';
import 'package:flutter/material.dart';

class AddTopicToFolder extends StatefulWidget {
  final String folderId;

  const AddTopicToFolder({super.key, required this.folderId});

  @override
  State<AddTopicToFolder> createState() => _AddTopicToFolderState();
}

class _AddTopicToFolderState extends State<AddTopicToFolder> {
  final callFunction = CallFunction();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Thêm Topics"),
        actions: [
          IconButton(
              onPressed: () {
                callFunction.refreshWidget();
                callFunction.AddTopicToFolder();
              },
              icon: Icon(Icons.check))
        ],
      ),
      body: TopicTab(
        callFunction: callFunction,
        mode: TopicTabMode(
          folderId: widget.folderId,
          accountTopic: true,
          multiSelect: true,
        ),
      ),
    );
  }
}
