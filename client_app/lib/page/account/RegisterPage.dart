import 'dart:convert';
import 'dart:ui';
import 'package:client_app/apiservices/accountAPI.dart';
import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:shared_preferences/shared_preferences.dart';

const KEY_LOGIN = "quizlet-login";

class RegisterPage extends StatefulWidget {

  RegisterPage({ super.key});

  

  @override
  State<RegisterPage> createState() => _RegisterPageState();

}

class _RegisterPageState extends State<RegisterPage> {
  SharedPreferences? pref;
  bool isWaiting = false;
  bool isShow = false;
  String user = "";
  String password ="";
  String confirmpass ="";
  String ErrorMessage = "";
  var userController = TextEditingController();
  var passController = TextEditingController();
  var confirmController = TextEditingController();
  var formKey = GlobalKey<FormState>();

  @override
  void initState() {
    // TODO: implement initState
    super.initState();

  }


  void registerEvent() async {
    if(isWaiting) return;
    user = userController.text;
    password = passController.text;
    confirmpass = confirmController.text;
    if(user.isEmpty || user == "" )
    {
      setState(() {
        ErrorMessage = "Vui lòng nhập email";
      });
    }
    else if(password.isEmpty || password == "")
    {
      setState(() {
        ErrorMessage = "Vui lòng nhập mật khẩu";
      });
    }
    else if(confirmpass == "")
    {
      setState(() {
        ErrorMessage = "Vui lòng nhập xác nhận mật khẩu";
      });
    }
    else if(confirmpass != password)
    {
      setState(() {
        ErrorMessage = "Mật khẩu không khớp";
      });
    }
    else
    {
      formKey.currentState?.save();
      setState(() {
        isWaiting = true;
      });
      

      var res = await AccountAPI.register(email: user, password: password);     
      
      setState(() {
        isWaiting = false;
      });

      if(res['success'] == true)
      {
       
        var obj = jsonEncode({"user": user, "pass": password});
        
        Navigator.pushNamedAndRemoveUntil(context, '/account/login', (Route<dynamic> route) => false, arguments: obj);
      }
      else
      {
        setState(() {
          ErrorMessage = res['message'];
        });
  
      }
    }
  }
  
  void toLogin()
  {
    Navigator.pushNamedAndRemoveUntil(context, '/account/login', (Route<dynamic> route) => false);
  }

  void toForgotPass()
  {
    Navigator.pushNamedAndRemoveUntil(context, '/account/forgot', (Route<dynamic> route) => false);

  }
  
