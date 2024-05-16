import 'package:client_app/apiservices/folderSerivce.dart';
import 'package:client_app/models/folder.dart';
import 'package:flutter/material.dart';

class AddFolderDialog extends StatefulWidget {
  AddFolderDialog();

  @override
  _AddFolderDialogState createState() => _AddFolderDialogState();
}

class _AddFolderDialogState extends State<AddFolderDialog> {
  TextEditingController folderNameController = TextEditingController();
  TextEditingController folderDescriptionController = TextEditingController();
  final FolderService folderService = FolderService();
  final _formKey = GlobalKey<FormState>();
  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text('Add Folder'),
      content: Form(
        key: _formKey,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            TextFormField(
              controller: folderNameController,
              onChanged: (value) {
                setState(() {});
              },
              decoration: InputDecoration(hintText: "Folder Name"),
            ),
            TextFormField(
              controller: folderDescriptionController,
              onChanged: (value) {
                setState(() {});
              },
              decoration: InputDecoration(hintText: "Folder Description"),
            ),
          ],
        ),
      ),
      actions: <Widget>[
        TextButton(
          onPressed: () {},
          child: Text('Cancel'),
        ),
        TextButton(
          onPressed: () async {
            if (_formKey.currentState!.validate()) {
              Navigator.of(context).pop();
            }
            folderService.addFolder(Folder(
              folderName: folderNameController.text,
              desc: folderDescriptionController.text,
            ));
          },
          child: Text('Add'),
        ),
      ],
    );
  }
}
