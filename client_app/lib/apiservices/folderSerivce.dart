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

  Future<void> AddTopicsToFolder(List<String> exitingTopics,
      List<String> selectedTopics, String id) async {
    List<String> removeFolderTopics =
        exitingTopics.where((item) => !selectedTopics.contains(item)).toList();
    List<String> addFolderTopics =
        selectedTopics.where((item) => !exitingTopics.contains(item)).toList();

    // Remove the topics from the folder
    for (var topicId in removeFolderTopics) {
      var response = await FolderAPI.removeTopicFromFolder(id, topicId);
      if (!response['success']) {
        throw Exception(response['message']);
      }
    }

    // Add the new topics to the folder
    try {
      if (addFolderTopics.isNotEmpty)
        await FolderAPI.addTopicsToFolder(id, addFolderTopics);
    } catch (e) {
      throw Exception(
          "Failed to add topics to folder. Please try again later!");
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

  Future<Folder> getFolderById(String id) async {
    var response = await FolderAPI.getFolderById(id);

    if (response['success']) {
      return Folder.fromJson(response['data']);
    } else {
      throw Exception(response['message']);
    }
  }

  Future<String> editFolder(String id, Folder folder) async {
    var response = await FolderAPI.editFolder(id, folder);

    if (response['success']) {
      return response['_id'];
    } else {
      throw Exception(response['message']);
    }
  }
}
