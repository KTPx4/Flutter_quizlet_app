import 'dart:math' as math;
import 'package:client_app/modules/callFunction.dart';
import 'package:client_app/page/account/Profile/Body.dart';
import 'package:client_app/page/account/Profile/Header.dart';
import 'package:flutter/material.dart';

import 'package:flutter/material.dart';

class ProfilePage extends StatefulWidget {
  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  double width = double.infinity;
  final CallFunction callFuntion = CallFunction();

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        backgroundColor: Color.fromARGB(255, 214, 208, 211),
          body: SingleChildScrollView(
            child: Column(
              children: [
                Header(width: width, callFunction: callFuntion,),
                Body(onChange: (value) {
                  if(value["type"] == "refresh")
                  {
                    callFuntion.refreshWidget();
                  }

                },)
              ],
            ),
          ),
        ),
    );
  }
}


