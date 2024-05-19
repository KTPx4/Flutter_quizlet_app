import 'package:client_app/apiservices/AccountService.dart';
import 'package:client_app/apiservices/topicAPI.dart';
import 'package:client_app/models/folder.dart';
import 'package:client_app/models/topic.dart';
import 'package:client_app/models/word.dart';

import 'folderSerivce.dart';

class TopicService {
  final AccountService accountService = AccountService();
  final FolderService folderService = FolderService();
  Future<List<Topic>> getPublicTopics() async {
    var response = await TopicAPI.getPublicTopics();

    if (response['success']) {
      return response['topics']
          .map((topic) => Topic.fromJson(topic))
          .toList()
          .cast<Topic>();
    } else {
      return [];
    }
  }

  Future<List<Topic>> getAccountTopics() async {
    var response = await TopicAPI.getAccountTopics();
    if (response['success']) {
      if (response['topics'] == null) return [];
      var topic = response['topics']
          .map((topic) => Topic.fromJson(topic))
          .toList()
          .cast<Topic>();
      return topic;
    } else {
      return [];
    }
  }

  Future<Map<String, dynamic>> getAccountTopicsPublic(
      {required accountID}) async {
    var response = await TopicAPI.getPublicTopicsByUser(accountID: accountID);
    if (response['success']) {
      if (response['topics'] == null) return {"topics": [], "count": 0};
      var topic = response['topics']
          .map((topic) => Topic.fromJson(topic))
          .toList()
          .cast<Topic>();
      // var topic = response['topics'];
          
      return {"topics": topic, "count": response['count']};
    } else {
      return {"topics": [], "count": 0};
    }
  }

  Future<String> addTopic(Topic topic) async {
    var response = await TopicAPI.addTopic(topic: topic);
    if (response['success']) {
      return response['_id'];
    } else {
      return response['message'];
    }
  }

  Future<Topic> editTopic(String id, Topic topic) async {
    var response = await TopicAPI.editTopic(id: id, topic: topic);
    if (response['success']) {
      return Topic.fromJson(response['message']);
    } else {
      return Topic(
        topicName: '',
        desc: '',
        isPublic: false,
        words: [],
      );
    }
  }

  Future<String> deleteTopic(String id) async {
    var response = await TopicAPI.deleteTopic(id: id);
    if (!response['success']) {
      return response['message'];
    }
    return 'Chủ đề đã được xóa thành công!';
  }

  Future<Topic> getTopicById(String id) async {
    var response = await TopicAPI.getTopicById(id: id);
    if (response['success']) {
      return Topic.fromJson(response['topic']);
    } else {
      return Topic(
        topicName: '',
        desc: '',
        isPublic: false,
        words: [],
      );
    }
  }

  Future<String> editDeleteWords(Topic topic, List<Word> newWords,
      List<Word> existingWords, List<String> deleteIds) async {
    // function implementation
    String topicId = topic.id!;
    // Add a new topic and get the topic ID
    var response = await TopicAPI.editTopic(id: topicId, topic: topic);
    if (!response['success']) {
      return response['message'];
    }
    // Edit the existing words

    for (var id in deleteIds) {
      var deleteResponse =
          await TopicAPI.deleteWordsInTopic(id: topicId, wordId: id);
      if (!deleteResponse['success']) {
        return deleteResponse['message'];
      }
    }

    // // Step 3: s to the topic
    // var response = await TopicAPI.addWordsToTopic(id: topicId, words: words);

    var editResponse =
        await TopicAPI.editWordsInTopic(id: topicId, words: existingWords);
    if (!editResponse['success']) {
      return editResponse['message'];
    }

    // Delete the words with the provided delete IDs

    // Add new words
    if (newWords.isEmpty) {
      return 'Chủ đề đã được cập nhật thành công!';
    }
    var addResponse =
        await TopicAPI.addWordsToTopic(id: topicId, words: newWords);
    if (!addResponse['success']) {
      return addResponse['message'];
    }
    return 'Chủ đề đã được cập nhật thành công!';
  }

  Future<String> addWordsToTopic(Topic topic, List<Word> words) async {
    // Add a new topic and get the topic ID
    var response = await TopicAPI.addTopic(topic: topic);

    if (!response['success']) {
      return response['message'];
    }
    String topicId = response['_id'];

    // Add new words to the topic
    var addWordsResponse =
        await TopicAPI.addWordsToTopic(id: topicId, words: words);
    if (!addWordsResponse['success']) {
      return addWordsResponse['message'];
    }
    return 'Chủ đề đã được thêm thành công!';
  }

  Future<List<Topic>> getTopicsByFolderId(String folderId) async {
    Folder folder = await folderService.getFolderById(folderId);
    return folder.topics;
  }

  Future<List<Word>> getWordsInTopic(String topicId) async {
    var response = await TopicAPI.getWordsInTopic(topicId: topicId);
    if (response['success']) {
      return response['words'];
    } else {
      return <Word>[];
    }
  }

  Future<String> updateWordMark(
      String topicId, String wordId, bool mark) async {
    var response = await TopicAPI.updateWordMark(topicId, wordId, mark);
    return response['message'];
  }

  Future<List<Word>> getMarkedWordsInTopic(String topicId) async {
    try {
      var words = await getWordsInTopic(topicId);
      return words.where((word) => word.isMark == true).toList();
    } catch (e) {
      return [];
    }
  }
}
// Implement other methods as needed
