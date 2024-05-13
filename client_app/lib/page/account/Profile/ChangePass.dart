import 'package:client_app/apiservices/accountAPI.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AlertChangePass extends StatefulWidget {
  const AlertChangePass({super.key});

  @override
  State<AlertChangePass> createState() => _AlertChangePassState();
}

class _AlertChangePassState extends State<AlertChangePass> {
  var oldController = TextEditingController();
  var newController = TextEditingController();
  var confirmController = TextEditingController();
  var key = GlobalKey<FormState>();
  var ErrorMess = "";
  
  bool isWaiting = false;
  bool hideOld = true;
  bool hideNew = true;

  void saveEvent() async
  {
    if(isWaiting) return;

    if(key.currentState?.validate() ?? false)
    {
      var oldp = oldController.text;
      var newp = newController.text;
      var confirm = confirmController.text;
      
      setState(() {       
        isWaiting = true;
      });

      setState(() {
        isWaiting = false;
      });

      var res = await AccountAPI.changePass(oldPass: oldp, newPass: newp);     
      

      if(res['success'] == true)
      {            
        // ScaffoldMessenger.of(context).clearSnackBars();
        // ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(res['message'])));

        Navigator.of(context).pop(true);  
      }
      else
      {
        setState(() {
          ErrorMess = res['message'];
        });
  
      }
    }
  }


  @override
  Widget build(BuildContext context) {
    return AlertDialog(
          backgroundColor: const Color.fromARGB(255, 250, 237, 241),
          actionsAlignment: MainAxisAlignment.center,
          title: const Text('Đổi mật khẩu', textAlign: TextAlign.center,style: TextStyle( fontFamily: "SanProBold", )),
          content: Form(
            key: key,
            child: SingleChildScrollView(
              child: Column(
                children: [   
                  // old pass          
                  Container(
                    padding: const EdgeInsets.only(top: 10),
                    height: 80,
                    child: TextFormField(
                      obscureText: hideOld,
                      autovalidateMode: AutovalidateMode.onUserInteraction,
                      validator: (value) {
                        if(value == null || value.isEmpty)
                        {
                          return "Vui lòng nhập mật khẩu cũ";
                        }                     
                        return null;
                      },      
                      controller: oldController,
                      maxLength: 20,   
                      textAlign: TextAlign.center,       
                      decoration: InputDecoration(  
                        counterText: "",
                        floatingLabelAlignment: FloatingLabelAlignment.center,
                        focusedBorder:  OutlineInputBorder(                        
                          borderRadius: BorderRadius.circular( 50), 
                          borderSide:const BorderSide(color: Color.fromARGB(255, 185, 115, 139))
                        ),                      
                        border: OutlineInputBorder(    
                          borderSide:const BorderSide(color: Colors.pink),
                          borderRadius: BorderRadius.circular(50),
                        ),
                        label: const Text("Mật khẩu cũ", textAlign: TextAlign.end, style: TextStyle(fontFamily: "SanPro", fontSize: 16, fontWeight: FontWeight.w500,color: Colors.black)),
                        suffixIcon: IconButton(onPressed: () {
                          setState(() {
                            hideOld = !hideOld;
                          });
                        }, icon: Icon(hideOld? Icons.visibility : Icons.visibility_off),)
                      ),
                    ),
                  ),
              
                  // New pass
                  Container(
                    padding: EdgeInsets.only(top: 10),
                    height: 80,
                    child: TextFormField(
                      obscureText: hideNew,
                      autovalidateMode: AutovalidateMode.onUserInteraction,
                      validator: (value) {
                        if(value == null || value.isEmpty)
                        {
                          return "Vui lòng nhập mật khẩu mới";
                        }
                        else if(value == oldController.text)
                        {
                          return "Trùng mật khẩu cũ";
                        }
                        else if(value.length < 5)
                        {
                          return "Ít nhất 5 ký tự";
                        }
                        return null;
                      },    
                      controller: newController,
                      maxLength: 20,
                      textAlign: TextAlign.center,                    
                      decoration: InputDecoration(  
                        counterText: "",
                        floatingLabelAlignment: FloatingLabelAlignment.center,
                        focusedBorder:  OutlineInputBorder(                        
                          borderRadius: BorderRadius.circular(50), 
                          borderSide:const BorderSide(color: Color.fromARGB(255, 185, 115, 139))
                        ),                      
                        border: OutlineInputBorder(    
                          borderSide:const BorderSide(color: Colors.pink),
                          borderRadius: BorderRadius.circular(50),
                        ),
                        label:const Text("Mật khẩu mới", textAlign: TextAlign.end, style: TextStyle(fontFamily: "SanPro", fontSize: 16, fontWeight: FontWeight.w500,color: Colors.black)),
                        suffixIcon: IconButton(onPressed: () {
                          setState(() {
                            hideNew = !hideNew;
                          });
                        }, icon: Icon(hideNew? Icons.visibility : Icons.visibility_off),)
                      ),
                    ),
                  ),
              
                  // Confirm
                  Container(
                    padding: const EdgeInsets.only(top: 10),
                    height: 80,
                    child: TextFormField(  
                      obscureText: hideNew,
                      autovalidateMode: AutovalidateMode.onUserInteraction,
                      validator: (value) {
                        if(value == null || value.isEmpty)
                        {
                          return "Vui lòng nhập xác nhận mật khẩu";
                        }
                        else if(value != newController.text)
                        {
                          return "Mật khẩu mới không khớp";
                        }
                        return null;
                      }, 
                      controller: confirmController,
                      maxLength: 20,
                      textAlign: TextAlign.center,                    
                      decoration: InputDecoration(  
                        counterText: "",
                        floatingLabelAlignment: FloatingLabelAlignment.center,
                        focusedBorder:  OutlineInputBorder(                        
                          borderRadius: BorderRadius.circular(50), 
                          borderSide: const BorderSide(color:  Color.fromARGB(255, 185, 115, 139))
                        ),                      
                        border: OutlineInputBorder(    
                          borderSide: const BorderSide(color: Colors.pink),
                          borderRadius: BorderRadius.circular(50),
                        ),
                        label: const Text("Xác nhận", textAlign: TextAlign.end, style: TextStyle(fontFamily: "SanPro", fontSize: 16, fontWeight: FontWeight.w500,color: Colors.black)),
                        suffixIcon: IconButton(onPressed: () {
                          setState(() {
                            hideNew = !hideNew;
                          });
                        }, icon: Icon(hideNew? Icons.visibility : Icons.visibility_off),)
                        
                      ),
                    ),
                  ),
                  SizedBox(height: 5,),
                  if(isWaiting) CircularProgressIndicator(color: Colors.pink,),
                  if(ErrorMess != "" ) Text(ErrorMess,softWrap: true, style:const TextStyle(fontFamily: "SanPro", fontSize: 16, fontWeight: FontWeight.w500,color: Colors.red),),
                      
                ],
              ),
            ),
          ),
          actions: [
            TextButton(
              child:const Text('Thoát', style: TextStyle(fontFamily: "SanProBold", fontSize: 16, fontWeight: FontWeight.w500,color: Colors.black)),
              onPressed: () => Navigator.of(context).pop(false),
            ),
            TextButton(
              onPressed: saveEvent,
              child: const  Text('Lưu', style: TextStyle(fontFamily: "SanProBold", fontSize: 16, fontWeight: FontWeight.w500, color: Colors.black)),
            ),
          ],
        );
  }
}