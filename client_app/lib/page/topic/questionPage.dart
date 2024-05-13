import 'package:flutter/material.dart';

class QuestionPage extends StatefulWidget {
  @override
  State<QuestionPage> createState() => _QuestionPageState();
}

class _QuestionPageState extends State<QuestionPage> {
  Widget QuestionCard() {
    return Card(
      margin: EdgeInsets.only(bottom: 16),
      child: Padding(
        padding: EdgeInsets.all(16),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(
              decoration: InputDecoration(
                labelText: "Verb",
                hintText: "Enter your question here",
              ),
            ),
            SizedBox(height: 10),
            TextField(
              decoration: InputDecoration(
                labelText: "Definition",
                hintText: "Enter the answer here",
              ),
            ),
          ],
        ),
      ),
    );
  }

  int numberofquestioncard = 1;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text('Add Topic'),
          actions: [
            IconButton(
              onPressed: () {},
              icon: Icon(Icons.save),
            ),
          ],
        ),
        body: Container(
          padding: EdgeInsets.all(16),
          child: ListView(
            children: [
              TextField(
                decoration: InputDecoration(
                  hintText: "Title",
                ),
              ),
              SizedBox(height: 10),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  TextButton(onPressed: () {}, child: Text('Upload CSV  File')),
                ],
              ),
              ListView.builder(
                shrinkWrap: true,
                physics: NeverScrollableScrollPhysics(),
                itemCount: numberofquestioncard,
                itemBuilder: (context, index) {
                  return QuestionCard();
                },
              ),
            ],
          ),
        ),
        floatingActionButton: FloatingActionButton(
          onPressed: () {
            setState(() {
              numberofquestioncard++;
            });
          },
          child: Icon(Icons.add),
        ));
  }
}
