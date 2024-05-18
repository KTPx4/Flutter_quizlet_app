import 'package:client_app/modules/ColorsApp.dart';
import 'package:client_app/modules/callFunction.dart';
import 'package:client_app/page/folder/AddEditFolder.dart';
import 'package:client_app/page/topic/addtopic.dart';
import 'package:flutter/material.dart';

class BottomNav extends StatefulWidget {
  int indexBottom;
  PageController pageController;
  CallFunction callFunction;

  BottomNav(
      {required this.indexBottom,
      required this.pageController,
      required this.callFunction,
      super.key});

  @override
  State<BottomNav> createState() => _BottomNavState();
}

class _BottomNavState extends State<BottomNav> {
  List<Map<String, dynamic>>? label;
  int currentIndex = 0;
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    initLanguage();
    widget.callFunction.updateIndex = updateIndex;
  }

  updateIndex(int index) {
    setState(() {
      currentIndex = (index >= 2) ? index + 1 : index;
    });
  }

  void initLanguage() async {
    setState(() {
      currentIndex = widget.indexBottom;
      label = [
        {"title": "Trang Chủ", "icon": Icon(Icons.home)},
        {"title": "Học", "icon": Icon(Icons.menu_book_sharp)},
        {
          "title": "",
          "icon": Icon(
            Icons.add_circle_outline,
            size: 40,
          )
        },
        {"title": "Thư Viện", "icon": Icon(Icons.folder_copy_outlined)},
        {"title": "Tôi", "icon": Icon(Icons.account_box_outlined)},
      ];
    });
  }

  void goPage(int index) {
    // widget.pageController.animateToPage(currentIndex,
    //               duration: const Duration(milliseconds: 500),
    //               curve: Curves.easeIn);
    if (index == 2) {
      index = -2;
      showModalBottomSheet(
        context: context,
        builder: (context) {
          return Container(
            padding: EdgeInsets.all(16),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                ListTile(
                  onTap: () async {
                    await Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => AddTopicPage()),
                    );
                  },
                  title: Text("Chủ đề"),
                  leading: Icon(Icons.library_books_outlined),
                ),
                ListTile(
                  onTap: () async {
                    await showDialog(
                      context: context,
                      builder: (BuildContext context) {
                        return AddEditFolderDialog();
                      },
                    );
                  },
                  title: Text("Thư mục"),
                  leading: Icon(Icons.folder_copy_outlined),
                ),
              ],
            ),
          );
        },
      );
    } else {
      index = (index > 2)
          ? (index - 1)
          : index; // Add Button not navigate page direct

      widget.pageController.animateToPage(index,
          duration: const Duration(milliseconds: 500), curve: Curves.easeIn);
    }
  }

  @override
  Widget build(BuildContext context) {
    return BottomNavigationBar(
        // backgroundColor: Color.fromARGB(200, 96, 125, 139),
        backgroundColor: AppColors.bottomNav,
        currentIndex: currentIndex,
        type: BottomNavigationBarType.fixed,
        selectedItemColor: AppColors.bottomSelected,
        unselectedItemColor: AppColors.bottomText,
        onTap: (value) {
          setState(() {
            currentIndex = value;
          });

          goPage(currentIndex);
        },
        items: [
          BottomNavigationBarItem(
              icon: label?[0]["icon"], label: label?[0]["title"]),
          BottomNavigationBarItem(
              icon: label?[1]["icon"], label: label?[1]["title"]),
          BottomNavigationBarItem(
              icon: label?[2]["icon"], label: label?[2]["title"]),
          BottomNavigationBarItem(
              icon: label?[3]["icon"], label: label?[3]["title"]),
          BottomNavigationBarItem(
              icon: label?[4]["icon"], label: label?[4]["title"]),
        ]);
  }
}
