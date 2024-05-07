import 'dart:math' as math;
import 'package:flutter/material.dart';

import 'package:flutter/material.dart';


class ProfilePage extends StatefulWidget {
  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  double width = double.infinity;

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        backgroundColor: Color.fromARGB(255, 214, 208, 211),
          body: headerProfile(width),
        ),
    );
  }
}


Widget headerProfile(width)
{
  return Container(
          // padding: EdgeInsets.only(left: 15, right: 15, top: 5),
          color: Colors.transparent,
          alignment: Alignment.topCenter,
          height: 180,
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
                  width: width,
                  height: 110,                
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(top:40, left: 15, right: 15),
                child: Container(
                  decoration: BoxDecoration(
                    boxShadow: [
                      BoxShadow(color: Color.fromARGB(255, 196, 150, 177), blurRadius: 6)
                    ],
                    color: Color.fromARGB(232, 255, 255, 255),
                    borderRadius: BorderRadius.circular(15)
                    ),
                  width: width,
                  height: 130,
                  child: Padding(
                    padding: EdgeInsets.only(top: 50),
                    child: Column(
                      
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text("Kiều Thành Phát", style: TextStyle(
                          fontFamily: "SanProBold",
                          fontSize: 18,                       
                        ),),
                        Text("px4.vnd@gmail.com", style: TextStyle(
                          fontFamily: "SanPro",
                          fontSize: 14,
                          fontStyle: FontStyle.italic,
                          color: Colors.grey[500]                       
                        ),),
                        Spacer(),
                        Container(                          
                          
                          height: 30,
                          child: Row(
                            children: [
                              Expanded(child: Container(decoration: BoxDecoration(
                              // shape: BoxShape.circle,
                              color: Color.fromARGB(255, 243, 238, 240),
                              borderRadius: BorderRadius.only(bottomLeft: Radius.circular(15))
                              ),)),
                              Expanded(child: Container(decoration: BoxDecoration(
                              
                              color: Color.fromARGB(255, 233, 229, 230),
                              borderRadius: BorderRadius.only(bottomRight: Radius.circular(15))
                              ),)),
                            ],
                          ),
                        ),
                        
                      ],
                    ),
                  ),                
                ),
              ),
              Positioned(
                top: 2,
                child: Container(
                  margin: EdgeInsets.only(top: 10),
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    border: Border.all(width: 2, color: Color.fromARGB(255, 32, 198, 248))
                  ),
                  child: CircleAvatar(                                 
                    backgroundImage: 
                    NetworkImage('https://cdn1.searchiq.co/thumb/dogtime.com/aHR0cHM6Ly9kb2d0aW1lLmNvbS93cC1jb250ZW50L3VwbG9hZHMvc2l0ZXMvMTIvMjAyMC8xMQ/250x250/R2V0dHlJbWFnZXMtNTEyMzY2NDM3LWUxNjg4Njc3NzI2MjA4LmpwZw.png'), radius: 35,),
                ),
              ),
            ],
          ),
        );
}


// class MyClipper extends CustomClipper<Path> {
//   @override
//   Path getClip(Size size) {
//     var path = Path();
//     path.lineTo(0, size.height + 180);
//     path.lineTo(size.width , 0);
//     // path.lineTo(size.width , size.height + 10);
//     path.close();
//     return path;
//   }

//   @override
//   bool shouldReclip(CustomClipper<Path> oldClipper) => false;
// }
class MyClipper1 extends CustomClipper<Path> {
  @override
  Path getClip(Size size) {
    var path = Path();
    path.lineTo(0, size.height);
    path.lineTo(size.width, 0);
    path.close();
    return path;
  }

  @override
  bool shouldReclip(CustomClipper<Path> oldClipper) => false;
}

class MyClipper2 extends CustomClipper<Path> {
  @override
  Path getClip(Size size) {
    var path = Path();
    path.moveTo(size.width, 0);
    path.lineTo(size.width, size.height);
    path.lineTo(0, 0);
    path.close();
    return path;
  }

  @override
  bool shouldReclip(CustomClipper<Path> oldClipper) => false;
}