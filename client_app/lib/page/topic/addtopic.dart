// transition function   control the current tab and the current page

import 'package:client_app/apiservices/TopicService.dart';
import 'package:client_app/models/topic.dart';
import 'package:flutter/material.dart';
import 'package:language_picker/language_picker_dropdown.dart';
import 'package:language_picker/languages.dart';

class AddTopicPage extends StatefulWidget {
  @override
  State<AddTopicPage> createState() => _AddTopicPageState();
}

class _AddTopicPageState extends State<AddTopicPage> {
  final TopicService topicService = TopicService();
  List<GlobalKey<FormState>> formKeys = [GlobalKey<FormState>()];
  final _titleFormKey = GlobalKey<FormState>();
  List<String> verbs = [];
  List<String> definitions = [];
  final titleController = TextEditingController();
  Language verbLanguage = Languages.english;
  Language definitionLanguage = Languages.english;
  bool isPublic = false;
  int numberofquestioncard = 1;
  @override
  void dispose() {
    // TODO: implement dispose

    super.dispose();
  }

  Widget QuestionCard(index) {
    return Card(
      margin: EdgeInsets.only(bottom: 16),
      child: Padding(
        padding: EdgeInsets.all(16),
        child: Form(
          key: formKeys[index],
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextFormField(
                initialValue: index < verbs.length ? verbs[index] : "",
                decoration: InputDecoration(
                  labelText: "Verb",
                  hintText: "Enter your question here",
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'This field cannot be empty';
                  }
                  return null;
                },
                onSaved: (value) {
                  verbs.add(value ?? "");
                },
              ),
              SizedBox(height: 10),
              TextFormField(
                initialValue:
                    index < definitions.length ? definitions[index] : "",
                decoration: InputDecoration(
                  labelText: "Definition",
                  hintText: "Enter the answer here",
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'This field cannot be empty';
                  }
                  return null;
                },
                onSaved: (value) {
                  definitions.add(value ?? "");
                },
              ),
            ],
          ),
        ),
      ),
    );
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

  void _addTopic() async {
    bool allValid =
        formKeys.every((formKey) => formKey.currentState!.validate());
    if (allValid && _titleFormKey.currentState!.validate()) {
      formKeys.forEach((formKey) => formKey.currentState!.save());
      Topic topic = Topic(
        topicName: titleController.text,
        desc: titleController.text,
        isPublic: isPublic,
        words: [],
      );
      await topicService.addTopicAndWords(topic, verbs, definitions,
          verbLanguage.name.toString(), verbLanguage.name.toString());
      Navigator.pop(context);
    }
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
              onPressed: _addTopic,
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
                itemCount: numberofquestioncard,
                itemBuilder: (context, index) {
                  return QuestionCard(index);
                },
              ),
            ],
          ),
        ),
        floatingActionButton: FloatingActionButton(
          onPressed: () {
            setState(() {
              formKeys.add(GlobalKey<FormState>());
              numberofquestioncard++;
            });
          },
          child: Icon(Icons.add),
        ));
  }
}
