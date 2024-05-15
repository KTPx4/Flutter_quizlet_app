import 'package:flutter/material.dart';

class AddFolderDialog extends StatefulWidget {
  AddFolderDialog();

  @override
  _AddFolderDialogState createState() => _AddFolderDialogState();
}

class _AddFolderDialogState extends State<AddFolderDialog> {
  String folderName = '';
  String folderDescription = '';

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text('Add Folder'),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          TextField(
            onChanged: (value) {
              setState(() {
                folderName = value;
              });
            },
            decoration: InputDecoration(hintText: "Folder Name"),
          ),
          TextField(
            onChanged: (value) {
              setState(() {
                folderDescription = value;
              });
            },
            decoration: InputDecoration(hintText: "Folder Description"),
          ),
        ],
      ),
      actions: <Widget>[
        TextButton(
          onPressed: () {
            Navigator.of(context).pop();
          },
          child: Text('Cancel'),
        ),
        TextButton(
          onPressed: () {
            Navigator.of(context).pop();
          },
          child: Text('Add'),
        ),
      ],
    );
  }
}
