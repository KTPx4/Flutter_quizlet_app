

import 'dart:convert';

import 'package:client_app/models/Server.dart';
import 'package:http_parser/http_parser.dart';

import 'package:dio/dio.dart' ;

import 'package:http/http.dart' as http;


import 'dart:io';

import 'package:shared_preferences/shared_preferences.dart';



const WEB_URL = 'http://localhost:3000/api'; // kết nối từ web
const ANDROID_URL = 'http://10.0.2.2:3000/api'; // kết nối từ máy ảo android
// const ANDROID_URL = 'https://flutter-quizlet-app.onrender.com/api'; // kết nối từ máy ảo android
// const WEB_URL = 'https://flutter-quizlet-app.onrender.com/api'; // kết nối từ web

const KEY_LOGIN = "quizlet-login";


class WebAPI {
  static final WebAPI _instance = WebAPI._init();

  static var dio = Dio();

  WebAPI._init();
  
  factory WebAPI()
  {
    return _instance;
  }
  
  static String getServer() {
    return ServerAPI.GetServer();
  }

  static String getLink() {
    return ServerAPI.GetLink();
  }

  static Future<Map<String, dynamic>> changeAvtWeb({required List<int> file, required String fileName}) async 
  {
    if (file.isEmpty) {    
      return {'success': false, 'message': "Không tồn tại ảnh"};
    }
    // Gửi request và nhận phản hồi
    try{

      var pref = await SharedPreferences.getInstance();
      String? token = pref.getString(KEY_LOGIN);

      if(token == null) return {'success': false, 'message': "Chưa đăng nhập hoặc hết hạn",};

      var server = getServer();
      var link = "$server/account/Avt";

      var request = http.MultipartRequest('PUT', Uri.parse(link));


      // Tạo multipart file từ bytes
      request.files.add(http.MultipartFile.fromBytes(
        'avt', // Tên trường dùng để gửi file
        file,
        filename: fileName,
        contentType: MediaType('image', 'jpeg'), // Thay đổi contentType phù hợp với loại file
      ));
      // Add header - Authorization
      request.headers.addAll({
        'Authorization': 'Bearer $token',
        'Content-Type': 'multipart/form-data',
      });

      var streamedResponse = await request.send();

      var stream = await streamedResponse.stream.bytesToString();
      var res = jsonDecode(stream);
      
      // Store account after update
      var account = res["data"]["account"];
      pref?.setString("Account", jsonEncode(account));

      if (streamedResponse.statusCode == 200) 
      {     
        return {'success': true, 'message': "Cập nhật ảnh thành công"};
      } 
      else {
        return {'success': false, 'message': res["message"]};
        // throw Exception('Failed to upload avatar');
      }
    }
    catch(e)
    {
      print("Err: "+ e.toString());
      return {'success': false, 'message': "Lỗi Server! Vui lòng thử lại sau"};
    }

   
    


    
  }
    
}
