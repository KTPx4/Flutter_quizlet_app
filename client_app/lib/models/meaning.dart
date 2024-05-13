class Meaning {
  final String title;
  final String lang;

  Meaning({
    required this.title,
    required this.lang,
  });

  factory Meaning.fromJson(Map<String, dynamic> json) {
    return Meaning(
      title: json['title'],
      lang: json['lang'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'title': title,
      'lang': lang,
    };
  }
}
