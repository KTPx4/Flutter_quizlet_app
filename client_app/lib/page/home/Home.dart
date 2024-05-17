
import 'dart:convert';

import 'package:client_app/apiservices/accountAPI.dart';
import 'package:client_app/component/AppBarCustom.dart';
import 'package:client_app/page/home/Carousel.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
const KEY_HOME_AUTHOR ="data_page_home_author";
const KEY_HOME_TOPIC ="data_page_home_topic";

class Home extends StatefulWidget {
  GlobalKey<State<AppBarCustom>>? appBarKey ;
  Home({this.appBarKey,super.key});

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {

  List<List<Map<String, dynamic>>>? listContent;
  List<Map<String, dynamic>>? listAuthor;
  

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    initValue();
  }

  void initValue() async
  {    
    if (widget.appBarKey?.currentState != null) 
    {
      (widget.appBarKey?.currentState as AppBarCustomState ).clearAll();
      (widget.appBarKey?.currentState as AppBarCustomState ).updateTitle("Trang Chủ");

    }
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      
      child: Column(        

        // crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          const Padding(
            padding:  EdgeInsets.all(10.0),
            child:  Text( "Tác Giả Nổi Bật" , style:  TextStyle(
                              fontFamily: "SanProBold",
                              fontSize: 18, 
                              color: Color.fromARGB(255, 0, 0, 0),
                            ),),
          ),
          // Build Carousel Tác Giả
          const SizedBox(height: 10,),

          _buildAuthor(),

          const SizedBox(height: 20,),
          Divider(height: 1,),
          const Padding(
            padding: EdgeInsets.all(18.0),
            child: Text( "Tổng Hợp Chủ Đề" , style: TextStyle(
                              fontFamily: "SanProBold",
                              fontSize: 18,  
                              color: Color.fromARGB(255, 0, 0, 0)                      
                            ),),
          ),
          _buildContent(),
          
        ],
      ),
    );
  }



  Widget _buildCarousel(int index)
  {
    return Carousel(listCard: listContent?[index] ?? []);
  //   return FutureBuilder(
  //   future: _loadTopic(),
  //     builder: (context, snapshot) {
  //     if(snapshot.connectionState == ConnectionState.waiting)
  //     {
  //       print("wait") ;
  //       return CircularProgressIndicator();
  //     }   
  //     else if(snapshot.hasError)
  //     {     
  //       print("err")   ;
  //       return Text("Có chút lỗi nho nhỏ khi load dữ liệu ^^!");
  //     }
  //     else
  //     {
  //       print("ok" );
  //       print( snapshot.data);
  //       listContent = snapshot.data;
  //       if(listContent![0][0]["type"] != "error")
  //       {
  //         return Carousel(listCard: listContent![index] );
  //       }
  //       else{
  //         return Text("Tải danh sách tác giả thất bại. Thử lại sau !");
  //       }
  //     }
  //     },
  // );
  
  }

  Widget _buildContent()
  {
    return FutureBuilder(
    future: _loadTopic(),
      builder: (context, snapshot) {
      if(snapshot.connectionState == ConnectionState.waiting)
      {
        return CircularProgressIndicator(color: Colors.pink,);
      }   
      else if(snapshot.hasError)
      {     
        return Text("Có chút lỗi nho nhỏ khi load dữ liệu ^^!");
      }
      else
      {

        listContent = snapshot.data;
        if(listContent![0][0]["type"] != "error")
        {
          return ListView.separated(
            shrinkWrap: true,
            physics: NeverScrollableScrollPhysics(),
            separatorBuilder: (context, index) => SizedBox(height: 50,),
            itemBuilder: (context, index) => _buildCarousel(index),
            itemCount: listContent?.length ?? 0,
          );
        }
        else{
          return Text("Tải danh sách tác chủ đề thất bại. Thử lại sau !");
        }
      }
      },
  );
    
    
  }

  Widget _buildAuthor()
  {
    // return Carousel(listCard: listAuthor ?? []);
    return FutureBuilder(
      future: _loadTopAuthor(),
       builder: (context, snapshot) {
        if(snapshot.connectionState == ConnectionState.waiting)
        {
          return CircularProgressIndicator(color: Colors.pink,);
        }   
        else if(snapshot.hasError)
        {
          
          return Text("Có chút lỗi nho nhỏ khi load dữ liệu ^^!");
        }
        else
        {
          listAuthor = snapshot.data;
          if(listAuthor![0]["type"] != "error")
          {
            return Carousel(listCard: listAuthor!);
          }
          else{
            return Text("Tải danh sách tác giả thất bại. Thử lại sau !");
          }
        }
       },
    );
  }

  Future<List<Map<String,dynamic>>> _loadTopAuthor() async
  {
    
    var res = await AccountAPI.getTopAuthor();
    if(res["success"])
    {     
      // var pref = await SharedPreferences.getInstance();
      // pref.setString(KEY_HOME_AUTHOR, jsonEncode( res["data"]));
    
      return res["data"];
    }
      return [{"type": "error"}];
  }

  Future<List<List<Map<String,dynamic>>>> _loadTopic() async
  {
      var res = await AccountAPI.getTopicPublic();
      if(res["success"])
      {
        // var pref = await SharedPreferences.getInstance();
        // pref.setString(KEY_HOME_TOPIC, jsonEncode( res["data"]));
        return res["data"];
      }
      return [[{"type": "error"}]];
  }

  // Future<bool> isHasAuthor() async
  // {
  //   var pref = await SharedPreferences.getInstance();
  //   String? listAuthor = pref.getString(KEY_HOME_AUTHOR);

  //   if(listAuthor == null)
  //   {
  //     return false;
  //   }

  //   return true;

  // }
  // Future<bool> isHasTopic() async
  // {
  //   var pref = await SharedPreferences.getInstance();   
  //   String? listTopic =  pref.getString(KEY_HOME_TOPIC);

  //   if( listTopic == null)
  //   {
  //     return false;
  //   }
  //   return true;

  // }

}