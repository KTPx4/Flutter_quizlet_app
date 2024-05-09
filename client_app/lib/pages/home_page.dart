import 'package:client_app/pages/community_page.dart';
import 'package:client_app/pages/flashcard_page.dart';
import 'package:client_app/pages/quiz_page.dart';
import 'package:client_app/pages/vocab_page.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

class Category {
  final String catName;
  final String catImage;

  Category(this.catName, this.catImage);
}

class HomePage extends StatelessWidget {
  HomePage({Key? key}) : super(key: key);

  final List<Category> categories = [
    Category('Flashcard', 'assets/images/cards.png'),
    Category('Quiz', 'assets/images/answer.png'),
    Category('Vocab', 'assets/images/dictionary.png'),
    Category('Community', 'assets/images/community.png'),
    
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      
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
              
              ],
            ),
          ),
          Container(
            margin: EdgeInsets.only(
                top: 230,
                left: 20,
                right:
                    20), 
            child: GridView.builder(
              padding:
                  EdgeInsets.zero,
              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                crossAxisSpacing: 10, 
                mainAxisSpacing: 10, 
                childAspectRatio: 0.9,
              ),
              itemCount: categories.length,
              itemBuilder: (BuildContext context, int index) {
                return Padding(
                  padding: const EdgeInsets.all(8),
                  child: Container(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(20),
                      color: Colors.white,
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(.1),
                          blurRadius: 4,
                          spreadRadius: .05,
                        ),
                      ],
                    ),
                    child: InkWell(
                      onTap: () {
                        final category = categories[index];
                        switch (category.catName) {
                          case 'Flashcard':
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => FlashcardPage(
                                      catName: category.catName)),
                            );
                            break;
                          case 'Quiz':
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => QuizPage(
                                      catName: category.catName)),
                            );
                            break;
                          case 'Vocab':
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => VocabPage(
                                      catName: category.catName)),
                            );
                            break;
                          case 'Community':
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => CommunityPage(
                                      catName: category.catName)),
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
                            categories[index].catImage,
                            fit: BoxFit.cover,
                            height: 70,
                            width: 70,
                          ),
                          SizedBox(height: 15),
                          Text(
                            categories[index].catName,
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
