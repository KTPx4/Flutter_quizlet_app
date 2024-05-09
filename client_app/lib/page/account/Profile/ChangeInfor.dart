import 'package:client_app/apiservices/accountAPI.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:shared_preferences/shared_preferences.dart';


class AlertChangeInfor extends StatefulWidget {
  String typeChange;
  AlertChangeInfor({required this.typeChange, super.key});

  @override
  State<AlertChangeInfor> createState() => _AlertChangeInforState();
}

class _AlertChangeInforState extends State<AlertChangeInfor> {  

  var textController = TextEditingController();  
  var key = GlobalKey<FormState>();

  var ErrorMess = "";
  bool isWaiting = false;
  bool isBlock = false;

  void saveEvent() async
  {
    if(isBlock) return;

    setState(() {
      isBlock = true;
      ErrorMess = "";
    });
    switch(widget.typeChange)
    {
      case "name":
        changeNameEvent();
      case "email":
        changeEmailEvent();
    }
  }

  void changeEmailEvent() async
  {
    if(key.currentState?.validate() ?? false)
    {
      var emailUser = textController.text;      
      
      setState(() {       
        isWaiting = true;
      });

    
      setState(() {
        isWaiting = false;
      });
      print(emailUser);
      var res = await AccountAPI.changeEmail( email: emailUser);     
      

      if(res['success'] == true)
      {            
        // ScaffoldMessenger.of(context).clearSnackBars();
        // ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(res['message'])));

        Navigator.of(context).pop(true);  
      }
      else
      {
        
        setState(() {
          isBlock = false;
          ErrorMess = res['message'];
        });
  
      }
    }
  }

  void changeNameEvent() async
  {
    if(key.currentState?.validate() ?? false)
    {
      var nameUser = textController.text;      
      
      setState(() {       
        isWaiting = true;
      });
      setState(() {
        isWaiting = false;
      });

      var res = await AccountAPI.changeName( name: nameUser);     
      

      if(res['success'] == true)
      {           

        Navigator.of(context).pop(true);  
      }
      else
      {
        setState(() {
          isBlock = false;
          ErrorMess = res['message'];
        });
  
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    var widgetBuild = null;
    switch(widget.typeChange)
    {
      case "name":
        widgetBuild  = changeNameWidget();
      case "email":
        widgetBuild  = changeEmailWidget();

      default:
        widgetBuild  = Center(child: CircularProgressIndicator(),);
    }
    return widgetBuild;
      
  }

  Widget changeNameWidget()
  {
    return AlertDialog(
          backgroundColor: const Color.fromARGB(255, 250, 237, 241),
          actionsAlignment: MainAxisAlignment.center,
          title: const Text('Đổi Tên Người Dùng', textAlign: TextAlign.center,style: TextStyle( fontFamily: "SanProBold", )),
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
                      autovalidateMode: AutovalidateMode.onUserInteraction,
                      validator: (value) {
                        if(value == null || value.isEmpty)
                        {
                          return "Vui lòng nhập Tên mới";
                        }                     
                        return null;
                      },      
                      controller: textController,
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
                        label: const Padding(
                          padding: EdgeInsets.only(left: 20),
                          child: Text("Họ và Tên", textAlign: TextAlign.end, style: TextStyle(fontFamily: "SanPro", fontSize: 16, fontWeight: FontWeight.w500,color: Colors.black)),
                        ),
                      ),
                    ),
                  ),          

                  
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
            if(isWaiting || isBlock) CircularProgressIndicator(color: Colors.pink,),
            if(!isWaiting && !isBlock) TextButton(
              onPressed: saveEvent,
              child: const  Text('Lưu', style: TextStyle(fontFamily: "SanProBold", fontSize: 16, fontWeight: FontWeight.w500, color: Colors.black)),
            ),
          ],
        );

  }

  Widget changeEmailWidget()
  {
    return AlertDialog(
          backgroundColor: const Color.fromARGB(255, 250, 237, 241),
          actionsAlignment: MainAxisAlignment.center,
          title: const Text('Thay đổi email', textAlign: TextAlign.center,style: TextStyle( fontFamily: "SanProBold", )),
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
                      autovalidateMode: AutovalidateMode.onUserInteraction,
                      validator: (value) {
                        if(value == null || value.isEmpty)
                        {
                          return "Vui lòng nhập Email mới";
                        }                     
                        return null;
                      },      
                      controller: textController,                      
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
                        label: const Padding(
                          padding: EdgeInsets.only(left: 2),
                          child: Text("Email", textAlign: TextAlign.end, style: TextStyle(fontFamily: "SanPro", fontSize: 16, fontWeight: FontWeight.w500,color: Colors.black)),
                        ),
                      ),
                    ),
                  ),              

                  
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
            if(isWaiting || isBlock) CircularProgressIndicator(color: Colors.pink,),
            if(!isWaiting && !isBlock) TextButton(              
              onPressed: saveEvent,
              child: const  Text('Lưu', style: TextStyle(fontFamily: "SanProBold", fontSize: 16, fontWeight: FontWeight.w500, color: Colors.black)),
            ),
          ],
        );

  }

}