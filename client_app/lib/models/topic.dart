import 'package:client_app/models/word.dart';

class Topic {
  final String topicName;
  final String desc;
  final bool isPublic;
  final List<Word> words;

  Topic({
    required this.topicName,
    required this.desc,
    required this.isPublic,
    required this.words,
  });

  factory Topic.fromJson(Map<String, dynamic> json) {
    var wordList = json['words'] as List;
    List<Word> words = wordList.map((i) => Word.fromJson(i)).toList();

    return Topic(
      topicName: json['topicName'],
      desc: json['desc'],
      isPublic: json['isPublic'],
      words: words,
    );
  }
}
