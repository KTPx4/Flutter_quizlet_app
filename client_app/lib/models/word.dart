import 'meaning.dart';

class Word {
  final String? id;
  final String? topicID;
  final String desc;
  final String img;
  final Meaning mean1;
  final Meaning mean2;

  Word({
    this.id,
    this.topicID,
    required this.desc,
    required this.img,
    required this.mean1,
    required this.mean2,
  });

  factory Word.fromJson(Map<String, dynamic> json) {
    if (json['_id'] == null ||
        json['topicID'] == null ||
        json['desc'] == null ||
        json['img'] == null ||
        json['mean1'] == null ||
        json['mean2'] == null) {
      throw Exception('One or more fields are null in the returned Word');
    }

    return Word(
      id: json['_id'],
      topicID: json['topicID'],
      desc: json['desc'],
      img: json['img'],
      mean1: Meaning.fromJson(json['mean1']),
      mean2: Meaning.fromJson(json['mean2']),
    );
  }

  Map<String, dynamic> addWordToJson() {
    return {
      'desc': desc,
      'img': img,
      'mean1': mean1.toJson(),
      'mean2': mean2.toJson(),
    };
  }

  Map<String, dynamic> editWordToJson() {
    return {
      "_id": id,
      'desc': desc,
      'img': img,
      'mean1': mean1.toJson(),
      'mean2': mean2.toJson(),
    };
  }
}
