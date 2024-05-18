import 'topic.dart';

class Folder {
  final String? id;
  final String folderName;
  final String desc;
  final String? authorID;
  final String? createAt;
  final int? countTopic;
  final List<Topic> topics;

  Folder({
    this.id,
    required this.folderName,
    required this.desc,
    this.authorID,
    this.createAt,
    this.countTopic,
    this.topics = const [],
  });

  factory Folder.fromJson(Map<String, dynamic> json) {
    if (json['_id'] == null) {
      throw Exception('The field _id is null in the returned Folder');
    }
    if (json['folderName'] == null) {
      throw Exception('The field folderName is null in the returned Folder');
    }
    if (json['desc'] == null) {
      throw Exception('The field desc is null in the returned Folder');
    }
    if (json['authorID'] == null) {
      throw Exception('The field authorID is null in the returned Folder');
    }
    if (json['createAt'] == null) {
      throw Exception('The field createAt is null in the returned Folder');
    }
    if (json['countTopic'] == null) {
      throw Exception('The field countTopic is null in the returned Folder');
    }
    if (json['topics'] == null) {
      throw Exception('The field topics is null in the returned Folder');
    }

    var topicList = json['topics'] as List;
    List<Topic> topics = topicList.map((i) => Topic.fromJson(i)).toList();

    return Folder(
      id: json['_id'],
      folderName: json['folderName'],
      desc: json['desc'],
      authorID: json['authorID'],
      createAt: json['createAt'],
      countTopic: json['countTopic'],
      topics: topics,
    );
  }
}
