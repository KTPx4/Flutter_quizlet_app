import 'package:client_app/pages/community_page.dart';
import 'package:client_app/pages/flashcard_page.dart';
import 'package:client_app/pages/quiz_page.dart';
import 'package:client_app/pages/vocab_page.dart';
import 'package:flutter/material.dart';

class Subject {
  final String subjectName;
  final String subjectImage;

  Subject(this.subjectName, this.subjectImage);
}

class HomePage extends StatelessWidget {
  HomePage({Key? key}) : super(key: key);

  final List<Subject> subjects = [
    Subject('Flashcard', 'assets/images/cards.png'),
    Subject('Quiz', 'assets/images/answer.png'),
    Subject('Vocab', 'assets/images/dictionary.png'),
    Subject('Community', 'assets/images/community.png'),
    // Add more subjects here...
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // backgroundColor: Colors.grey[300],
      body: Stack(
        children: [
          Container(
            padding: const EdgeInsets.only(top: 30, left: 20, right: 20),
            height: 200,
            width: double.infinity,
            decoration: const BoxDecoration(
              borderRadius: BorderRadius.only(
                bottomLeft: Radius.circular(20),
                bottomRight: Radius.circular(20),
              ),
              gradient: LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                stops: [0.1, 0.5],
                colors: [
                  Color(0xff886ff2),
                  Color(0xff6849ef),
                ],
              ),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    InkWell(
                      onTap: () {},
                      child: Icon(
                        Icons.sort,
                        color: Colors.white,
                        size: 40,
                      ),
                    ),
                    InkWell(
                      onTap: () {},
                      child: Icon(
                        Icons.person,
                        color: Colors.white,
                        size: 40,
                      ),
                    ),
                  ],
                ),
                Padding(
                  padding: const EdgeInsets.only(top: 20, left: 10, right: 20),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Welcome home, User',
                        style: TextStyle(
                            fontSize: 25,
                            color: Colors.white,
                            fontWeight: FontWeight.bold),
                      ),
                      Text(
                        'Have a good day!',
                        style: TextStyle(
                            fontSize: 20,
                            color: Colors.white54,
                            ),
                      ),
                    ],
                  ),
                ),
                // SizedBox(height: 20),
                // Text(
                //   "Alright",
                //   style: TextStyle(fontSize: 30),
                // ),
              ],
            ),
          ),
          Container(
            margin: EdgeInsets.only(
                top: 230,
                left: 20,
                right:
                    20), // Offset the grid view by the height of the top container
            child: GridView.builder(
              padding:
                  EdgeInsets.zero, // Adjust padding to remove default padding
              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                crossAxisSpacing: 10, // Horizontal space between cells
                mainAxisSpacing: 10, // Vertical space between cells
                childAspectRatio: 0.9,
              ),
              itemCount: subjects.length,
              itemBuilder: (BuildContext context, int index) {
                return Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Container(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(20),
                      color: Colors.white,
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(.1),
                          blurRadius: 4.0,
                          spreadRadius: .05,
                        ),
                      ],
                    ),
                    child: InkWell(
                      onTap: () {
                        final subject = subjects[index];
                        switch (subject.subjectName) {
                          case 'Flashcard':
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => FlashcardPage(
                                      subjectName: subject.subjectName)),
                            );
                            break;
                          case 'Quiz':
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => QuizPage(
                                      subjectName: subject.subjectName)),
                            );
                            break;
                          case 'Vocab':
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => VocabPage(
                                      subjectName: subject.subjectName)),
                            );
                            break;
                          case 'Community':
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => CommunityPage(
                                      subjectName: subject.subjectName)),
                            );
                            break;
                          default:
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => Scaffold(
                                      body: Center(
                                          child: Text('No page found')))),
                            );
                            break;
                        }
                      },
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Image.asset(
                            subjects[index].subjectImage,
                            fit: BoxFit.cover,
                            height: 70,
                            width: 70,
                          ),
                          SizedBox(height: 15),
                          Text(
                            subjects[index].subjectName,
                            style: TextStyle(
                                fontSize: 20, fontWeight: FontWeight.bold),
                          ),
                        ],
                      ),
                    ),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
