
import 'dart:convert';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:client_app/modules/callFunction.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
const SERVER = "http://10.0.2.2:3000/images/account";

class Header extends StatefulWidget {
  double width;
  final CallFunction callFunction;

  Header({required this.width, required this.callFunction,super.key});

  @override
  State<Header> createState() => _HeaderState();
}

class _HeaderState extends State<Header> {
  String fullName = "Kiều Thành Phát";
  String email = "px4.vnd@gmail.com";
  String linkAvt = "http://10.0.2.2:3000/images/account/1.png";

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    widget.callFunction.refreshWidget = refreshWidget;
    initInfor();
  }
  void initInfor() async {
    var pref = await SharedPreferences.getInstance();
    var Account = jsonDecode(pref?.getString("Account") ?? "");
    if(Account == "" ) return;

    setState(() {
      fullName = Account["fullName"];
      email = Account["email"];   
      linkAvt = "$SERVER/${Account["_id"]}/${Account["nameAvt"]}?v=${DateTime.now().toString()}";
    });
  }

  void refreshWidget()
  {
    initInfor();
    setState(() {
    });
  }
  @override
  Widget build(BuildContext context) {
    return Container(
          // padding: EdgeInsets.only(left: 15, right: 15, top: 5),
          color: Colors.transparent,
          alignment: Alignment.topCenter,
          height: 190,
          child: Stack(            
            alignment: Alignment.center,
            children: <Widget>[
              Padding(
                padding: const EdgeInsets.only(bottom: 60),
                child: Container(
                  decoration: const BoxDecoration(
                      gradient:  LinearGradient(                        
                            transform: GradientRotation(11), // 30
                            colors: [                               
                                Color.fromARGB(255, 235, 139, 139),
                                Color.fromARGB(220, 219, 197, 210),                       
                                Color.fromARGB(244, 228, 206, 220),                           
                                Color.fromARGB(244, 230, 88, 142),                           
                                Color.fromARGB(244, 241, 224, 239),                           
                                Color.fromARGB(244, 246, 255, 252),                         
                              ])),
                  width: widget.width,
                  height: 120,                
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(top:40, left: 15, right: 15),
                child: Container(
                  decoration: BoxDecoration(
                    boxShadow: const [
                       BoxShadow(color: Color.fromARGB(255, 196, 150, 177), blurRadius: 6)
                    ],
                    color: const Color.fromARGB(232, 255, 255, 255),
                    borderRadius: BorderRadius.circular(15)
                    ),
                  width: widget.width,
                  height: 120,
                  child: Padding(
                    padding:const EdgeInsets.only(top: 50),
                    child: Column(
                      
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text( fullName , style: const TextStyle(
                          fontFamily: "SanProBold",
                          fontSize: 18,                       
                        ),),
                        Text(email, style: TextStyle(
                          fontFamily: "SanPro",
                          fontSize: 14,
                          fontStyle: FontStyle.italic,
                          color: Colors.grey[500]                       
                        ),),
                        const Spacer(),
                        
                      ],
                    ),
                  ),                
                ),
              ),
              Positioned(
                top: 2,
                child: Container(
                  margin: const EdgeInsets.only(top: 10),
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    border: Border.all(width: 2, color:const Color.fromARGB(255, 32, 198, 248))
                  ),
                  child:  CircleAvatar(                                 
                    backgroundImage: 
                    NetworkImage(linkAvt), radius: 35,),
                ),
              ),
            ],
          ),
        );
  }
}