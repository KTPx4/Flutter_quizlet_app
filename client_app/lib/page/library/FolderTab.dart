import 'package:client_app/models/AccountService.dart';
import 'package:client_app/modules/callFunction.dart';
import 'package:client_app/values/folder.dart';
import 'package:flutter/material.dart';

class FolderTab extends StatefulWidget {
  final CallFunction callFunction;
  const FolderTab({super.key, required this.callFunction});

  @override
  State<FolderTab> createState() => _FolderTabState();
}

// this page only use for show list topic in library,
// when click 1 folder => navigate to Page Folder (page/folder) to show list topic

// this page only use for show list topic in library,
// when click 1 folder => navigate to Page Folder (page/folder) to show list topic

class _FolderTabState extends State<FolderTab> {
  final AccountService accountService = AccountService();

  @override
  void initState() {
    // TODO: implement initState
    widget.callFunction.refreshWidget = () {
      setState(() {});
    };
    super.initState();
  }

  Widget _buildTopicsListView() {
    return ListView.builder(
      itemBuilder: (context, index) {
        var folder = folderList[index];
        var account = accountService.getAccountById(folder.accountID);
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
                Icon(Icons.folder_copy_outlined),
                SizedBox(
                  height: 10,
                ), // First row: Topic name
                Text(folder.folderName),
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
          ),
        );
      },
      itemCount: folderList.length,
    );
  }

  @override
  Widget build(BuildContext context) {
    return _buildTopicsListView();
  }
}
