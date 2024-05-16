import 'package:client_app/apiservices/AccountService.dart';
import 'package:client_app/apiservices/topicAPI.dart';
import 'package:client_app/models/topic.dart';
import 'package:client_app/models/word.dart';

class TopicService {
  final AccountService accountService = AccountService();
  Future<List<Topic>> getPublicTopics() async {
    var response = await TopicAPI.getPublicTopics();

    if (response['success']) {
      return response['topics']
          .map((topic) => Topic.fromJson(topic))
          .toList()
          .cast<Topic>();
    } else {
      throw Exception(response['message']);
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
      throw Exception(response['message']);
    }
  }

  Future<String> addTopic(Topic topic) async {
    var response = await TopicAPI.addTopic(topic: topic);
    if (response['success']) {
      return response['_id'];
    } else {
      throw Exception(response['message']);
    }
  }

  Future<Topic> editTopic(String id, Topic topic) async {
    var response = await TopicAPI.editTopic(id: id, topic: topic);
    if (response['success']) {
      return Topic.fromJson(response['message']);
    } else {
      throw Exception(response['message']);
    }
  }

  Future<void> deleteTopic(String id) async {
    var response = await TopicAPI.deleteTopic(id: id);
    if (!response['success']) {
      throw Exception(response['message']);
    }
  }

  Future<Topic> getTopicById(String id) async {
    var response = await TopicAPI.getTopicById(id: id);
    if (response['success']) {
      return Topic.fromJson(response['topic']);
    } else {
      throw Exception(response['message']);
    }
  }

  Future<void> editDeleteWords(Topic topic, List<Word> newWords,
      List<Word> existingWords, List<String> deleteIds) async {
    // function implementation
    String topicId = topic.id!;
    // Add a new topic and get the topic ID
    var response = await TopicAPI.editTopic(id: topicId, topic: topic);
    if (!response['success']) {
      throw Exception(response['message']);
    }
    // Edit the existing words

    for (var id in deleteIds) {
      var deleteResponse =
          await TopicAPI.deleteWordsInTopic(id: topicId, wordId: id);
      if (!deleteResponse['success']) {
        throw Exception(deleteResponse['message']);
      }
    }


    // Step 3: s to the topic
    var response = await TopicAPI.addWordsToTopic(id: topicId, words: words);

    var editResponse =
        await TopicAPI.editWordsInTopic(id: topicId, words: existingWords);
    if (!editResponse['success']) {
      throw Exception(editResponse['message']);
    }

    // Delete the words with the provided delete IDs

    // Add new words
    if (newWords.isEmpty) {
      return;
    }
    var addResponse =
        await TopicAPI.addWordsToTopic(id: topicId, words: newWords);
    if (!addResponse['success']) {
      throw Exception(addResponse['message']);
    }
  }

  Future<void> addWordsToTopic(Topic topic, List<Word> words) async {
    // Add a new topic and get the topic ID
    var response = await TopicAPI.addTopic(topic: topic);

    if (!response['success']) {
      throw Exception(response['message']);
    }
    String topicId = response['_id'];

    // Add new words to the topic
    var addWordsResponse =
        await TopicAPI.addWordsToTopic(id: topicId, words: words);
    if (!addWordsResponse['success']) {
      throw Exception(addWordsResponse['message']);
    }
  }
}
// Implement other methods as needed
