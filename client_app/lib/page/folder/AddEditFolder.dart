import 'package:client_app/apiservices/folderSerivce.dart';
import 'package:client_app/models/folder.dart';
import 'package:flutter/material.dart';

class AddEditFolderDialog extends StatefulWidget {
  final Folder? folder;

  AddEditFolderDialog({this.folder});

  @override
  _AddEditFolderDialogState createState() => _AddEditFolderDialogState();
}

class _AddEditFolderDialogState extends State<AddEditFolderDialog> {
  TextEditingController folderNameController = TextEditingController();
  TextEditingController folderDescriptionController = TextEditingController();
  final FolderService folderService = FolderService();
  final _formKey = GlobalKey<FormState>();

  @override
  void initState() {
    super.initState();
    if (widget.folder != null) {
      folderNameController.text = widget.folder!.folderName;
      folderDescriptionController.text = widget.folder!.desc;
    }
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text(widget.folder == null ? 'Add Folder' : 'Edit Folder'),
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
          onPressed: () {
            Navigator.of(context).pop();
          },
          child: Text('Cancel'),
        ),
        TextButton(
          onPressed: () async {
            if (_formKey.currentState!.validate()) {
              if (widget.folder == null) {
                await folderService.addFolder(Folder(
                  folderName: folderNameController.text,
                  desc: folderDescriptionController.text,
                ));
              } else {
                await folderService.editFolder(
                    widget.folder!.id!,
                    Folder(
                      folderName: folderNameController.text,
                      desc: folderDescriptionController.text,
                    ));
              }
              Navigator.of(context).pop();
            }
          },
          child: Text(widget.folder == null ? 'Add' : 'Save'),
        ),
      ],
    );
  }
}
