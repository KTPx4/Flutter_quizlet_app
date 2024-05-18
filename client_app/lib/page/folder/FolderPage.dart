import 'package:client_app/apiservices/AccountService.dart';
import 'package:client_app/apiservices/folderSerivce.dart';
import 'package:client_app/models/account.dart';
import 'package:client_app/models/folder.dart';
import 'package:client_app/modules/callFunction.dart';
import 'package:flutter/material.dart';

import 'AddEditFolder.dart';
import 'FolderTopicPage.dart';

class FolderTab extends StatefulWidget {
  final CallFunction callFunction;
  final bool selectFolder;
  const FolderTab(
      {super.key, required this.callFunction, this.selectFolder = false});

  @override
  State<FolderTab> createState() => _FolderTabState();
}

// this page only use for show list topic in library,
// when click 1 folder => navigate to Page Folder (page/folder) to show list topic

class _FolderTabState extends State<FolderTab> {
  final FolderService folderService = FolderService();
  final AccountService accountService = AccountService();
  void refreshParent() {
    setState(() {});
  }

  List<AccountModel> accountList = [];
  Future<void> getAllAccount() async {
    accountList = await accountService.getAllAccounts();
  }

  @override
  void initState() {
    // TODO: implement initState
    widget.callFunction!.refreshWidget = () {
      setState(() {});
    };
    getAllAccount();
    super.initState();
  }

  Widget buildPopupMenuButton(Folder folder) {
    return PopupMenuButton<int>(
      onSelected: (value) async {
        switch (value) {
          case 1:
            await showDialog(
              context: context,
              builder: (BuildContext context) {
                return AddEditFolderDialog(
                  folder: folder,
                );
              },
            );
            setState(() {});
            break;
          case 2:
            await folderService.deleteFolder(folder.id!);
            setState(() {});
            break;
        }
      },
      itemBuilder: (BuildContext context) => <PopupMenuEntry<int>>[
        const PopupMenuItem<int>(
          value: 1,
          child: Row(
            children: [
              Icon(Icons.edit),
              Text('Sửa'),
            ],
          ),
        ),
        const PopupMenuItem<int>(
          value: 2,
          child: Row(
            children: [
              Icon(Icons.delete),
              Text('Xóa'),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildFoldersListView() {
    return FutureBuilder<List<Folder>>(
      future: folderService.getFolders(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return Center(
            child: CircularProgressIndicator(),
          );
        } else if (snapshot.hasError) {
          return Text('lỗi: ${snapshot.error}');
        } else {
          var folders = snapshot.data;
          if (folders == null || folders.isEmpty) {
            return Center(
              child: Text('không có thư mục nào'),
            );
          }
          return ListView.builder(
            itemCount: folders.length,
            itemBuilder: (context, index) {
              var folder = folders[index];
              var account = accountList
                  .firstWhere((element) => element.id == folder.authorID);
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
                  onTap: () {
                    if (widget.selectFolder) {
                      Navigator.pop(context, folder.id);
                    } else {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => FolderTopicPage(
                            refreshParent: refreshParent,
                            account: account,
                            folder: folder,
                          ),
                        ),
                      );
                    }
                  },
                  title: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Icon(Icons.folder_copy_outlined),
                          buildPopupMenuButton(folder),
                        ],
                      ),
                      SizedBox(
                        height: 10,
                      ), // First row: Folder name
                      Text(folder.folderName),
                      SizedBox(
                        height: 21,
                      ), // Second row: Account avatar and account name
                      Row(
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
    return _buildFoldersListView();
  }
}
