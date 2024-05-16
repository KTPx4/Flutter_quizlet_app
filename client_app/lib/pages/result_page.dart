// import 'package:flutter/material.dart';
// import 'package:client_app/pages/home_page.dart';
// import 'package:client_app/pages/check_answers_page.dart'; 

// class ResultsPage extends StatelessWidget {
//   final int score;
//   final int totalQuestions;
//   final List<String> userAnswers;

//   ResultsPage(
//       {Key? key,
//       required this.score,
//       required this.totalQuestions,
//       required this.userAnswers})
//       : super(key: key);

//   @override
//   Widget build(BuildContext context) {
//     double percentage =
//         (score / totalQuestions) * 100; 

//     return Scaffold(
//       appBar: AppBar(
//         title: Text("Result"),
//       ),
//       body: Center(
//         child: Column(
//           mainAxisAlignment: MainAxisAlignment.center,
//           children: <Widget>[
//             Text(
//               "Your Score: ${percentage.round()}%",
//               style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
//             ),
//             SizedBox(height: 20),
//             Row(
//               mainAxisAlignment: MainAxisAlignment.center, 
//               children: [
//                 ElevatedButton(
//                   onPressed: () {
                    
//                     Navigator.push(
//                       context,
//                       MaterialPageRoute(builder: (context) => HomePage()),
//                     );
//                   },
//                   child: Text("Back to home"),
//                 ),
//                 SizedBox(width: 20), 
                
//                 ElevatedButton(
//                   onPressed: () {
//                     print("Passing answers to CheckAnswersPage: $userAnswers");
//                     Navigator.pushReplacement(
//                       context,
//                       MaterialPageRoute(
//                           builder: (context) =>
//                               CheckAnswersPage(userAnswers: userAnswers)),
//                     );
//                   },
//                   child: Text("Check Answers"),
//                 ),
//               ],
//             ),
//           ],
//         ),
//       ),
//     );
//   }
// }
