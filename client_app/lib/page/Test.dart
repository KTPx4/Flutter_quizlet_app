import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class TestPage extends StatefulWidget {
  const TestPage({super.key});

  @override
  State<TestPage> createState() => _TestPageState();
}

class _TestPageState extends State<TestPage> {
  @override
  Widget build(BuildContext context) {
    return Center(
      child: ElevatedButton(onPressed: () async{
      var pref = await SharedPreferences.getInstance();
      pref.remove( "quizlet-login");
      Navigator.pushNamedAndRemoveUntil(context, "/", (route) => false);
      }, child: Text("Clear")),
    );
  }
}