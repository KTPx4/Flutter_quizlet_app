import 'package:client_app/models/word.dart';

class Topic {
  final String? id;
  final String topicName;
  final String desc;
  final String? authorID;
  final bool isPublic;
  final String? createAt;
  final int? countWords;
  final List<Word> words;

  Topic({
    this.id,
    required this.topicName,
    required this.desc,
    this.authorID,
    required this.isPublic,
    this.createAt,
    this.countWords,
    required this.words,
  });

  factory Topic.fromJson(Map<String, dynamic> json) {
    var wordList = json['words'] as List;
    List<Word> words = wordList.map((i) => Word.fromJson(i)).toList();

    if (json['_id'] == null) {
      throw Exception('The field _id is null in the returned Topic');
    }
    if (json['topicName'] == null) {
      throw Exception('The field topicName is null in the returned Topic');
    }
    if (json['desc'] == null) {
      throw Exception('The field desc is null in the returned Topic');
    }
    if (json['authorID'] == null) {
      throw Exception('The field authorID is null in the returned Topic');
    }
    if (json['isPublic'] == null) {
      throw Exception('The field isPublic is null in the returned Topic');
    }
    if (json['createAt'] == null) {
      throw Exception('The field createAt is null in the returned Topic');
    }
    if (json['countWords'] == null) {
      throw Exception('The field countWords is null in the returned Topic');
    }

    return Topic(
      id: json['_id'],
      topicName: json['topicName'],
      desc: json['desc'],
      authorID: json['authorID'],
      isPublic: json['isPublic'],
      createAt: json['createAt'],
      countWords: json['countWords'],
      words: words,
    );
  }
}
