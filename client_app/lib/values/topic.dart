import 'package:client_app/values/quiz_data.dart';

class Topic {
  final int id;
  final String topicName;
  final List<Question> questions;
  final String answer;
  final String accountID;
  final DateTime createdDate = DateTime.now();

  Topic({
    required this.id,
    required this.topicName,
    required this.questions,
    required this.answer,
    required this.accountID,
  });

  // Getters
  int get getId => this.id;
  String get getTopicName => this.topicName;
  List<Question> get getQuestions => this.questions;
  String get getAnswer => this.answer;
  String get getAccountID => this.accountID;
  DateTime get getCreatedDate => this.createdDate;
}

// generate a list of topic

List<Topic> topicList = [
  Topic(
      id: 1,
      topicName: "Topic 1",
      questions: questionsData,
      answer: "A taxi-driver",
      accountID: '1'),
  Topic(
      id: 2,
      topicName: "Topic 2",
      questions: questionsData,
      answer: "Because it is the beginning of everything",
      accountID: '2'),
  Topic(
      id: 3,
      topicName: "Topic 3",
      questions: questionsData,
      answer: "Smiles",
      accountID: '1'),
  Topic(
      id: 4,
      topicName: "Topic 4",
      questions: questionsData,
      answer: "In the dictionary",
      accountID: '2'),
  Topic(
      id: 5,
      topicName: "Topic 5",
      questions: questionsData,
      answer: "A pillow",
      accountID: '2'),
];
