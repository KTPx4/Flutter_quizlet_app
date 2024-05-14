import 'package:client_app/apiservices/topicAPI.dart';
import 'package:client_app/models/meaning.dart';
import 'package:client_app/models/word.dart';

import '../models/topic.dart';

class TopicAPITester {
  final TopicAPI api = TopicAPI();
  final Topic testTopic = Topic(
    topicName: 'Test Hoang',
    desc: 'This is a test topic',
    isPublic: true,
    words: [
      Word(
        desc: 'Test Word',
        img: '',
        mean1: Meaning(title: 'Hello', lang: 'English'),
        mean2: Meaning(title: 'Xin chào', lang: 'Vietnamese'),
      ),
    ],
  );
  final String testId = '6641c975c4391ad442d13824';
  final String testWordId = '6641c975c4391ad442d13826';

  Future<void> testGetPublicTopics() async {
    var result = await TopicAPI.getPublicTopics();
    print('getPublicTopics result: $result');
  }

  Future<void> testGetAccountTopics() async {
    var result = await TopicAPI.getAccountTopics();
    print('getAccountTopics result: $result');
  }

  Future<void> testAddTopic() async {
    var result = await TopicAPI.addTopic(topic: testTopic);
    print('addTopic result: $result');
  }

  Future<void> testEditTopic() async {
    var result = await TopicAPI.editTopic(id: testId, topic: testTopic);
    print('editTopic result: $result');
  }

  Future<void> testDeleteTopic() async {
    var result = await TopicAPI.deleteTopic(id: testId);
    print('deleteTopic result: $result');
  }

  Future<void> testGetTopicById() async {
    var result = await TopicAPI.getTopicById(id: testId);
    print('getTopicById result: $result');
  }

  Future<void> testAddWordsToTopic() async {
    var result =
        await TopicAPI.addWordsToTopic(id: testId, words: testTopic.words);
    print('addWordsToTopic result: $result');
  }

  Future<void> testEditWordsInTopic() async {
    var result = await TopicAPI.editWordsInTopic(
        id: testId, wordId: testWordId, words: testTopic.words);
    print('editWordsInTopic result: $result');
  }

  Future<void> testDeleteWordsInTopic() async {
    var result =
        await TopicAPI.deleteWordsInTopic(id: testId, wordId: testWordId);
    print('deleteWordsInTopic result: $result');
  }
}
