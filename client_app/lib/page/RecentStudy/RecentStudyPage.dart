import 'dart:convert';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:client_app/apiservices/TopicService.dart';
import 'package:client_app/apiservices/accountAPI.dart';
import 'package:client_app/component/AppBarCustom.dart';
import 'package:client_app/models/topic.dart';
import 'package:client_app/modules/ColorsApp.dart';
import 'package:client_app/page/topic/topicStudy.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

const KEY_STUDY = "study_topic";

class RecentStudyPage extends StatefulWidget {
  GlobalKey<State<AppBarCustom>>? appBarKey;
  RecentStudyPage({super.key, this.appBarKey});

  @override
  State<RecentStudyPage> createState() => _RecentStudyPageState();
}

class _RecentStudyPageState extends State<RecentStudyPage> {
  late Future<List<Map<String, dynamic>>> _dataFuture;
  bool _isRefreshing = false;

  @override
  void initState() {
    super.initState();
    initStartup();
    _dataFuture = _loadDATA();
  }

  void initStartup() {
    List<Widget> action = [];
    if (mounted) {
      if (widget.appBarKey?.currentState != null) {
        (widget.appBarKey?.currentState as AppBarCustomState).clearAll();
        (widget.appBarKey?.currentState as AppBarCustomState)
            .updateTitle("Cộng đồng chủ đề");
        (widget.appBarKey?.currentState as AppBarCustomState)
            .updateAction(action);
        (widget.appBarKey?.currentState as AppBarCustomState)
            .updateColor(Color.fromARGB(244, 255, 255, 255));
      }
    }
  }

  Future<List<Map<String, dynamic>>> _loadDATA() async {
    var res = await AccountAPI.getTopicPublicv2();
    if (res["success"]) {
      var pref = await SharedPreferences.getInstance();
      var topic = jsonEncode(res["data"]) ?? "";

      pref.setString(KEY_STUDY, topic);

      return res["data"];
    }
    return [
      {"type": "error", "error": res["message"], 'notConnect': res["notConnect"]}
    ];
  }

  Future<List<Map<String, dynamic>>> _loadLOCAL() async {
    var pref = await SharedPreferences.getInstance();
    var data = pref.getString(KEY_STUDY);

    if (data == null || data == "") {
      return [];
    }

    List<dynamic> jsonData = jsonDecode(data);
    List<Map<String, dynamic>> topic = jsonData.cast<Map<String, dynamic>>();

    return topic;
  }

  Future<void> _refreshData() async {
    setState(() {
      _isRefreshing = true;
    });
    await _loadDATA().then((value) {
      setState(() {
        _dataFuture = Future.value(value);
        _isRefreshing = false;
      });
    }).catchError((error) {
      setState(() {
        _isRefreshing = false;
      });
    });
  }

