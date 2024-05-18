import 'dart:math' as math;
import 'package:client_app/component/AppBarCustom.dart';
import 'package:client_app/modules/callFunction.dart';
import 'package:client_app/page/account/Profile/Body.dart';
import 'package:client_app/page/account/Profile/Header.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/material.dart';

import 'package:flutter/material.dart';

class ProfilePage extends StatefulWidget {
  GlobalKey<State<AppBarCustom>>? appBarKey ;

  ProfilePage({this.appBarKey, super.key});

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  double width = double.infinity;
  final CallFunction callFuntion = CallFunction();

  @override
  void initState() {
    // TODO: implement initState
    initStartup();
    super.initState();
  }
  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    
  }

  void initStartup()
  {
    List<Widget> action = [];
    if(mounted)
    {
      if (widget.appBarKey?.currentState != null) 
    {
      (widget.appBarKey?.currentState as AppBarCustomState ).clearAll();
      // (widget.appBarKey?.currentState as AppBarCustomState ).updateTitle("Hồ sơ");
      (widget.appBarKey?.currentState as AppBarCustomState ).updateAction(action);
      (widget.appBarKey?.currentState as AppBarCustomState ).updateColor(Color.fromARGB(244, 230, 88, 142));
                         
    }
    }
  }

  Future<void> _refreshPage() async
  {
    callFuntion.refreshWidget();

  }

  @override
  Widget build(BuildContext context) {
    return  Container(
      color: Color.fromARGB(255, 214, 208, 211),
      child: SingleChildScrollView(
            child: Column(
              children: [
                Header(width: width, callFunction: callFuntion),
                Body( onChange: (value) {
                  if(value["type"] == "refresh")
                  {
                    callFuntion.refreshWidget();
                  }                 
      
                },)
              ],
            ),
          ),
    )
      ;
  }
}


