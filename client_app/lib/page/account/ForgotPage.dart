import 'dart:convert';
import 'dart:ui';
import 'package:client_app/apiservices/accountAPI.dart';
import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:mask_text_input_formatter/mask_text_input_formatter.dart';
import 'package:shared_preferences/shared_preferences.dart';

const KEY_LOGIN = "quizlet-login";


class ForgotPage extends StatefulWidget {

  ForgotPage({ super.key});

  

  @override
  State<ForgotPage> createState() => _ForgotPageState();

}

class _ForgotPageState extends State<ForgotPage> {
  SharedPreferences? pref;
  bool isWaiting = false;
  bool isShow = false;
  String user = "";
  String password ="";
  String confirmpass ="";
  String ErrorMessage = "";
  String token = "";

  bool isInputCode = false;
  bool isInputPass = false;

  var userController = TextEditingController();
  final codeController = TextEditingController();
  var passController = TextEditingController();
  var confirmController = TextEditingController();
  var formKey = GlobalKey<FormState>();

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    
  }


  void requestCode() async {
    if(isWaiting) return;

    // first - input email
    user = userController.text;
      
    if(user.isEmpty || user == "" )
    {
      setState(() {
        ErrorMessage = "Vui lòng nhập email";
      });
      return;
    }   

    formKey.currentState?.save();
    setState(() {
      isWaiting = true;
    });
    
    await Future.delayed(Duration(seconds: 1));

    var res = await AccountAPI.getCode(email: user);     
    
    setState(() {
      isWaiting = false;
    });

    if(res['success'] == true)
    {
      ScaffoldMessenger.of(context).clearSnackBars();
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(res['message'])));

      setState(() {
        isInputCode = true;
      });
      
    }
    else
    {
      setState(() {
        ErrorMessage = res['message'];
      });

    }

  }
  
  void sendCode() async
  {
    if(isWaiting) return;
    var code = codeController.text.replaceAll(' ', '');
    if(code.length != 4)
    {
      setState(() {
        ErrorMessage = "Vui lòng nhập đúng code";
      });
      return;
    }

    setState(() {
      isWaiting = true;
    });
    await Future.delayed(Duration(seconds: 1));

    var res = await AccountAPI.sendCode(email: user, code: code);     
  
    setState(() {
      isWaiting = false;
    });

    if(res['success'] == true)
    {
      ScaffoldMessenger.of(context).clearSnackBars();
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(res['message'])));

      setState(() {
        isInputPass = true;
        token = res['token'] ;
      });
      
    }
    else
    {
      setState(() {
        ErrorMessage = res['message'];
      });
    }

  }

  void changePass() async
  {
    if(isWaiting) return;

    password = passController.text;
    confirmpass = confirmController.text;

    if(password.isEmpty || password == "")
    {
      setState(() {
        ErrorMessage = "Vui lòng nhập mật khẩu";
      });
      return;
    }
    else if(confirmpass == "")
    {
      setState(() {
        ErrorMessage = "Vui lòng nhập xác nhận mật khẩu";
      });
      return;
    }
    else if(confirmpass != password)
    {
      setState(() {
        ErrorMessage = "Mật khẩu không khớp";
      });
      return;
    }

    setState(() {
      isWaiting = true;
    });
    await Future.delayed(Duration(seconds: 1));

    var res = await AccountAPI.ResetPass(token: token, newPass: password);     
  
    setState(() {
      isWaiting = false;
    });

    if(res['success'] == true)
    {
      ScaffoldMessenger.of(context).clearSnackBars();
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(res['message'])));

      setState(() {
        isInputPass = true;
        token = res['token'] ;
      });
      
    }
    else
    {
      setState(() {
        ErrorMessage = res['message'];
      });
    }


  }

  void toLogin()
  {
    Navigator.pushNamedAndRemoveUntil(context, '/account/login', (Route<dynamic> route) => false);
  }

  void toRegister()
  {
    Navigator.pushNamedAndRemoveUntil(context, '/account/register', (Route<dynamic> route) => false);

  }

  var maskFormatter = MaskTextInputFormatter(mask: 'X X X X', filter: { "X": RegExp(r'[0-9]') });
  
  List<Widget> inputNewPass()
  {
    return  [Container(
            padding: EdgeInsets.only(left: 30, bottom: 2),
            decoration: BoxDecoration(
                color: Colors.grey[200],
                borderRadius: BorderRadius.all(Radius.circular(10))),
            child: TextFormField(     
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
          ),];
        
  }

  @override
  Widget build(BuildContext context) {
    return  Scaffold(  
      // backgroundColor:  Color.fromARGB(255, 227, 229, 231), 
      body: SafeArea(
        child: Container(
          decoration: const BoxDecoration(
            gradient:  LinearGradient(transform: GradientRotation(90),colors: [
                                Color.fromARGB(220, 150, 121, 255),
                                Color.fromARGB(244, 141, 149, 255),                           
                                Color.fromARGB(248, 80, 168, 226),
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
                        "Reset Password",
                         style: TextStyle(fontFamily: 'Prompt', fontSize: 30)
                      ),
                      const SizedBox(
                        height: 20,
                      ),
                    
                      // User box
                      if(!isInputCode && !isInputPass) Container(                        
                        padding: EdgeInsets.only(left: 30, bottom: 2),
                        decoration: BoxDecoration(
                            color: isInputCode ? Colors.grey[350] : Colors.grey[200],
                            borderRadius: BorderRadius.all(Radius.circular(10))),
                        child: TextFormField(
                          enabled: !isInputCode,
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

                      // input code
                      if(isInputCode && !isInputPass) Container(                        
                        padding: EdgeInsets.only(left: 30, bottom: 2),
                        decoration: BoxDecoration(
                            color: Colors.grey[200],
                            borderRadius: BorderRadius.all(Radius.circular(10))),
                        child: TextFormField(
                          inputFormatters: [maskFormatter],
                          keyboardType: TextInputType.number,
                          controller: codeController,                       
                          onChanged: (value) => setState(() {
                            ErrorMessage = "";
                          }),
                          onSaved: (newValue) => setState(() {
                            user = newValue ?? "";
                          }),
                          style: TextStyle(color: Colors.red[700]),
                          decoration: const InputDecoration(   
                            hintText: "X X X X",                   
                            border: InputBorder.none,
                            prefixIcon: Icon(
                              Icons.numbers,
                              color: Colors.black54,
                            ),
                          
                            labelStyle: TextStyle(color: Colors.grey, fontSize: 12,),
                          ),
                          
                        ),
                      ),
                      
                      // input new password
                      if(isInputPass) 
                        ...inputNewPass(),
                      
                      if(ErrorMessage != "") Text(ErrorMessage, style: TextStyle(color: Colors.red)),
                      const SizedBox(
                        height: 15,
                      ),
                    
                      // Button login
                      Material(                   
                        child: InkWell(    
                          onTap: requestCode,
                          child: Container(                          
                            height: 50,
                            alignment: Alignment.center,
                            decoration:const BoxDecoration(                            
                                borderRadius: BorderRadius.all(Radius.circular(10)),
                                gradient: LinearGradient( transform: GradientRotation(55),colors: [
                                  Color.fromARGB(167, 102, 247, 235),                   
                                  Color.fromARGB(167, 253, 5, 158),                   

                                ])),
                            width: double.infinity,
                            child: isWaiting ? CircularProgressIndicator() : Text("Send", style: TextStyle(color: Colors.black, fontSize: 15, fontWeight: FontWeight.bold),),
                          ),
                        ),
                      ),
                      const SizedBox(
                        height: 10,
                      ),
                      
                      // Other options
                      const Text("or", style: TextStyle( fontSize: 12, )),
                      const SizedBox(
                        height: 3,
                      ),
                      TextButton(onPressed: toLogin, child:const Text("Login",  style: TextStyle(color: Color.fromARGB(171, 18, 141, 241), fontSize: 12, ),)),
                     
                      TextButton(onPressed: toRegister, child:const Text("Register",  style: TextStyle(color: Color.fromARGB(255, 240, 23, 150), fontSize: 12, ),)),
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