  Widget LoadFromLocal() {
    return FutureBuilder(
      future: _loadLOCAL(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return Center(
            child: CircularProgressIndicator(
              color: Colors.pink,
            ),
          );
        } else if (snapshot.hasError) {
          print(snapshot.error);
          return Center(
            child: Padding(
              padding: const EdgeInsets.all(20.0),
              child: Text(
                "Lỗi khi tải dữ liệu offline. Vui lòng kết nối mạng và tải lại trang!",
                textAlign: TextAlign.center,
              ),
            ),
          );
        } else {
          List<Map<String, dynamic>> listTopics = snapshot.data!;
          if (listTopics.length < 1) {
            return Center(
              child: Padding(
                padding: const EdgeInsets.all(20.0),
                child: Text(
                  "Chưa có dữ liệu offline, hoặc danh sách trống. Vui lòng kết nối mạng để xem",
                  textAlign: TextAlign.center,
                ),
              ),
            );
          }
          return ListView.separated(
            separatorBuilder: (context, index) => SizedBox(height: 1),
            itemBuilder: (context, index) => _buildTopic(listTopics[index]),
            itemCount: listTopics.length,
          );
        }
      },
    );
  }

  void _clickTopic(id) async {
    try {
      Topic topic = await TopicService().getTopicById(id);
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => TopicStudy(topic: topic),
        ),
      );
    } catch (err) {
      print(err);
      var notConnect = err.toString().contains("Connection failed");
      var mess = "Có chút lỗi nho nhỏ. Vui lòng thử lại sau nha ^^!";
      if (notConnect == true) {
        mess = "Không có kết nối mạng. Vui lòng thử lại sau!";
      }
      ScaffoldMessenger.of(context).clearSnackBars();
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(mess)));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      color: AppColors.background,
      child: RefreshIndicator(
        onRefresh: _refreshData,
        child: FutureBuilder(
          future: _isRefreshing ? _dataFuture : _loadLOCAL(),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return Center(
                child: CircularProgressIndicator(
                  color: Colors.pink,
                ),
              );
            } else if (snapshot.hasError) {
              return Text("Có chút lỗi nho nhỏ khi load dữ liệu ^^!");
            } else {
              var listContent = snapshot.data;
              if (listContent!.isNotEmpty && listContent[0]["type"] != "error") {
                return ListView.separated(
                  separatorBuilder: (context, index) => SizedBox(height: 1),
                  itemBuilder: (context, index) => _buildTopic(listContent[index]),
                  itemCount: listContent?.length ?? 0,
                );
              } else if (listContent[0]["type"] == "error" && listContent[0]["notConnect"] == true) {
                return LoadFromLocal();
              } else {
                return Center(
                  child: Text("Có chút lỗi khi tải dữ liệu @@!"),
                );
              }
            }
          },
        ),
      ),
    );
  }

  Widget _buildTopic(Map<String, dynamic> topic) {
    var date = topic["createAt"].toString();
    var time = date.split(" ")[0];
    var day = date.split(" ")[1];
    time = "${time.split(":")[0]}:${time.split(":")[1]}";
    var created = "$time - $day";

    return Material(
      color: AppColors.background,
      child: InkWell(
        onTap: () => _clickTopic(topic["id"]),
        child: Container(
          height: 200,
          margin: EdgeInsets.symmetric(horizontal: 15, vertical: 10),
          padding: EdgeInsets.symmetric(horizontal: 25, vertical: 15),
          width: double.infinity,
          decoration: BoxDecoration(
            color: AppColors.card,
            borderRadius: BorderRadius.circular(20),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Expanded(
                    child: Text(
                      topic["title"],
                      style: TextStyle(
                          fontFamily: "SanPro",
                          fontSize: 19,
                          fontWeight: FontWeight.w600),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                  IconButton(
                    onPressed: () {},
                    icon: Icon(Icons.folder_special_outlined),
                  ),
                ],
              ),
              SizedBox(height: 2),
              Padding(
                padding: const EdgeInsets.only(left: 8.0),
                child: Text(
                  "Số từ: ${topic["count"]}",
                  style: TextStyle(
                      fontFamily: "SanPro",
                      fontSize: 15,
                      fontWeight: FontWeight.w500,
                      fontStyle: FontStyle.italic),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(left: 8.0),
                child: Text(
                  "Số người đã học: ${topic["publicStudy"]}",
                  style: TextStyle(
                      fontFamily: "SanPro",
                      fontSize: 15,
                      fontWeight: FontWeight.w500,
                      fontStyle: FontStyle.italic),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(left: 8.0),
                child: Text(
                  "Ngày tạo: ${day}",
                  style: TextStyle(
                      fontFamily: "SanPro",
                      fontSize: 15,
                      fontWeight: FontWeight.w500,
                      fontStyle: FontStyle.italic),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
              Spacer(),
              Center(
                child: Row(
                  children: [
                    Expanded(
                      flex: 1,
                      child: Container(
                        alignment: Alignment.centerRight,
                        margin: EdgeInsets.only(left: 40),
                        width: 36.0,
                        height: 36.0,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          border: Border.all(width: 2, color: Colors.lightBlue),
                          image: DecorationImage(
                            fit: BoxFit.scaleDown,
                            image: NetworkImage(
                                "${topic["imgAuthor"]}?v=${DateTime.now().toString()}"),
                          ),
                        ),
                      ),
                    ),
                    Expanded(
                      flex: 2,
                      child: Container(
                        alignment: Alignment.centerLeft,
                        child: Text(
                          topic["author"],
                          maxLines: 1,
                          style: TextStyle(
                              fontFamily: "SanProBold",
                              overflow: TextOverflow.ellipsis,
                              fontSize: 14,
                              color: AppColors.titleLarge),
                        ),
                      ),
                    ),
                    Text(
                      "${time}",
                      style: TextStyle(
                          fontFamily: "SanPro",
                          fontSize: 15,
                          fontWeight: FontWeight.w500,
                          fontStyle: FontStyle.italic),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    )
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
