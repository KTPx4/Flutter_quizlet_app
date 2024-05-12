import 'dart:convert';


import 'package:flutter/foundation.dart';

import '../models/account.dart';
import 'package:http/http.dart' as http;
import 'dart:io';

const WEB_URL = 'http://localhost:3000/api'; // kết nối từ web
const ANDROID_URL = 'http://10.0.2.2:3000/api'; // kết nối từ máy ảo android



class AccountAPI {
  static final AccountAPI _instance = AccountAPI._init();
  

  AccountAPI._init();
  
  factory AccountAPI()
  {
    return _instance;
  }
  static String getServer()
  {
    var url = ANDROID_URL;
    if(kIsWeb)
    {
      url = WEB_URL;
    }
    return url;
  }

  static Future<Map<String, dynamic>> isAuth({required String token}) async
  {
    try
    {
      var server = getServer();
      var link = "$server/account/validate";          

      var res = await http.get(
        Uri.parse(link),      
        headers: {"Authorization": "Bearer $token"}
      );

      var resBody = jsonDecode(res.body);    
     
      if(res.statusCode == 200)
      {
        return {'success': true, 'message': "Đã đăng nhập", 'account': resBody["data"]["account"]};
      }

      return {'success': false, 'message': resBody["message"], 'token': ''};
    }
    catch(e)
    {
      return {'success': false, 'message': "Chưa đăng nhập hoặc lỗi. Vui lòng thử lại sau!", 'token': ''};
    }  
  }
  
  static Future<Map<String, dynamic>> login({required String user, required password}) async
  {
    try
    {
      
      var server = getServer();
      var link = "$server/account/login";
      var body = {
        'user': user,
        'password': password
      };

      var res = await http.post(
        Uri.parse(link),      
        body: body
      );

      var resBody = jsonDecode(res.body);    
      
      if(res.statusCode == 200)
      {
        return {'success': true, 'message': "Đăng nhập thành công", 'token': resBody["data"]["token"]};
      }
      return {'success': false, 'message': resBody["message"], 'token': ''};
    }
    catch(e)
    {
      return {'success': false, 'message': "Đăng nhập thất bại. Vui lòng thử lại sau!", 'token': ''};
    }    
  }
  
  static Future<Map<String, dynamic>> getCode({required String email}) async
  {
    try
    {
      
      var server = getServer();
      var link = "$server/account/getcode";
      var body = {
        'email': email,       
      };

      var res = await http.post(
        Uri.parse(link),      
        body: body
      );

      var resBody = jsonDecode(res.body);    
      
      if(res.statusCode == 200)
      {
        return {'success': true, 'message': "Gửi yêu cầu thành công. Vui lòng kiểm tra email"};
      }
      
      return {'success': false, 'message': resBody["message"], 'token': ''};
    }
    catch(e)
    {
      return {'success': false, 'message': "Đăng nhập thất bại. Vui lòng thử lại sau!", 'token': ''};
    }    
  }
  
  static Future<Map<String, dynamic>> sendCode({required String email, required String code}) async
  {
    try
    {
      
      var server = getServer();
      var link = "$server/account/validcode";
      var body = {
        'email': email, 
        'code': code      
      };

      var res = await http.post(
        Uri.parse(link),    
        body: body
      );

      var resBody = jsonDecode(res.body);    
      
      if(res.statusCode == 200)
      {
        return {'success': true, 'message': "Gửi yêu cầu thành công. Vui lòng kiểm tra email", "token": resBody["data"]["token"]};
      }
      
      return {'success': false, 'message': resBody["message"], 'token': ''};
    }
    catch(e)
    {
      return {'success': false, 'message': "Đăng nhập thất bại. Vui lòng thử lại sau!", 'token': ''};
    }    
  }
  
  
  static Future<Map<String, dynamic>> ResetPass({required String token, required String newPass}) async
  {
    try
    {
      
      var server = getServer();
      var link = "$server/account/reset";
      var body = {
        'newPass': newPass,           
      };

      var res = await http.post(
        Uri.parse(link),  
        headers: {"Authorization": "Bearer $token"},    
        body: body
      );

      var resBody = jsonDecode(res.body);    
      
      if(res.statusCode == 200)
      {
        return {'success': true, 'message': "Khôi phục mật khẩu thành công. Vui lòng kiểm tra email", "token": resBody["data"]["token"]};
      }
      
      return {'success': false, 'message': resBody["message"], 'token': ''};
    }
    catch(e)
    {
      return {'success': false, 'message': "Đăng nhập thất bại. Vui lòng thử lại sau!", 'token': ''};
    }    
  }
  

  static Future<Map<String, dynamic>> register({ required String email, required password}) async
  {
    try
    {
      var server = getServer();
      var link = "$server/account/register";
      var body = {
        'email': email,
        'password': password
      };

      var res = await http.post(
        Uri.parse(link),      
        body: body
      );

      var resBody = jsonDecode(res.body);    
      
      if(res.statusCode == 200)
      {
        return {'success': true, 'message': "Đăng ký thành công"};
      }
      return {'success': false, 'message': resBody["message"],};
    }
    catch(e)
    {
      return {'success': false, 'message': "Đăng ký thất bại. Vui lòng thử lại sau!", };
    }    
  }


}