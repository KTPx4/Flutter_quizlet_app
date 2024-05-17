import 'package:client_app/apiservices/AccountService.dart';
import 'package:client_app/apiservices/folderSerivce.dart';
import 'package:client_app/models/account.dart';
import 'package:client_app/models/folder.dart';
import 'package:client_app/modules/callFunction.dart';
import 'package:client_app/page/topic/TopicPage.dart';
import 'package:client_app/page/topic/TopicTabMode.dart';
import 'package:flutter/material.dart';

import 'AddTopicToFolderPage.dart';

class FolderTopicPage extends StatefulWidget {
  final Folder folder;
  final AccountModel account;
  final Function refreshParent;
  const FolderTopicPage(
      {super.key,
      required this.folder,
      required this.account,
      required this.refreshParent});

  @override
  State<FolderTopicPage> createState() => _FolderTopicPageState();
}

class _FolderTopicPageState extends State<FolderTopicPage> {
  final callFunction = CallFunction();
  final AccountService accountService = AccountService();
  final FolderService folderService = FolderService();

  // void getFolder() async {
  //   folder = await folderService.getFolderById(widget.folder);
  // }

  @override
  void initState() {
    // TODO: implement initState
    // getFolder();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text("Thư Mục"),
          actions: [
            IconButton(
                onPressed: () async {
                  await Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) =>
                          AddTopicToFolder(folderId: widget.folder.id!),
                    ),
                  );
                  widget.refreshParent();
                  setState(() {});
                },
                icon: Icon(Icons.add))
          ],
        ),
        body: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                padding: EdgeInsets.all(16),
                child: Column(
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        Text(
                          "${widget.folder.topics.length} Topics",
                          style: TextStyle(
                            fontSize: 18,
                            fontFamily: "Arial",
                            color: Colors.grey,
                          ),
                        ),
                        SizedBox(width: 10),
                        CircleAvatar(
                          radius: 20,
                          backgroundImage: Image.network(
                            accountService.getAccountImageUrl(widget.account),
                            errorBuilder: (BuildContext context,
                                Object exception, StackTrace? stackTrace) {
                              return const Text('Your error widget...');
                            },
                          ).image,
                        ),
                        Text(
                          " ${widget.account.user}",
                          style: TextStyle(
                            fontSize: 18,
                            fontFamily: "Arial",
                            color: Colors.black87,
                          ),
                        ),
                      ],
                    ),
                    Text(
                      " Folder Name : ${widget.folder.folderName}",
                      style: TextStyle(
                        fontSize: 20,
                        fontFamily: "Roboto",
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
              ),
              TopicTab(
                callFunction: callFunction,
                mode: TopicTabMode(
                  scrollable: false,
                  folderId: widget.folder.id,
                ),
              ),
            ],
          ),
        ));
  }
}
