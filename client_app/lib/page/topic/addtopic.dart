// transition function   control the current tab and the current page

import 'package:client_app/apiservices/TopicService.dart';
import 'package:client_app/models/meaning.dart';
import 'package:client_app/models/topic.dart';
import 'package:client_app/models/word.dart';
import 'package:flutter/material.dart';
import 'package:language_picker/language_picker_dropdown.dart';
import 'package:language_picker/languages.dart';

import 'wordCard.dart';

class AddTopicPage extends StatefulWidget {
  final Topic? topic;

  AddTopicPage({this.topic});
  @override
  State<AddTopicPage> createState() => _AddTopicPageState();
}

class _AddTopicPageState extends State<AddTopicPage> {
  final TopicService topicService = TopicService();
  List<GlobalKey<FormState>> formKeys = [];
  final _titleFormKey = GlobalKey<FormState>();

  List<Word> words = [];
  List<String> deletedWords = [];
  final titleController = TextEditingController();
  Language verbLanguage = Languages.english;
  Language definitionLanguage = Languages.english;
  bool isPublic = false;

  @override
  void dispose() {
    // TODO: implement dispose

    super.dispose();
  }

  @override
  void initState() {
    super.initState();
    if (widget.topic != null) {
      titleController.text = widget.topic!.topicName;
      if (widget.topic!.words.isNotEmpty) {
        verbLanguage = Languages.defaultLanguages.firstWhere((element) =>
            element.name.toLowerCase() ==
            widget.topic!.words.first.mean1.lang.toLowerCase());
        definitionLanguage = Languages.defaultLanguages.firstWhere((element) =>
            element.name.toLowerCase() ==
            widget.topic!.words.first.mean2.lang.toLowerCase());

        isPublic = widget.topic!.isPublic;
        words = widget.topic!.words;
        formKeys =
            List.generate(words.length, (index) => GlobalKey<FormState>());
      }
    } else {
      formKeys = [GlobalKey<FormState>()];
      words.add(Word(
        mean1: Meaning(title: '', lang: verbLanguage.name.toString()),
        mean2: Meaning(title: '', lang: definitionLanguage.name.toString()),
        desc: '',
        img: '',
      ));
    }
  }

  void _actionTopic() async {
    bool allValid = _titleFormKey.currentState!.validate();

    for (var formKey in formKeys) {
      if (formKey.currentState != null) {
        var form = formKey.currentState!;
        var isValid = form.validate();

        if (!isValid) {
          allValid = false;
        }
      }
    }
    if (allValid && Topic != null) {
      formKeys.forEach((formKey) => formKey.currentState!.save());
      List<Word> newWords = words
          .where((word) => word.id == null)
          .map((word) => Word(
                mean1: Meaning(
                    title: word.mean1.title,
                    lang: verbLanguage.name.toString()),
                mean2: Meaning(
                    title: word.mean2.title,
                    lang: definitionLanguage.name.toString()),
                desc: DateTime.now().toIso8601String(),
                img: '',
              ))
          .toList();
      List<Word> existingWords = words
          .where((word) => word.id != null)
          .map((word) => Word(
                mean1: Meaning(
                    title: word.mean1.title,
                    lang: verbLanguage.name.toString()),
                mean2: Meaning(
                    title: word.mean2.title,
                    lang: definitionLanguage.name.toString()),
                desc: DateTime.now()
                    .toIso8601String(), // set desc to the current date and time
                img: '',
              ))
          .toList();
      Topic topic = Topic(
        topicName: titleController.text,
        desc: titleController.text,
        isPublic: isPublic,
        words: [],
      );
      // await topicService.updateTopicAndWords(topic, newWords, deletedWords);
      Navigator.pop(context);
    } else {
      formKeys.forEach((formKey) => formKey.currentState!.save());
      List<Word> newWords = words
          .map((word) => Word(
                mean1: Meaning(
                    title: word.mean1.title,
                    lang: verbLanguage.name.toString()),
                mean2: Meaning(
                    title: word.mean2.title,
                    lang: definitionLanguage.name.toString()),
                desc: DateTime.now().toIso8601String(),
                img: '',
              ))
          .toList();
      Topic topic = Topic(
        topicName: titleController.text,
        desc: titleController.text,
        isPublic: isPublic,
        words: [],
      );
      // await topicService.addTopicAndWords(topic);
      Navigator.pop(context);
    }
  }

