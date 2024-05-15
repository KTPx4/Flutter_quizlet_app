import 'dart:convert';
import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

const WEB_URL = 'http://localhost:3000'; // kết nối từ web
const ANDROID_URL = 'http://10.0.2.2:3000'; // kết nối từ máy ảo android
// const ANDROID_URL = 'https://flutter-quizlet-app.onrender.com'; // kết nối từ máy ảo android
// const WEB_URL = 'https://flutter-quizlet-app.onrender.com'; // kết nối từ web

const KEY_LOGIN = "quizlet-login";

class AccountAPI {
  static final AccountAPI _instance = AccountAPI._init();

  AccountAPI._init();

  factory AccountAPI() {
    return _instance;
  }
  static String getServer() {
    var url = ANDROID_URL;
    if (kIsWeb || Platform.isWindows || Platform.isMacOS || Platform.isLinux) {
      url = WEB_URL;
    }
    return url;
  }

  static String getLink() {
    var url = ANDROID_URL + "/api";
    if (kIsWeb || Platform.isWindows || Platform.isMacOS || Platform.isLinux) {
      url = WEB_URL + "/api";
    }
    return url;
  }

  static Future<Map<String, dynamic>> isAuth({required String token}) async {
    try {
      var server = getLink();
      var link = "$server/account/validate";

      var res = await http
          .get(Uri.parse(link), headers: {"Authorization": "Bearer $token"});

      var resBody = jsonDecode(res.body);

      if (res.statusCode == 200) {
        return {
          'success': true,
          'message': "Đã đăng nhập",
          'account': resBody["data"]["account"]
        };
      }

      return {'success': false, 'message': resBody["message"], 'token': ''};
    } catch (e) {
      return {
        'success': false,
        'message': "Chưa đăng nhập hoặc lỗi. Vui lòng thử lại sau!",
        'token': ''
      };
    }
  }

  static Future<Map<String, dynamic>> login(
      {required String user, required password}) async {
    try {
      var server = getLink();
      var link = "$server/account/login";
      var body = {'user': user, 'password': password};

      var res = await http.post(Uri.parse(link), body: body);

      var resBody = jsonDecode(res.body);

      if (res.statusCode == 200) {
        return {
          'success': true,
          'message': "Đăng nhập thành công",
          'token': resBody["data"]["token"]
        };
      }
      return {'success': false, 'message': resBody["message"], 'token': ''};
    } catch (e) {
      return {
        'success': false,
        'message': "Đăng nhập thất bại. Vui lòng thử lại sau!",
        'token': ''
      };
    }
  }

  static Future<Map<String, dynamic>> getCode({required String email}) async {
    try {
      var server = getLink();
      var link = "$server/account/getcode";
      var body = {
        'email': email,
      };

      var res = await http.post(Uri.parse(link), body: body);

      var resBody = jsonDecode(res.body);

      if (res.statusCode == 200) {
        return {
          'success': true,
          'message': "Gửi yêu cầu thành công. Vui lòng kiểm tra email"
        };
      }

      return {'success': false, 'message': resBody["message"], 'token': ''};
    } catch (e) {
      return {
        'success': false,
        'message': "Đăng nhập thất bại. Vui lòng thử lại sau!",
        'token': ''
      };
    }
  }

  static Future<Map<String, dynamic>> sendCode(
      {required String email, required String code}) async {
    try {
      var server = getLink();
      var link = "$server/account/validcode";
      var body = {'email': email, 'code': code};

      var res = await http.post(Uri.parse(link), body: body);

      var resBody = jsonDecode(res.body);

      if (res.statusCode == 200) {
        return {
          'success': true,
          'message': "Vui lòng nhập mật khẩu mới",
          "token": resBody["data"]["token"]
        };
      }

      return {'success': false, 'message': resBody["message"], 'token': ''};
    } catch (e) {
      return {
        'success': false,
        'message': "Đăng nhập thất bại. Vui lòng thử lại sau!",
        'token': ''
      };
    }
  }

  static Future<Map<String, dynamic>> resetPass(
      {required String token, required String newPass}) async {
    try {
      var server = getLink();
      var link = "$server/account/reset";
      var body = {
        'newPass': newPass,
      };

      var res = await http.post(Uri.parse(link),
          headers: {"Authorization": "Bearer $token"}, body: body);

      var resBody = jsonDecode(res.body);

      if (res.statusCode == 200) {
        return {
          'success': true,
          'message': "Khôi phục mật khẩu thành công. Vui lòng đăng nhập lại"
        };
      }

      return {'success': false, 'message': resBody["message"]};
    } catch (e) {
      return {
        'success': false,
        'message': "Đổi mật khẩu thất bại. Vui lòng thử lại sau!",
        'token': ''
      };
    }
  }

  static Future<Map<String, dynamic>> register(
      {required String email, required password}) async {
    try {
      var server = getLink();
      var link = "$server/account/register";
      var body = {'email': email, 'password': password};

      var res = await http.post(Uri.parse(link), body: body);

      var resBody = jsonDecode(res.body);

      if (res.statusCode == 200) {
        return {'success': true, 'message': "Đăng ký thành công"};
      }
      return {
        'success': false,
        'message': resBody["message"],
      };
    } catch (e) {
      return {
        'success': false,
        'message': "Đăng ký thất bại. Vui lòng thử lại sau!",
      };
    }
  }

