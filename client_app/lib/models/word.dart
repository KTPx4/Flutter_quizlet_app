import 'meaning.dart';

class Word {
  final String desc;
  final String img;
  final Meaning mean1;
  final Meaning mean2;

  Word({
    required this.desc,
    required this.img,
    required this.mean1,
    required this.mean2,
  });

  factory Word.fromJson(Map<String, dynamic> json) {
    return Word(
      desc: json['desc'],
      img: json['img'],
      mean1: Meaning.fromJson(json['mean1']),
      mean2: Meaning.fromJson(json['mean2']),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'desc': desc,
      'img': img,
      'mean1': mean1,
      'mean2': mean2,
    };
  }
}