  void _deleteWord(int index) {
    if (words[index].id != null) {
      deletedWords.add(words[index].id!);
    }
    setState(() {
      words.removeAt(index);
      formKeys.removeAt(index);
    });
  }

  void showLanguageDialog(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;
    double paddingValue = screenWidth * 0.2;

    showDialog(
      context: context,
      builder: (context) {
        return StatefulBuilder(
          builder: (context, setState) {
            return AlertDialog(
              title: Text('Select a language'),
              content: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  LanguagePickerDropdown(
                    initialValue: verbLanguage,
                    itemBuilder: (language) => Padding(
                      padding: EdgeInsets.symmetric(horizontal: paddingValue),
                      child: Text("${language.name} (${language.isoCode})"),
                    ),
                    onValuePicked: (Language language) {
                      setState(() {
                        this.verbLanguage = language;
                      });
                    },
                  ),
                  LanguagePickerDropdown(
                    initialValue: definitionLanguage,
                    itemBuilder: (language) => Padding(
                      padding: EdgeInsets.symmetric(horizontal: paddingValue),
                      child: Text("${language.name} (${language.isoCode})"),
                    ),
                    onValuePicked: (Language language) {
                      setState(() {
                        this.definitionLanguage = language;
                      });
                    },
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Expanded(
                        child: Center(
                          child: Text('Is Public',
                              style: TextStyle(
                                  fontSize: 16, fontWeight: FontWeight.bold)),
                        ),
                      ),
                      Switch(
                          value: isPublic,
                          onChanged: (value) {
                            setState(() {
                              isPublic = value;
                            });
                          }),
                    ],
                  ),
                ],
              ),
            );
          },
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text('Add Topic'),
          actions: [
            IconButton(
              onPressed: () {
                showLanguageDialog(context);
              },
              icon: Icon(
                Icons.settings,
                color: Colors.blueGrey,
              ),
            ),
            IconButton(
              onPressed: _actionTopic,
              icon: Icon(
                Icons.save,
                color: Colors.lightBlue,
              ),
            ),
          ],
        ),
        body: Container(
          padding: EdgeInsets.all(16),
          child: ListView(
            children: [
              Form(
                key: _titleFormKey,
                child: TextFormField(
                  controller: titleController,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'This field cannot be empty';
                    }
                    return null;
                  },
                  decoration: InputDecoration(
                    hintText: "Title",
                  ),
                ),
              ),
              SizedBox(height: 10),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  TextButton(onPressed: () {}, child: Text('Upload CSV  File')),
                  TextButton(onPressed: () {}, child: Text('Export CSV  File'))
                ],
              ),
              ListView.builder(
                shrinkWrap: true,
                physics: NeverScrollableScrollPhysics(),
                itemCount: words.length,
                itemBuilder: (context, index) {
                  return QuestionCard(
                    word: words[index],
                    onDelete: () => _deleteWord(index),
                    formKey: formKeys[index],
                  );
                },
              ),
            ],
          ),
        ),
        floatingActionButton: FloatingActionButton(
          onPressed: () {
            setState(() {
              formKeys.add(GlobalKey<FormState>());
              words.add(Word(
                mean1: Meaning(title: '', lang: verbLanguage.name.toString()),
                mean2: Meaning(
                    title: '', lang: definitionLanguage.name.toString()),
                desc: '',
                img: '',
              ));
            });
          },
          child: Icon(Icons.add),
        ));
  }
}
