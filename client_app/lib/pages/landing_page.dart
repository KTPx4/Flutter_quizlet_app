// import 'package:client_app/pages/home_page.dart';
// import 'package:flutter/cupertino.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter/widgets.dart';

// class LandingPage extends StatefulWidget {
//   const LandingPage({super.key});

//   @override
//   State<LandingPage> createState() => _LandingPageState();
// }

// class _LandingPageState extends State<LandingPage> {
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       backgroundColor: Colors.deepOrange[50],
//       body: Container(
//         decoration: const BoxDecoration(
//           image: DecorationImage(
//             image: AssetImage('assets/images/pic1.jpg'),
//             fit: BoxFit.cover,
//           ),
//         ),
//         child: Container(
          
//           child: Container(
//             margin: EdgeInsets.all(20),
//             decoration: BoxDecoration(
            
        
//             ),
//             child: Column(
            
//               mainAxisAlignment: MainAxisAlignment.end,
//               crossAxisAlignment: CrossAxisAlignment.start,
//               children: <Widget>[
                
//                 Text(
//                   "Vocabulary learning",
//                   style: TextStyle(
//                       color: Colors.white,
//                       fontSize: 44,
//                       fontWeight: FontWeight.w900,
//                       height: 1.1),
//                 ),
//                 SizedBox(
//                   height: 30,
//                 ),
//                 Text(
//                   "Let us find you an event for your interest",
//                   style: TextStyle(
//                       color: Colors.white.withOpacity(.8),
//                       fontSize: 25,
//                       fontWeight: FontWeight.w400),
//                 ),
//                 SizedBox(
//                   height: 150,
//                 ),
//                 InkWell(
                  
//                   onTap: () {
//                     Navigator.pushAndRemoveUntil(
//                           context,
//                           MaterialPageRoute(builder: (_) => HomePage()),
//                           (route) => false);
//                   },
//                   child: Container(
//                     padding: EdgeInsets.all(10),
//                     margin: EdgeInsets.all(20),
//                     height: 60,
//                     decoration: BoxDecoration(
//                       borderRadius: BorderRadius.circular(50),
//                       color: Colors.blue[200]?.withOpacity(.6),
//                     ),
//                     child: Row(
                      
//                       mainAxisAlignment: MainAxisAlignment.spaceAround,
//                       children: <Widget>[
//                         Text(
//                           'Get started',
//                           style: TextStyle(
//                               color: Colors.white,
//                               fontSize: 18,
//                               fontWeight: FontWeight.w400),
//                         ),
//                         Icon(
//                           Icons.arrow_forward,
//                           color: Colors.white,
//                         )
//                       ],
//                     ),
//                   ),
//                 ),
//                 SizedBox(height: 80,)
//               ],
//             ),
//           ),
//         ),
//       ),
//     );
//   }
// }
