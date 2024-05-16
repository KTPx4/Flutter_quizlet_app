import 'package:client_app/apiservices/topicAPI.dart';
import 'package:client_app/models/meaning.dart';
import 'package:client_app/models/topic.dart';
import 'package:client_app/models/word.dart';

class TopicService {
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

  Future<void> addTopicAndWords(
      Topic topic,
      List<String> verbs,
      List<String> definitions,
      String verbLanguage,
      String definitionLanguage) async {
    // Step 1: Add the topic
    String topicId = await addTopic(topic);

    // Step 2: Create a list of Word objects
    List<Word> words = [];
    for (int i = 0; i < verbs.length; i++) {
      String currentDate = DateTime.now().toString();
      words.add(Word(
        desc: 'added word on $currentDate',
        img: '', // replace with actual image path or URL
        mean1: Meaning(
            title: verbs[i],
            lang: verbLanguage), // replace 'en' with actual language code
        mean2: Meaning(
            title: definitions[i],
            lang:
                definitionLanguage), // replace '' and 'en' with actual title and language code
      ));
    }

    // Step 3: s to the topic
    var response = await TopicAPI.addWordsToTopic(id: topicId, words: words);
    if (!response['success']) {
      throw Exception(response['message']);
    }
  }

// Implement other methods as needed
}
