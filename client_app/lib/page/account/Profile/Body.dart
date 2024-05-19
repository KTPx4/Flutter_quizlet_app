import 'package:client_app/apiservices/accountAPI.dart';
import 'package:client_app/page/account/Profile/ChangeAvt.dart';
import 'package:client_app/page/account/Profile/ChangeAvtWeb.dart';
import 'package:client_app/page/account/Profile/ChangeInfor.dart';
import 'package:client_app/page/account/Profile/ChangePass.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:shared_preferences/shared_preferences.dart';
const KEY_LOGIN = "quizlet-login";

class Body extends StatefulWidget {

  Body({super.key,required this.onChange,});
  
  final ValueChanged? onChange;


  @override
  State<Body> createState() => _BodyState();
}

class _BodyState extends State<Body> {
  List<Map<String, dynamic>> ListButton = [
    {"title": "Thay đổi ảnh đại diện", "event": "changeAvt", "icon": Icons.image},
    {"title": "Thay đổi tên", "event": "changeName", "icon": Icons.person_2},
    {"title": "Thay đổi email", "event": "changeEmail", "icon": Icons.email},
    {"title": "Thay đổi mật khẩu", "event": "changePass", "icon": Icons.numbers},
    {"title": "Đăng xuất", "event": "logOut", "icon": Icons.logout},
  ];

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
          
          alignment: Alignment.topLeft,
          margin: EdgeInsets.only(left: 20, right: 17, top: 50),   
          child: Text("Cài đặt",
            style: TextStyle(  fontFamily: "SanProBold", fontSize: 20),
          )),

        Container(    
     
          margin: EdgeInsets.only(left: 17, right: 17, top: 10),   
          padding: EdgeInsets.only(top: 0),

          child: 
              ClipRRect(
                borderRadius: BorderRadius.circular(20),
               
                child: ListView.separated(
                  padding: EdgeInsets.zero,
                  shrinkWrap: true,
                  itemBuilder: (context, index) => _buildButton(index), 
                  separatorBuilder: (context, index) => Divider(height: 1,color: Colors.grey[300]), 
                  itemCount: ListButton.length 
                ),
              )
        ),
      ],
    );
  }
  void _reConnect()
  {
    widget.onChange!({"type": "reconnect", "value": "non"});
  }
  Widget _buildButton(index)
  {
    return Material(
      child: InkWell(
        onTap: () async{
          // List<ConnectivityResult> result = await Connectivity().checkConnectivity();
          // var connect = false;
          // if (result == ConnectivityResult.mobile || result == ConnectivityResult.wifi) 
          // {             
          //   connect = true;
          // } 
          // if(!connect)
          // {
          //   ScaffoldMessenger.of(context).clearSnackBars();
          //   ScaffoldMessenger.of(context).showSnackBar(
          //     SnackBar(
          //       content: Text("Không có kết nối mạng, vui lòng tải lại trang!", ),
          //       action: SnackBarAction(label: "Tải lại", onPressed: _reConnect),

          //     ));
          // }
          // else{
            switch(ListButton[index]["event"])
            {
              case "changeAvt":
                changeAvt(); 
              case "changeName":
                changeName(); 
              case "changeEmail":
                changeEmail(); 
              case "changePass":
                changePass(); 
              case "logOut":
                logOut(); 
            }
          // }
        },

        child: ListTile(           
          title: Text(ListButton[index]["title"]),
          leading: Icon(ListButton[index]["icon"], color:   Color.fromARGB(244, 230, 88, 142),),
          trailing: Icon(Icons.arrow_forward_ios_rounded),
        ),
      
      ),
    );
  }

  void changeAvt() async
  {
  
    var isTrue = await showDialog(      
      barrierDismissible: false,
      context: context,
      builder: (context) {        
        return kIsWeb ? ChangeAvtWeb() : ChangeAvtMobile();     
      } 
    );  
    if(isTrue)
    {
      widget.onChange!({"type": "refresh", "value": "non"});
    }
  }

  void changeName() async
  {
    var isTrue = await showDialog(      
      barrierDismissible: false,
      context: context,
      builder: (context) {        
        return new AlertChangeInfor(typeChange: "name",);     
      } 
    );  
    if(isTrue)
    {
      ScaffoldMessenger.of(context).clearSnackBars();
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("Cập nhật thành công")));
      widget.onChange!({"type": "refresh", "value": "non"});
    }
  }

  void changeEmail() async
  {
    var isTrue = await showDialog(      
      barrierDismissible: false,
      context: context,
      builder: (context) {        
        return new AlertChangeInfor(typeChange: "email",);     
      } 
    );  
    if(isTrue)
    {
      ScaffoldMessenger.of(context).clearSnackBars();
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("Cập nhật thành công")));
      widget.onChange!({"type": "refresh", "value": "non"});
    }
  }

  void changePass() async
  {

    var isTrue = await showDialog(      
      barrierDismissible: false,
      context: context,
      builder: (context) {        
        return new AlertChangePass();     
      } 
    );  
    if(isTrue)
    {
      ScaffoldMessenger.of(context).clearSnackBars();
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("Cập nhật thành công")));
    }
    
  }

  void logOut() async {
    final confirm = await showDialog(
      barrierDismissible: false,
      context: context,
      builder: (context) => AlertDialog(

        backgroundColor: Color.fromARGB(255, 250, 237, 241),
        title: Text('Đăng xuất', style:TextStyle(fontFamily: "SanProBold", fontSize: 16, )),
        content: Text('Bạn có chắc chắn muốn đăng xuất?'),
        actions: [
          TextButton(
            child: Text('Không',  style:TextStyle(fontFamily: "SanProBold", fontSize: 16, )),
            onPressed: () => Navigator.of(context).pop(false),
          ),
          TextButton(
            child: Text('Có', style:TextStyle(fontFamily: "SanProBold", fontSize: 16, )),
            onPressed: () => Navigator.of(context).pop(true),
          ),
        ],
      ),
    );

    if (confirm) {
      var pref = await SharedPreferences.getInstance();
      pref.remove(KEY_LOGIN);
      Navigator.pushNamedAndRemoveUntil(context, "/account/login", (route) => false);
    }
  }

}
