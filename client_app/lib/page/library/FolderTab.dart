import 'package:flutter/material.dart';

class FolderTab extends StatefulWidget {
  const FolderTab({super.key});

  @override
  State<FolderTab> createState() => _FolderTabState();
}

// this page only use for show list topic in library, 
// when click 1 folder => navigate to Page Folder (page/folder) to show list topic

class _FolderTabState extends State<FolderTab> {
  @override
  Widget build(BuildContext context) {
    return Center(child: Text("Folder"));
  }
}