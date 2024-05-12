
import 'dart:convert';
import 'dart:io';
import 'package:client_app/component/AuthForMobile.dart';
import 'package:client_app/component/BottomNav.dart';
import 'package:client_app/component/BuildPage.dart';
import 'package:client_app/modules/callFunction.dart';
import 'package:client_app/page/404/NotFoundPage.dart';
import 'package:client_app/page/RecentStudy/RecentStudyPage.dart';
import 'package:client_app/page/account/ForgotPage.dart';
import 'package:client_app/page/account/LoginPage.dart';
import 'package:client_app/page/account/ProfilePage.dart';
import 'package:client_app/page/account/RegisterPage.dart';
import 'package:client_app/page/home/Home.dart';
import 'package:client_app/page/library/LibraryPage.dart';
import 'package:client_app/pages/home_page.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'apiservices/accountAPI.dart';

const KEY_LOGIN = "quizlet-login";



void main() {
  runApp(MyApp());
}

class MyApp extends StatefulWidget {
  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  bool haveBody = true;

  
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    initPlatform();
  }

  void initPlatform()
  {
    if(kIsWeb )
    {
      haveBody = false;
    }
  }

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
            return MaterialPageRoute(builder: (bd)=> AuthPage(page: HomePage(),));
          case "/account/profile": 
            return MaterialPageRoute(builder: (bd)=> AuthPage(page: ProfilePage(),));
          case "/account/register":
            return MaterialPageRoute(builder: (bd)=> canRegister(page: RegisterPage(),));
          case "/account/forgot":
            return MaterialPageRoute(builder: (bd)=> canForgot(page: ForgotPage(),));           
          
          case "/account/login":
            return MaterialPageRoute(builder: (bd)=> canLogin(page:  LoginPage(pathPage: "/"), args: args));

          default:
            return MaterialPageRoute(builder: (bd)=> const NotFoundPage());

        }

      },
      home: !haveBody ? null :  AuthForMoblie()

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
          return Scaffold(              
            
            body: Container(
              height: double.infinity,
              decoration: const BoxDecoration(gradient:  LinearGradient(
                transform:  GradientRotation(14),
                colors: [
                  Color.fromARGB(202, 96, 125, 139),
                  Color.fromARGB(192, 96, 125, 139),
                  Color.fromARGB(179, 96, 125, 139),
                ]
              )
              ),
            child: SafeArea(child: page),
            )
          );
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