  static Future<Map<String, dynamic>> changePass(
      {required String oldPass, required String newPass}) async {
    try {
      var pref = await SharedPreferences.getInstance();
      String? token = pref.getString(KEY_LOGIN);

      if (token == null)
        return {
          'success': false,
          'message': "Không thể đổi mật khẩu",
        };

      var server = getLink();
      var link = "$server/account/changepass";
      var body = {'oldPass': oldPass, 'newPass': newPass};

      var res = await http.post(Uri.parse(link),
          headers: {"Authorization": "Bearer $token"}, body: body);

      var resBody = jsonDecode(res.body);

      if (res.statusCode == 200) {
        var newtoken = resBody["data"]['token'];
        if (newtoken != null) pref?.setString(KEY_LOGIN, newtoken);

        return {'success': true, 'message': "Đổi mật khẩu thành công"};
      }

      return {'success': false, 'message': resBody["message"]};
    } catch (e) {
      return {
        'success': false,
        'message': "Đổi mật khẩu thất bại. Vui lòng thử lại sau!",
      };
    }
  }

  static Future<Map<String, dynamic>> changeEmail(
      {required String email}) async {
    try {
      var pref = await SharedPreferences.getInstance();
      String? token = pref.getString(KEY_LOGIN);

      if (token == null)
        return {
          'success': false,
          'message': "Chưa đăng nhập. Vui lòng đăng nhập lại",
        };

      var server = getLink();
      var link = "$server/account/";
      var body = {'email': email};

      var res = await http.patch(Uri.parse(link),
          headers: {"Authorization": "Bearer $token"}, body: body);

      var resBody = jsonDecode(res.body);

      if (res.statusCode == 200) {
        var Account = resBody["data"]["account"];
        var account = jsonEncode(Account) ?? "";

        var newtoken = resBody["data"]['token'];

        pref?.setString("Account", account);
        if (newtoken != null) pref?.setString(KEY_LOGIN, newtoken);

        return {'success': true, 'message': "Cập nhật thành công"};
      }

      return {'success': false, 'message': resBody["message"]};
    } catch (e) {
      return {
        'success': false,
        'message': "Cập nhật thất bại. Vui lòng thử lại sau!",
      };
    }
  }

  static Future<Map<String, dynamic>> changeName({required String name}) async {
    try {
      var pref = await SharedPreferences.getInstance();
      String? token = pref.getString(KEY_LOGIN);

      if (token == null)
        return {
          'success': false,
          'message': "Chưa đăng nhập hoặc hết hạn",
        };

      var server = getLink();
      var link = "$server/account/";
      var body = {'fullName': name};

      var res = await http.patch(Uri.parse(link),
          headers: {"Authorization": "Bearer $token"}, body: body);

      var resBody = jsonDecode(res.body);

      if (res.statusCode == 200) {
        var Account = resBody["data"]["account"];
        var account = jsonEncode(Account) ?? "";
        var newtoken = resBody["data"]['token'];

        pref?.setString("Account", account);
        if (newtoken != null) pref?.setString(KEY_LOGIN, newtoken);

        return {'success': true, 'message': "Cập nhật thành công"};
      }

      return {'success': false, 'message': resBody["message"]};
    } catch (e) {
      return {
        'success': false,
        'message': "Cập nhật thất bại. Vui lòng thử lại sau!",
      };
    }
  }

  static Future<Map<String, dynamic>> changeAvt({required String path}) async {
    try {
      var pref = await SharedPreferences.getInstance();
      String? token = pref.getString(KEY_LOGIN);

      var server = getLink();
      var link = "$server/account/Avt";

      var uri = Uri.parse(link);
      var request = http.MultipartRequest('PUT', uri)
        ..headers['Authorization'] = 'Bearer ${token}'
        ..files.add(await http.MultipartFile.fromPath('avt', path));

      var res = await request.send();
      var response = await http.Response.fromStream(res);
      var resBody = jsonDecode(response.body);

      if (res.statusCode == 200) {
        var Account = resBody["data"]["account"];
        var account = jsonEncode(Account) ?? "";

        pref?.setString("Account", account);

        return {'success': true, 'message': "Cập nhật ảnh thành công"};
      }
      return {'success': false, 'message': resBody["message"]};
    } catch (e) {
      return {
        'success': false,
        'message': "Cập nhật ảnh thất bại. Vui lòng thử lại sau!",
      };
    }
  }

  // static Future<Map<String, dynamic>> getAccount() async {
  //   try {
  //     var server = getLink();
  //     var link = "$server/account";
  //     var pref = await SharedPreferences.getInstance();
  //     String? token = pref.getString(KEY_LOGIN);
  //
  //     var res = await http.get(
  //       Uri.parse(link),
  //       headers: {"Authorization": "Bearer $token"},
  //     );
  //
  //     var resBody = jsonDecode(res.body);
  //
  //     if (res.statusCode == 200) {
  //       return {'success': true, 'account': Account.fromJson(resBody["data"])};
  //     }
  //
  //     return {'success': false, 'message': resBody["message"]};
  //   } catch (e) {
  //     return {
  //       'success': false,
  //       'message': "Failed to fetch account. Please try again later!",
  //       'exception': e.toString(),
  //     };
  //   }
  // }
}
