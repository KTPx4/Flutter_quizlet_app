import 'dart:convert';
import 'dart:developer';
import 'package:client_app/apiservices/accountAPI.dart';
import 'package:client_app/component/AppBarCustom.dart';
import 'package:client_app/component/BottomNav.dart';
import 'package:client_app/models/meaning.dart';
import 'package:client_app/models/word.dart';
import 'package:client_app/modules/ColorsApp.dart';
import 'package:client_app/modules/callFunction.dart';
import 'package:client_app/page/RecentStudy/RecentStudyPage.dart';
import 'package:client_app/page/account/LoginPage.dart';
import 'package:client_app/page/account/ProfilePage.dart';
import 'package:client_app/page/home/Home.dart';
import 'package:client_app/page/library/LibraryPage.dart';
import 'package:client_app/pages/quiz_page.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
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
  late PageController _controller;
  final CallFunction callFuntion = CallFunction();
  int currentIndex = 0;
  final GlobalKey<AppBarCustomState> appBarKey = GlobalKey<AppBarCustomState>();

  @override
  void initState() {
    _controller = PageController(initialPage: currentIndex);
    super.initState();
    initFirt();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  Future<void> initStartup() async {
    var i = await CheckLogin(context);
    if (!i) {
      Navigator.pushNamedAndRemoveUntil(
          context, '/account/login', (route) => false);
    }
  }

  void initFirt() async {
    var pref = await SharedPreferences.getInstance();
    String? token = pref.getString(KEY_LOGIN);

    if (token == null || token == "") {
      Navigator.pushNamedAndRemoveUntil(
          context, '/account/login', (route) => false);
    }

    var i = await CheckLogin(context);
    
    if (!i) {
      Navigator.pushNamedAndRemoveUntil(
          context, '/account/login', (route) => false);
    }   

  }

  Widget _buildPage(
    int index,
  ) {
    switch (index) {
      case 1:
        return RecentStudyPage(appBarKey: appBarKey);
      case 2:
        return LibraryPage(appBarKey: appBarKey);
      case 3:
        // return Home(appBarKey: appBarKey);
        return ProfilePage(appBarKey: appBarKey);
      default:
        return Home(appBarKey: appBarKey);
        // return ProfilePage(appBarKey: appBarKey);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBarCustom(key: appBarKey),
      bottomNavigationBar: BottomNav(
          indexBottom: currentIndex,
          pageController: _controller,
          callFunction: callFuntion),
      body: PageView.builder(
        physics: NeverScrollableScrollPhysics(),
        onPageChanged: (value) {
   
          setState(() {
            // currentIndex = value ;
            // callFuntion.updateIndex(value);
          });
        },
        controller: _controller,
        itemCount: 4,
        itemBuilder: (context, index) => Container(
            decoration: BoxDecoration(
              color: AppColors.background,
            ),
            child: _buildPage(index)
            ),
      ));
  }
    
  Future<bool> CheckLogin(context) async {
    try {
      var pref = await SharedPreferences.getInstance();
      String? token = pref.getString(KEY_LOGIN);

      if (token == null) return false;

      var res = await AccountAPI.isAuth(token: token);

      if (res['success'] == true) {
        var account = jsonEncode(res['account']) ?? "";
        pref.setString("Account", account);
        return true;
      } else if (res['success'] == false && res["notConnect"] == false) {
        Navigator.pushNamedAndRemoveUntil(
            context, '/account/login', (route) => false);
        ScaffoldMessenger.of(context).clearSnackBars();
        ScaffoldMessenger.of(context)
            .showSnackBar(SnackBar(content: Text(res['message'])));
      }
    } catch (err) {
      print("error when handle Check Login - Main: \n$err");
    }

    return true;
  }
}
