import 'package:client_app/models/folder.dart';

import 'folderAPI.dart';

class FolderService {
  // Add a new folder
  Future<String> addFolder(Folder folder) async {
    var response = await FolderAPI.addFolder(folder);

    if (response['success']) {
      return response['_id'];
    } else {
      throw Exception(response['message']);
    }
  }

  // Get all folders
  Future<List<Folder>> getFolders() async {
    var response = await FolderAPI.getFolders();

    if (response['success']) {
      if (response['folders'] == null) return [];
      return response['folders']
          .map((folder) => Folder.fromJson(folder))
          .toList()
          .cast<Folder>();
    } else {
      throw Exception(response['message']);
    }
  }

  // Delete a folder
  Future<void> deleteFolder(String id) async {
    var response = await FolderAPI.deleteFolder(id);

    if (!response['success']) {
      throw Exception(response['message']);
    }
  }
}
