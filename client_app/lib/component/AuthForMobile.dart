import 'dart:convert';

import 'package:client_app/apiservices/accountAPI.dart';
import 'package:client_app/component/AppBarCustom.dart';
import 'package:client_app/component/BottomNav.dart';
import 'package:client_app/modules/ColorsApp.dart';
import 'package:client_app/modules/callFunction.dart';
import 'package:client_app/page/RecentStudy/RecentStudyPage.dart';
import 'package:client_app/page/account/LoginPage.dart';
import 'package:client_app/page/account/ProfilePage.dart';
import 'package:client_app/page/home/Home.dart';
import 'package:client_app/page/library/LibraryPage.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
const KEY_LOGIN = "quizlet-login";

class AuthForMoblie extends StatefulWidget {
  const AuthForMoblie({super.key});

  @override
  State<AuthForMoblie> createState() => _AuthForMoblieState();
}

class _AuthForMoblieState extends State<AuthForMoblie> {
  var _controller = PageController();
  final CallFunction callFuntion = CallFunction();
  int currentIndex = 0;
  final GlobalKey<AppBarCustomState> appBarKey = GlobalKey<AppBarCustomState>();

  @override
  void initState() {
    // TODO: implement initState
    initStartup();
    super.initState();
  }

  @override
  void dispose() {
    // TODO: implement dispose
    _controller.dispose();
    super.dispose();
  }

  void initStartup() async
  {
    var i = await CheckLogin();
    if(!i)
    {
      Navigator.pushNamedAndRemoveUntil(context, '/account/login', (route) => false);
    }

  }
  Widget _buildPage(index)
  {

    switch(index)
    {
      case 1:
        return RecentStudyPage();
      case 2:
        return  LibraryPage(appBarKey: appBarKey);
      case 3:
        return ProfilePage(appBarKey: appBarKey);
      default: 
        return Home(appBarKey: appBarKey);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(

          appBar: new AppBarCustom(key: appBarKey),
          bottomNavigationBar: BottomNav(indexBottom: currentIndex, pageController: _controller, callFunction: callFuntion),
          body: PageView.builder(            
            onPageChanged: (value) {
             
              setState(() {
                currentIndex = value;
                callFuntion.updateIndex(value);
              });
            },
              controller: _controller,
              itemCount:  4,
              itemBuilder: (context, index) => 
                Container(
                  // height: double.infinity,
                  decoration:  BoxDecoration(
                    // gradient:  
                    // LinearGradient(
                    //   transform:  GradientRotation(14),
                    //   colors: [
                    //     Color.fromARGB(202, 96, 125, 139),
                    //     Color.fromARGB(192, 96, 125, 139),
                    //     Color.fromARGB(179, 96, 125, 139),
                    //   ]
                    // )
                    color: AppColors.background
                  ),
                  child: _buildPage(index),
                )
            ),
        );
  }
}

Future<bool> CheckLogin() async 
{
  try
  {

  // await Future.delayed(Duration(seconds: 1));
    var pref = await SharedPreferences.getInstance();
    String? token = pref.getString(KEY_LOGIN);
    if(token == null) return false;
    // your logic here 
    // Check token with API
    var res = await AccountAPI.isAuth(token: token);   

    if(res['success'] == true) 
    {
      var account =  jsonEncode( res['account']) ?? "";
      pref?.setString("Account", account);
      return true;
    }
  }
  catch(err)
  {
    print("error when handle Check Login - Main: \n$err" );
  }
 
  return false;
}


