import 'package:client_app/modules/callFunction.dart';
import 'package:flutter/material.dart';

class TopicPage extends StatefulWidget {
  CallFunction callFunction;
  TopicPage({required this.callFunction , super.key});

  @override
  State<TopicPage> createState() => _TopicPageState();
}

class _TopicPageState extends State<TopicPage> {
  String title = "topic";
  
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    widget.callFunction.refreshWidget = refreshFunction;

  }
  void refreshFunction()
  {
    setState(() {
      title = "Test Refresh Success";
    });
  }


  @override
  Widget build(BuildContext context) {
    return Center(child: Text(title),);
  }
}