  @override
  Widget build(BuildContext context) {
    return  Scaffold(  
      // backgroundColor:  Color.fromARGB(255, 227, 229, 231), 
      body: SafeArea(
        child: Container(
          decoration: const BoxDecoration(
            gradient:  LinearGradient(colors: [
                                Color.fromARGB(220, 233, 117, 165),
                                Color.fromARGB(244, 238, 143, 202),                           
                                Color.fromARGB(249, 226, 107, 157),
                              ])
          ),
          child: Center(        
            child: Container(
              decoration:const BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.all(Radius.circular(20))
              ),
              constraints: BoxConstraints(maxWidth: 380, maxHeight: 650),
              padding: EdgeInsets.all(15),
              child: SingleChildScrollView(
                child: Form(
                  key: formKey,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Text(
                        "Register",
                         style: TextStyle(fontFamily: 'Prompt', fontSize: 30)
                      ),
                      const SizedBox(
                        height: 20,
                      ),
                    
                      // User box
                      Container(
                        padding: EdgeInsets.only(left: 30, bottom: 2),
                        decoration: BoxDecoration(
                            color: Colors.grey[200],
                            borderRadius: BorderRadius.all(Radius.circular(10))),
                        child: TextFormField(
                          keyboardType: TextInputType.emailAddress,
                          controller: userController,                       
                          onChanged: (value) => setState(() {
                            ErrorMessage = "";
                          }),
                          onSaved: (newValue) => setState(() {
                            user = newValue ?? "";
                          }),
                          style: TextStyle(color: Colors.red[700]),
                          decoration: const InputDecoration(                       
                            border: InputBorder.none,
                            prefixIcon: Icon(
                              Icons.email,
                              color: Colors.black54,
                            ),
                            label: Text("Email"),
                            labelStyle: TextStyle(color: Colors.grey, fontSize: 12,),
                          ),
                          
                        ),
                      ),
                      const SizedBox(
                        height: 8,
                      ),
                    
                      // Password box
                      Container(
                        padding: EdgeInsets.only(left: 30, bottom: 2),
                        decoration: BoxDecoration(
                            color: Colors.grey[200],
                            borderRadius: BorderRadius.all(Radius.circular(10))),
                        child: TextFormField(     
                          maxLength: 20,
                          controller: passController,                 
                          onChanged: (value) => setState(() {
                            ErrorMessage = "";
                          }),                   
                          onSaved: (newValue) => setState(() {
                              password = newValue ?? "";
                          }),
                          obscureText: !isShow,
                          style: TextStyle(color: Colors.grey[700]),
                          decoration: InputDecoration(
                              border: InputBorder.none,
                              prefixIcon:const Icon(
                                Icons.lock,
                                color: Colors.black54,
                              ),
                              label: Text("Password"),
                              labelStyle: TextStyle(color: Colors.grey, fontSize: 12),
                              suffixIcon: IconButton(
                                  onPressed: () {
                                    setState(() {
                                      isShow = !isShow;
                                    });
                                  },
                                  icon: Icon(
                                      isShow ? Icons.visibility_off : Icons.visibility, color: Colors.grey[400],))),
                        ),
                      ),
                      const SizedBox(
                        height: 8,
                      ),
        
                      // Confirm password
                      Container(
                        padding: EdgeInsets.only(left: 30, bottom: 2),
                        decoration: BoxDecoration(
                            color: Colors.grey[200],
                            borderRadius: BorderRadius.all(Radius.circular(10))),
                        child: TextFormField(     
                          controller: confirmController,                 
                          onChanged: (value) => setState(() {
                            ErrorMessage = "";
                          }),                   
                          onSaved: (newValue) => setState(() {
                              confirmpass = newValue ?? "";
                          }),
                          obscureText: !isShow,
                          style: TextStyle(color: Colors.grey[700]),
                          decoration: InputDecoration(
                              border: InputBorder.none,
                              prefixIcon:const Icon(
                                Icons.lock,
                                color: Colors.black54,
                              ),
                              label: Text("Confirm"),
                              labelStyle: TextStyle(color: Colors.grey, fontSize: 12),
                              suffixIcon: IconButton(
                                  onPressed: () {
                                    setState(() {
                                      isShow = !isShow;
                                    });
                                  },
                                  icon: Icon(
                                      isShow ? Icons.visibility_off : Icons.visibility, color: Colors.grey[400],))),
                        ),
                      ),
                      const SizedBox(
                        height: 5,
                      ),
        
                      if(ErrorMessage != "") Text(ErrorMessage, style: TextStyle(color: Colors.red)),
                      const SizedBox(
                        height: 15,
                      ),
                    
                      // Button login
                      Material(                   
                        child: InkWell(    
                          onTap: registerEvent,
                          child: Container(                          
                            height: 50,
                            alignment: Alignment.center,
                            decoration:const BoxDecoration(                            
                                borderRadius: BorderRadius.all(Radius.circular(10)),
                                gradient: LinearGradient(colors: [
                                  Color.fromARGB(167, 166, 246, 255),
                                  Color.fromARGB(153, 201, 248, 230),
                                  Color.fromARGB(169, 166, 246, 255),
                                ])),
                            width: double.infinity,
                            child: isWaiting ? CircularProgressIndicator() : Text("Gửi", style: TextStyle(color: Colors.black, fontSize: 15, fontWeight: FontWeight.bold),),
                          ),
                        ),
                      ),
                      const SizedBox(
                        height: 10,
                      ),
                      
                      // Other options
                      const Text("hoặc", style: TextStyle( fontSize: 12, )),
                      const SizedBox(
                        height: 3,
                      ),
                      TextButton(onPressed: toLogin, child:const Text("Đăng Nhập",  style: TextStyle(color: Color.fromARGB(171, 18, 141, 241), fontSize: 12, ),)),
                     
                      TextButton(onPressed: toForgotPass, child:const Text("Quên Mật Khẩu",  style: TextStyle(color: Color.fromARGB(255, 189, 11, 115), fontSize: 12, ),)),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    )
    ;
  
  }
}
