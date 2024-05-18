import 'package:client_app/apiservices/AccountService.dart';
import 'package:client_app/apiservices/TopicService.dart';
import 'package:client_app/apiservices/accountAPI.dart';
import 'package:client_app/apiservices/folderSerivce.dart';
import 'package:client_app/models/account.dart';
import 'package:client_app/models/topic.dart';
import 'package:client_app/modules/callFunction.dart';
import 'package:client_app/page/folder/FolderPage.dart';
import 'package:flutter/material.dart';

import '../topic/topicStudy.dart';

class ViewPublicAccount extends StatefulWidget {
  String accountID;
  ViewPublicAccount({required this.accountID, super.key});

  @override
  State<ViewPublicAccount> createState() => _ViewPublicAccountState();
}

class _ViewPublicAccountState extends State<ViewPublicAccount> {
  List<Topic> topicList = [];
  String title = "topic";
  final FolderService folderService = FolderService();
  final CallFunction callFunctionFolder = CallFunction();
  final AccountService accountService = AccountService();
  final TopicService topicService = TopicService();
  AccountModel? account;
  String titleAppbar = "Tài Khoản";
  int countTopics = 0;

  Future<AccountModel?> getAccountByID() async {
    var res = await AccountAPI.getAccountById(widget.accountID);
    account = res["account"];
    return account;
  }

  // Edit add topic to folder at here

  Widget buildPopupMenuButton(Topic topic) {
    return PopupMenuButton<String>(
      onSelected: (value) async {
        if (value == 'Add') {
          var idTopic = topic.id;
          String? folderId = '';
          await showDialog(
            context: context,
            builder: (BuildContext context) {
              return Dialog(
                child: FolderTab(
                    callFunction: callFunctionFolder, selectFolder: true),
              );
            },
          ).then((value) {
            folderId = value;
          });

          if (folderId == null || folderId!.isEmpty) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text('Xin Thêm Vào Thư Mục'),
              ),
            );
            return;
          }

          String response =
              await folderService.addTopicToFolder(folderId!, idTopic!);
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(response),
            ),
          );
        }
      },
      itemBuilder: (BuildContext context) => <PopupMenuEntry<String>>[
        const PopupMenuItem<String>(
          value: 'Add',
          child: Row(
            children: [
              Icon(Icons.folder),
              Text('Thêm vào thư mục'),
            ],
          ),
        ),
        // const PopupMenuItem<String>(
        //   value: 'Delete',
        //   child: Row(
        //     children: [
        //       Icon(Icons.delete),
        //       Text('Delete'),
        //     ],
        //   ),
        // ),
      ],
    );
  }

  @override
  void initState() {
    super.initState();
    getAccountByID();
  }

  Widget _buildTopicsListView() {
    return FutureBuilder<Map<String, dynamic>>(
      future: topicService.getAccountTopicsPublic(accountID: widget.accountID),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return Center(
              child: CircularProgressIndicator(
            color: Colors.pink,
          ));
        } else if (snapshot.hasError) {
          return Text('Lỗi: ${snapshot.error}');
        } else {
          var topics = snapshot.data?["topics"];
          topicList = topics;
          if (topics == null || topics.isEmpty) {
            return Center(
              child: Text('Không có chủ đề nào'),
            );
          }

          return Column(
            children: [
              SizedBox(
                height: 10,
              ),
              Text(
                "${topics.length} Chủ đề",
                style: const TextStyle(
                  fontFamily: "SanProBold",
                  fontSize: 17,
                ),
              ),
              SizedBox(
                height: 10,
              ),
              ListView.builder(
                shrinkWrap: true,
                physics: NeverScrollableScrollPhysics(),
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
                                Expanded(
                                    child: Text(
                                  topic.topicName,
                                  overflow: TextOverflow.ellipsis,
                                )),
                                buildPopupMenuButton(
                                  topic,
                                ),
                              ]),
                          SizedBox(
                            height: 10,
                          ), // First row: Topic name
                          Text('Số từ: ${topic.words.length}'),
                          SizedBox(
                            height: 21,
                          ), // Second row: Term + number of questions
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
              ),
            ],
          );
        }
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          "Danh sách chủ đề",
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
        ),
      ),
      body: SingleChildScrollView(
        child: Column(
          verticalDirection: VerticalDirection.up,
          children: [
            _buildTopicsListView(),
            _buildAuthor(),
          ],
        ),
      ),
    );
  }

  Widget _buildAuthor() {
    return FutureBuilder(
      future: getAccountByID(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return Center(
            child: CircularProgressIndicator(),
          );
        } else if (snapshot.hasError) {
          return Center(
            child: Text("Có chút lỗi khi load dữ liệu tài khoản này @@!"),
          );
        } else {
          var acc = snapshot.data;
          var linkAvt =
              "${AccountAPI.getServer()}/images/account/${acc?.id}/${acc?.nameAvt}";
          return Container(
            // color: Colors.grey,
            margin: EdgeInsets.only(top: 20),
            child: Column(
              children: [
                // avatar
                Container(
                  margin: const EdgeInsets.only(top: 10, bottom: 5),
                  decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      border: Border.all(
                          width: 2,
                          color: const Color.fromARGB(255, 32, 198, 248))),
                  child: CircleAvatar(
                    backgroundImage: NetworkImage(linkAvt),
                    radius: 35,
                  ),
                ),
                Text(
                  acc?.fullName ?? "",
                  style: const TextStyle(
                    fontFamily: "SanProBold",
                    fontSize: 18,
                  ),
                ),
                Text(
                  acc?.user ?? "",
                  style: const TextStyle(
                      fontFamily: "SanPro", fontSize: 14, color: Colors.grey),
                ),
              ],
            ),
          );
        }
      },
    );
  }
}
