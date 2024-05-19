import 'dart:convert';
import 'dart:ui';
import 'package:client_app/apiservices/accountAPI.dart';
import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:shared_preferences/shared_preferences.dart';

const KEY_LOGIN = "quizlet-login";

class LoginPage extends StatefulWidget {
  String? pathPage;
  String? args;
  LoginPage({required this.pathPage, this.args = "", super.key});

  

  @override
  State<LoginPage> createState() => _LoginPageState();

}

class _LoginPageState extends State<LoginPage> {
  SharedPreferences? pref;
  bool isWaiting = false;
  bool isShow = false;
  String user = "";
  String password ="";
  String ErrorMessage = "";
  var userController = TextEditingController();
  var passController = TextEditingController();
  var formKey = GlobalKey<FormState>();

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    initSharedPref();
    initInput();
  }
  void initSharedPref() async
  {
    pref = await SharedPreferences.getInstance();
  }

  void initInput()
  {
    if(widget.args == null || widget.args == "")  return;

    var obj = jsonDecode(widget.args!);
    userController.text = obj["user"];
    passController.text = obj["pass"];

  }


  void loginEvent() async {
    if(isWaiting) return;
    user = userController.text;
    password = passController.text;
    
    if(user.isEmpty || user == "")
    {
      setState(() {
        ErrorMessage = "Vui lòng nhập User hoặc Email";
      });
    }
    else if(password.isEmpty || password == "")
    {
      setState(() {
        ErrorMessage = "Vui lòng nhập password";
      });
    }
    else
    {
      formKey.currentState?.save();

      setState(() {
        isWaiting = true;
      });


      var res = await AccountAPI.login( user: user, password: password);     
      
      setState(() {
        isWaiting = false;
      });

      if(res['success'] == true)
      {
        var token = res['token'] ;

        if(token != null)
        {
          pref?.setString(KEY_LOGIN, token);
        }
        
        Navigator.pushNamedAndRemoveUntil(context, widget.pathPage ?? "/", (route) =>  false,);
      }
      else
      {
        setState(() {
          ErrorMessage = res['message'];
        });
  
      }
    }
  }

  void toRegister()
  {
    Navigator.pushNamedAndRemoveUntil(context, '/account/register', (Route<dynamic> route) => false);
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
                                Color.fromARGB(255, 129, 194, 194),
                                Color.fromARGB(255, 166, 215, 228),
                                Color.fromARGB(255, 200, 240, 247),
        
                                //         Color.fromARGB(255, 227, 244, 244),
                                // Color.fromARGB(255, 191, 234, 245),
                                // Color.fromARGB(255, 223, 246, 255),
                              ])
          ),
          child: Center(        
            child: Container(
              decoration:const BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.all(Radius.circular(20))
              ),
              constraints: BoxConstraints(maxWidth: 380, maxHeight: 450),
              padding: EdgeInsets.all(15),
              child: SingleChildScrollView(
                child: Form(
                  key: formKey,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Text(
                        "Login",
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
                         textInputAction: TextInputAction.next,
                          keyboardType: TextInputType.emailAddress,
                          controller: userController,                       
                          onChanged: (value) => setState(() {
                            ErrorMessage = "";
                          }),
                          onSaved: (newValue) => setState(() {
                            user = newValue ?? "";
                          }),
                          style: TextStyle(color: Colors.grey[700]),
                          decoration: const InputDecoration( 
                                                    
                            border: InputBorder.none,
                            prefixIcon: Icon(
                              Icons.person,
                              color: Colors.black54,
                            ),
                            label: Text("User"),
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
                              label: Text("Mật khẩu"),
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
                          onTap: loginEvent,
                          child: Container(                          
                            height: 50,
                            alignment: Alignment.center,
                            decoration:const BoxDecoration(                            
                                borderRadius: BorderRadius.all(Radius.circular(10)),
                                gradient: LinearGradient(colors: [
                                  Color.fromARGB(255, 251, 154, 209),
                                  Color.fromARGB(255, 255, 205, 234),
                                  Color.fromARGB(255, 229, 212, 255),
                                ])),
                            width: double.infinity,
                            child: isWaiting ? CircularProgressIndicator() : Text("Đăng Nhập", style: TextStyle(color: Colors.black, fontSize: 15, fontWeight: FontWeight.bold),),
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

                      TextButton(onPressed: toRegister, child:const Text("Đăng Ký",  style: TextStyle(color: Color.fromARGB(171, 18, 141, 241), fontSize: 12, ),)),
                     
                      TextButton(onPressed: toForgotPass, child:const Text("Quên Mật Khẩu",  style: TextStyle(color: Color.fromARGB(255, 216, 17, 133), fontSize: 12, ),)),
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
