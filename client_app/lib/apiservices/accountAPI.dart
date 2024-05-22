import 'dart:convert';
import 'dart:io';

import 'package:client_app/models/Server.dart';
import 'package:client_app/models/account.dart';
import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

const WEB_URL = 'http://localhost:3000'; // kết nối từ web
const ANDROID_URL = 'http://10.0.2.2:3000'; // kết nối từ máy ảo android
// const ANDROID_URL = 'http://192.168.0.108:3000'; // kết nối từ máy ảo android

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
    return ServerAPI.GetServer();
  }

  static String getLink() {
    return ServerAPI.GetLink();
  }

  static Future<Map<String, dynamic>> isAuth({required String token}) async {
    try {
      var server = getLink();
      var link = "$server/account/validate";

      var res = await http
          .get(Uri.parse(link), headers: {"Authorization": "Bearer $token"});

      var resBody = jsonDecode(res.body);

      if (res.statusCode == 200) {
        var pref = await SharedPreferences.getInstance();
        var account = jsonEncode(resBody["data"]["account"]) ?? "";
        pref?.setString("Account", account);

        return {
          'success': true,
          'message': "Đã đăng nhập",
          'account': resBody["data"]["account"]
        };
      }
      return {
        'success': false,
        'message': resBody["message"],
        'token': '',
        'notConnect': false
      };
    } catch (e) {
      var notConnect = e.toString().contains("Connection failed");

      return {
        'success': false,
        'message': "Chưa đăng nhập hoặc lỗi. Vui lòng thử lại sau!",
        'token': '',
        'notConnect': notConnect
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
        var restoken = resBody["data"]["token"];
        var token = jsonEncode(restoken) ?? "";
        var pref = await SharedPreferences.getInstance();
        if (token != null) pref?.setString(KEY_LOGIN, token);

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
        'token': e
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

  static Future<Map<String, dynamic>> getAccountById(String id) async {
    try {
      var server = getLink();
      var link = "$server/account/$id";

      var res = await http.get(Uri.parse(link));

      var resBody = jsonDecode(res.body);

      if (res.statusCode == 200) {
        return {
          'success': true,
          'message': resBody["message"],
          'account': AccountModel.fromJson(resBody["data"]),
        };
      }

      return {'success': false, 'message': resBody["message"]};
    } catch (e) {
      return {
        'success': false,
        'message': "Failed to fetch account. Please try again later!",
        'exception': e.toString(),
      };
    }
  }

  static Future<Map<String, dynamic>> getAllAccounts() async {
    try {
      var server = getLink();
      var link = "$server/account";

      var res = await http.get(Uri.parse(link));

      var resBody = jsonDecode(res.body);

      if (res.statusCode == 200) {
        List<AccountModel> accounts = [];
        for (var account in resBody["data"]) {
          accounts.add(AccountModel.fromJson(account));
        }
        return {
          'success': true,
          'message': resBody["message"],
          'accounts': accounts,
        };
      } else {
        return {
          'success': false,
          'message': resBody["message"],
        };
      }
    } catch (e) {
      return {
        'success': false,
        'message': "Failed to fetch accounts. Please try again later!",
      };
    }
  }

  static Future<Map<String, dynamic>> getTopAuthor() async {
    try {
      var server = getLink();
      var link = "$server/account/topauthor";

      var res = await http.get(Uri.parse(link));

      var resBody = jsonDecode(res.body);

      if (res.statusCode == 200) {
        var listAccount = resBody["data"];
        List<Map<String, dynamic>> listResult = [];
        for (var i in listAccount) {
          listResult.add({
            "count": i["count"],
            "id": i["authorID"],
            "author": i["account"]["user"],
            "imgAuthor":
                "${getServer()}/images/account/${i["authorID"]}/${i["account"]["nameAvt"]}",
            "type": "author"
          });
        }

        return {
          'success': true,
          'message': "Lấy thành công top tác giả",
          'data': listResult
        };
      } else {
        return {
          'success': false,
          'message': "Vui lòng tải lại trang",
        };
      }
    } catch (e) {
      return {
        'success': false,
        'message': "Failed to fetch top author. Please try again later!",
      };
    }
  }

  static Future<Map<String, dynamic>> getTopicPublic() async {
    try {
      var pref = await SharedPreferences.getInstance();
      String? token = pref.getString(KEY_LOGIN);

      var server = getLink();
      var link = "$server/topic/publicv2";

      var res = await http
          .get(Uri.parse(link), headers: {"Authorization": "Bearer $token"});

      var resBody = jsonDecode(res.body);

      if (res.statusCode == 200) {
        var listAccount = resBody["data"];

        List<List<Map<String, dynamic>>> listResult = [];

        for (var i in listAccount) {
          var accountID = i["authorID"];

          var Account =
              await http.get(Uri.parse("${getLink()}/account/$accountID"));

          var data = jsonDecode(Account.body)["data"];

          var user = data["user"];
          var img = data["nameAvt"];

          var ListTopics = i["topics"];
          List<Map<String, dynamic>> temList = [];

          for (var j in ListTopics) {
            var t = {
              "author": "$user",
              "id": "${j["_id"]}",
              "imgAuthor": "${getServer()}/images/account/$accountID/$img",
              "type": "topic",
              "title": "${j["topicName"]}",
              "count": j["countWords"]
            };
            temList.add(t);
          }

          listResult.add(temList);
        }

        return {
          'success': true,
          'message': "Lấy thành công top tác giả",
          'data': listResult
        };
      } else {
        return {
          'success': false,
          'message': "Vui lòng tải lại trang",
        };
      }
    } catch (e) {
      print(e);
      return {
        'success': false,
        'message': "Failed to fetch top author. Please try again later!",
      };
    }
  }

  static Future<Map<String, dynamic>> getTopicPublicv2() async {
    try {
      var pref = await SharedPreferences.getInstance();
      String? token = pref.getString(KEY_LOGIN);

      var server = getLink();
      var link = "$server/topic/publicv3";

      var res = await http
          .get(Uri.parse(link), headers: {"Authorization": "Bearer $token"});

      var resBody = jsonDecode(res.body);

      if (res.statusCode == 200) {
        var listTopics = resBody["data"];

        List<Map<String, dynamic>> listResult = [];

        for (var i in listTopics) {
          var accountID = i["authorID"];

          var Account =
              await http.get(Uri.parse("${getLink()}/account/$accountID"));

          var data = jsonDecode(Account.body)["data"];

          var user = data["user"];
          var img = data["nameAvt"];

          var ListTopics = i["topics"];

          var t = {
            "author": "$user",
            "id": "${i["_id"]}",
            "imgAuthor": "${getServer()}/images/account/$accountID/$img",
            "type": "topic",
            "title": "${i["topicName"]}",
            "count": i["countWords"],
            "createAt": i["createAt"],
            "countStuy": i["studyCount"],
            "publicStudy": i["publicStudy"]
          };

          listResult.add(t);
        }

        return {
          'success': true,
          'message': "Lấy thành công danh sách cộng đồng",
          'data': listResult
        };
      } else {
        return {
          'success': false,
          'message': "Vui lòng tải lại trang",
          'notConnect': false
        };
      }
    } catch (e) {
      print(e);
      var notConnect = e.toString().contains("Connection failed");
      return {
        'success': false,
        'message': "Failed to fetch top author. Please try again later!",
        'notConnect': notConnect
      };
    }
  }
}
