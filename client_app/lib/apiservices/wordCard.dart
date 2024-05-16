import 'package:flutter/material.dart';

class WordCard extends StatefulWidget {
  int index;
  List<String> verbs = [];
  List<String> definitions = [];
  GlobalKey _formKey = GlobalKey<FormState>();
  WordCard(
      {super.key,
      required this.index,
      required this.verbs,
      required this.definitions});

  @override
  State<WordCard> createState() => _WordCardState();
}

class _WordCardState extends State<WordCard> {
  @override
  Widget build(BuildContext context) {
    return Card(
      margin: EdgeInsets.only(bottom: 16),
      child: Padding(
        padding: EdgeInsets.all(16),
        child: Form(
          key: widget._formKey,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextFormField(
                initialValue: widget.index < widget.verbs.length
                    ? widget.verbs[widget.index]
                    : "",
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
                  widget.verbs.add(value ?? "");
                },
              ),
              SizedBox(height: 10),
              TextFormField(
                initialValue: widget.index < widget.definitions.length
                    ? widget.definitions[widget.index]
                    : "",
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
                  widget.definitions.add(value ?? "");
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
