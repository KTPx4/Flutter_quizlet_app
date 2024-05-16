import 'package:client_app/apiservices/AccountService.dart';
import 'package:client_app/apiservices/folderSerivce.dart';
import 'package:client_app/models/account.dart';
import 'package:client_app/models/folder.dart';
import 'package:client_app/modules/callFunction.dart';
import 'package:flutter/material.dart';

class FolderTab extends StatefulWidget {
  final CallFunction callFunction;
  const FolderTab({super.key, required this.callFunction});

  @override
  State<FolderTab> createState() => _FolderTabState();
}

class _FolderTabState extends State<FolderTab> {
  final FolderService folderService = FolderService();
  final AccountService accountService = AccountService();
  List<AccountModel> accountList = [];
  Future<void> getAllAccount() async {
    accountList = await accountService.getAllAccounts();
  }

  @override
  void initState() {
    // TODO: implement initState
    widget.callFunction.refreshWidget = () {
      setState(() {});
    };
    getAllAccount();
    super.initState();
  }

  Widget _buildFoldersListView() {
    return FutureBuilder<List<Folder>>(
      future: folderService.getFolders(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return CircularProgressIndicator();
        } else if (snapshot.hasError) {
          return Text('Error: ${snapshot.error}');
        } else {
          var folders = snapshot.data;
          if (folders == null || folders.isEmpty) {
            return Center(
              child: Text('No folder found'),
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
                  title: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Icon(Icons.folder_copy_outlined),
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
                            backgroundImage: NetworkImage(account.nameAvt),
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
