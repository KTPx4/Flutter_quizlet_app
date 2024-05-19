// transition function   control the current tab and the current page

import 'dart:convert';
import 'dart:io';

import 'package:client_app/apiservices/TopicService.dart';
import 'package:client_app/models/meaning.dart';
import 'package:client_app/models/topic.dart';
import 'package:client_app/models/word.dart';
import 'package:csv/csv.dart';
import 'package:file_picker/file_picker.dart';
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
  bool allValid = false;

  Future<File> pickCsvFile() async {
    FilePickerResult? result = await FilePicker.platform.pickFiles(
      type: FileType.custom,
      allowedExtensions: ['csv'],
    );

    if (result != null) {
      return File(result.files.single.path!);
    } else {
      // Handle the case where no file was picked
      return File('');
    }
  }

  Future<List<Word>> parseCsvFile(File file) async {
    final input = file.openRead();
    final rows = await input
        .transform(utf8.decoder)
        .transform(CsvToListConverter())
        .toList();

    if (rows.isEmpty) {
      return [];
    }

    final headers = rows.first;
    int tuIndex = headers.indexOf('verb');
    int nghiaIndex = headers.indexOf('definition');

    if (tuIndex == -1 || nghiaIndex == -1) {
      return [];
    }

    // Skip the header row
    final dataRows = rows.skip(1);

    return dataRows
        .map((e) => Word(
              mean1: Meaning(
                  title: e[tuIndex], lang: verbLanguage.name.toString()),
              mean2: Meaning(
                  title: e[nghiaIndex],
                  lang: definitionLanguage.name.toString()),
              desc: '',
              img: '',
            ))
        .toList();
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
    for (var formKey in formKeys) {
      if (formKey.currentState != null) {
        var form = formKey.currentState!;
        var isValid = form.validate();

        if (!isValid) {
          allValid = false;
        }
      }
    }
    allValid = (_titleFormKey.currentState?.validate() ?? false);
    if (allValid && widget.topic != null) {
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
                desc: DateTime.now().toIso8601String(),
                img: '',
                id: word.id,
              ))
          .toList();
      Topic topic = Topic(
        topicName: titleController.text,
        desc: titleController.text,
        isPublic: isPublic,
        id: widget.topic!.id,
        words: [],
      );
      await topicService.editDeleteWords(
          topic, newWords, existingWords, deletedWords);

      Navigator.pop(context);
    } else if (allValid) {
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
      await topicService.addWordsToTopic(topic, words);
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
              title: Text('Chọn Ngôn Ngữ'),
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
                          child: Text('Cộng Đồng',
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
          title: Text('Thêm Chủ Đề'),
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
                      return 'Trường này không thể để trống';
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
                  TextButton(
                    onPressed: () async {
                      final file = await pickCsvFile();
                      final newwords = await parseCsvFile(file);
                      if (newwords.isEmpty) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(content: Text('không thể tải lên tệp CSV')),
                        );
                      } else {
                        formKeys.addAll(List.generate(newwords.length,
                            (index) => GlobalKey<FormState>()));
                        this.words.addAll(newwords);
                        setState(() {});
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(content: Text('thêm chủ đề thành công')),
                        );
                      }
                    },
                    child: Text('Tải lên tệp CSV'),
                  ),
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
