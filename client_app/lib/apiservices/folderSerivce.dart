import 'package:client_app/models/folder.dart';

import 'folderAPI.dart';

class FolderService {
  // Add a new folder
  Future<String> addFolder(Folder folder) async {
    var response = await FolderAPI.addFolder(folder);

    if (response['success']) {
      return response['_id'];
    } else {
      return response['message'];
    }
  }

  Future<String> AddTopicsToFolder(List<String> exitingTopics,
      List<String> selectedTopics, String id) async {
    List<String> removeFolderTopics =
        exitingTopics.where((item) => !selectedTopics.contains(item)).toList();
    List<String> addFolderTopics =
        selectedTopics.where((item) => !exitingTopics.contains(item)).toList();

    // Remove the topics from the folder
    for (var topicId in removeFolderTopics) {
      var response = await FolderAPI.removeTopicFromFolder(id, topicId);
      if (!response['success']) {
        return response['message'];
      }
    }

    // Add the new topics to the folder
    try {
      if (addFolderTopics.isNotEmpty)
        await FolderAPI.addTopicsToFolder(id, addFolderTopics);
    } catch (e) {
      return "Không thể thêm chủ đề vào thư mục. Chủ đề có thể đã có trong thư mục. Vui lòng thử lại sau!";
    }

    return "Chủ đề đã được cập nhật thành công!";
  }

  Future<String> removeTopicFromFolder(String folderId, String topicId) async {
    var response = await FolderAPI.removeTopicFromFolder(folderId, topicId);

    if (!response['success']) {
      return 'Không thể xóa chủ đề khỏi thư mục: ' + response['message'];
    }

    return 'Chủ đề đã được xóa khỏi thư mục thành công!';
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
      return [];
    }
  }

  // Delete a folder
  Future<String> deleteFolder(String id) async {
    var response = await FolderAPI.deleteFolder(id);

    if (!response['success']) {
      return 'Xóa thư mục không thành công: ' + response['message'];
    }
    return 'Thư mục đã được xóa thành công!';
  }

  Future<Folder> getFolderById(String id) async {
    var response = await FolderAPI.getFolderById(id);

    if (response['success']) {
      return Folder.fromJson(response['data']);
    }
    return Folder(folderName: "error", desc: "error");
  }

  Future<String> editFolder(String id, Folder folder) async {
    var response = await FolderAPI.editFolder(id, folder);

    if (response['success']) {
      return response['_id'];
    } else {
      return response['message'];
    }
  }

  Future<String> addTopicToFolder(String folderId, String topicId) async {
    try {
      await FolderAPI.addTopicsToFolder(folderId, [topicId]);
      return "Chủ đề đã được thêm vào thư mục thành công!";
    } catch (e) {
      return "Không thể thêm chủ đề vào thư mục. Chủ đề có thể đã có trong thư mục!";
    }
  }
}
