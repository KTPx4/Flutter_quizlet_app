import 'package:client_app/component/AppBarCustom.dart';
import 'package:client_app/modules/ColorsApp.dart';
import 'package:client_app/modules/callFunction.dart';
import 'package:client_app/page/topic/TopicPage.dart';
import 'package:client_app/page/topic/TopicTabMode.dart';
import 'package:client_app/page/topic/addtopic.dart';
import 'package:flutter/material.dart';

import '../folder/AddEditFolder.dart';
import '../folder/FolderPage.dart';

class LibraryPage extends StatefulWidget {
  GlobalKey<State<AppBarCustom>>? appBarKey;
  LibraryPage({this.appBarKey, super.key});

  @override
  State<LibraryPage> createState() => _LibraryPageState();
}

class _LibraryPageState extends State<LibraryPage>
    with SingleTickerProviderStateMixin {
  CallFunction callFunctionTopic = CallFunction();
  CallFunction callFunctionFolder = CallFunction();
  late final _tabController = TabController(length: 2, vsync: this);
  var _pageController = PageController();

  late var childLib;

  bool isTopic = true; // use for button add in AppBar

  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    childLib = [
      TopicTab(
        callFunction: callFunctionTopic,
        mode: TopicTabMode(
          accountTopic: true,
        ),
      ),
      FolderTab(
        callFunction: callFunctionFolder,
      ),
    ];

    initStartup();
  }

  void initStartup() {
    var action = _actionAppBar();

    if (widget.appBarKey?.currentState != null) {
      (widget.appBarKey?.currentState as AppBarCustomState)
          .clearAll();
      (widget.appBarKey?.currentState as AppBarCustomState)
          .updateTitle("Thư viện");
      (widget.appBarKey?.currentState as AppBarCustomState)
          .updateAction(action);
    }
  }

  void addFolder() async {
    await showDialog(
      context: context,
      builder: (BuildContext context) {
        return AddEditFolderDialog();
      },
    );
    callFunctionFolder.refreshWidget();
  }

  void addTopic() async {
    await Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => AddTopicPage()),
    );

    callFunctionTopic.refreshWidget();
  }

  List<Widget> _actionAppBar() {
    return [
      IconButton(
          onPressed: (isTopic) ? addTopic : addFolder, icon: Icon(Icons.add)),
    ];
  }

  //////
// transition function   control the current tab and the current page
  void _animationToPage(index) {
    // check if it is a topic or not

    _pageController.animateToPage(index,
        duration: const Duration(milliseconds: 200), curve: Curves.linear);

    _tabController.animateTo(index,
        duration: const Duration(milliseconds: 200), curve: Curves.linear);

    setState(() {
      isTopic = (index == 0);
      initStartup();
    });
  }

  Widget _buildTabBar() {
    
    return Container(
      color: AppColors.libTabBar,
      child: TabBar(onTap: _animationToPage, controller: _tabController, tabs: [
        Tab(
          icon: Icon(Icons.library_books_outlined),
        ),
        Tab(
          icon: Icon(Icons.folder_copy_outlined),
        ),
      ]),
    );
  }

  Future<Widget> _buildPage() async {
    if (childLib.length == 0) {
      childLib = [
        TopicTab(
          callFunction: callFunctionTopic,
          mode: TopicTabMode(
            accountTopic: true,
          ),
        ),
        FolderTab(
          callFunction: callFunctionFolder,
        )
      ];
    }

    return PageView.builder(
      onPageChanged: _animationToPage,
      controller: _pageController,
      itemBuilder: (context, index) => Container(
        child: childLib[index],
      ),
      itemCount: 2,
    );
  }

  Widget _searchbar() {
    return Container(
      padding: const EdgeInsets.all(10),
      child: TextField(
        decoration: InputDecoration(
          hintText: "Tìm kiếm",
          prefixIcon: Icon(Icons.search),
          suffixIcon: IconButton(
            onPressed: () {},
            icon: Icon(Icons.clear),
          ),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10),
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {

    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        _buildTabBar(),
        Expanded(
            child: FutureBuilder(
          future: _buildPage(),
          builder: (context, snapshot) {
            if (!snapshot.hasData) {
              return CircularProgressIndicator();
            } else if (snapshot.hasData) {
              var page = snapshot.data;
              return page!;
            } else {
              return Center(
                child:
                    Text("lỗi xảy ra khi load dữ liệu, vui lòng thử lại sau"),
              );
            }
          },
        ))
      ],
    );
  }
}
