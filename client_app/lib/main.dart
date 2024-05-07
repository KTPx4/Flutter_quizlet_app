
import 'dart:convert';

import 'package:client_app/page/404/NotFoundPage.dart';
import 'package:client_app/page/account/ForgotPage.dart';
import 'package:client_app/page/account/LoginPage.dart';
import 'package:client_app/page/Test.dart';
import 'package:client_app/page/account/ProfilePage.dart';
import 'package:client_app/page/account/RegisterPage.dart';
// import 'package:client_app/page/account/ScreenAuth.dart';
import 'package:client_app/page/page1.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

import 'package:shared_preferences/shared_preferences.dart';

import 'apiservices/accountAPI.dart';
import 'pages/landing_page.dart';
// import 'package:flutter/foundation.dart' show kIsWeb;
// ignore: unused_import
// import './middleware/MobilePlatform.dart' 
//   if (kIsWeb ) './middleware/WebPlatform.dart' ;

const KEY_LOGIN = "quizlet-login";



void main() {
  // PlatformRun pl;
  // if(kIsWeb){
  //   pl = WebPlatform();
  //   // setUrlStrategy(PathUrlStrategy());
  //   pl.main();
  // }

  runApp(MyApp());
}

class MyApp extends StatefulWidget {
  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      
      debugShowCheckedModeBanner: false,
      title: 'Quizlet',       
      initialRoute: '/',
       onGenerateRoute: (settings) {

        var args = settings.arguments;
        var name = settings.name;
        
        switch(name)
        {
          case "/": 
            return MaterialPageRoute(builder: (bd)=> AuthPage(page: ProfilePage(),));
          case "/account/register":
            return MaterialPageRoute(builder: (bd)=> canRegister(page: const TestPage(),));
          case "/account/forgot":
            return MaterialPageRoute(builder: (bd)=> canForgot(page: const TestPage(),));           
          
          case "/account/login":
            return MaterialPageRoute(builder: (bd)=> canLogin(page: const TestPage(), args: args));
          case "/page1": 
            return MaterialPageRoute(builder: (bd)=> AuthPage(page: const Page1(), path: "/page1"));
          default:
            return MaterialPageRoute(builder: (bd)=> const NotFoundPage());

        }

      },
    );
  }
}

FutureBuilder canForgot({page, path = "/", args = ""})
{
  return FutureBuilder(
    future: CheckLogin(), 
    builder: (context, snapshot) {
      if(snapshot.connectionState == ConnectionState.waiting)
      {
        return const Scaffold(
                  body: Center(child: CircularProgressIndicator()),
        );
      }
      else
      {
        if(snapshot.data) // login -> home
        {
          return page;
        }
        else
        {
          return ForgotPage();
        } 
      }
    },
  );
}

FutureBuilder canLogin({page, path = "/", args = ""})
{
  return FutureBuilder(
    future: CheckLogin(), 
    builder: (context, snapshot) {
      if(snapshot.connectionState == ConnectionState.waiting)
      {
        return const Scaffold(
                  body: Center(child: CircularProgressIndicator()),
        );
      }
      else
      {
        if(snapshot.data) // login -> home
        {
          return page;
        }
        else
        {
          return LoginPage(pathPage: "/", args: args,);
        } 
      }
    },
  );
}

FutureBuilder canRegister({page, path = "/"})
{
  return FutureBuilder(
    future: CheckLogin(), 
    builder: (context, snapshot) {
      if(snapshot.connectionState == ConnectionState.waiting)
      {
        return const Scaffold(
                  body: Center(child: CircularProgressIndicator()),
        );
      }
      else
      {
        if(snapshot.data) // login -> home
        {
          return page;
        }
        else
        {
          return RegisterPage();
        } 
      }
    },
  );
}

FutureBuilder AuthPage({page, path = "/"})
{
  return FutureBuilder(
    future: CheckLogin(), 
    builder: (context, snapshot) {
      if(snapshot.connectionState == ConnectionState.waiting)
      {
        return const Scaffold(
                  body: Center(child: CircularProgressIndicator()),
        );
      }
      else
      {
        if(snapshot.data)
        {
          return page;
        }
        else
        {
          return LoginPage(pathPage: path,);
        } 
      }
    },
  );
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


