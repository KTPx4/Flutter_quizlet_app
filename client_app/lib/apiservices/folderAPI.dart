import 'dart:convert';
import 'dart:io';

import 'package:client_app/models/Server.dart';
import 'package:client_app/models/folder.dart';
import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

const WEB_URL = 'http://localhost:3000'; // kết nối từ web
const ANDROID_URL = 'http://10.0.2.2:3000';
const KEY_LOGIN = "quizlet-login";

class FolderAPI {
  static final FolderAPI _instance = FolderAPI._init();

  FolderAPI._init();

  factory FolderAPI() {
    return _instance;
  }
  
  static String getServer() {
    return ServerAPI.GetServer();
  }

  static String getLink() {
    return ServerAPI.GetLink();
  }

  // Add a new folder
  static Future<Map<String, dynamic>> addFolder(Folder folder) async {
    try {
      var link = "${getLink()}/folder";
      var pref = await SharedPreferences.getInstance();
      String? token = pref.getString(KEY_LOGIN);

      var body = jsonEncode({
        'folderName': folder.folderName,
        'desc': folder.desc,
      });

      var res = await http.post(
        Uri.parse(link),
        headers: {
          "Authorization": "Bearer $token",
          "Content-Type": "application/json"
        },
        body: body,
      );

      var resBody = jsonDecode(res.body);

      if (res.statusCode == 200) {
        return {'success': true, '_id': resBody["data"]["_id"]};
      }

      return {'success': false, 'message': resBody["message"]};
    } catch (e) {
      return {
        'success': false,
        'message': "Failed to add folder. Please try again later!",
        'exception': e.toString(),
      };
    }
  }

  // Get all folders
  static Future<Map<String, dynamic>> getFolders() async {
    try {
      var link = "${getLink()}/folder";
      var pref = await SharedPreferences.getInstance();
      String? token = pref.getString(KEY_LOGIN);

      var res = await http.get(
        Uri.parse(link),
        headers: {"Authorization": "Bearer $token"},
      );

      var resBody = jsonDecode(res.body);

      if (res.statusCode == 200) {
        return {'success': true, 'folders': resBody["data"]};
      }

      return {'success': false, 'message': resBody["message"]};
    } catch (e) {
      return {
        'success': false,
        'message': "Failed to fetch folders. Please try again later!",
        'exception': e.toString(),
      };
    }
  }

  static Future<Map<String, dynamic>> getFolderById(String id) async {
    try {
      var link = "${getLink()}/folder/$id";
      var pref = await SharedPreferences.getInstance();
      String? token = pref.getString(KEY_LOGIN);

      var res = await http.get(
        Uri.parse(link),
        headers: {"Authorization": "Bearer $token"},
      );

      var resBody = jsonDecode(res.body);

      if (res.statusCode == 200) {
        return {'success': true, 'data': resBody["data"]};
      }

      return {'success': false, 'message': resBody["message"]};
    } catch (e) {
      return {
        'success': false,
        'message': "Failed to fetch folder. Please try again later!",
        'exception': e.toString(),
      };
    }
  }

  // Delete a folder
  static Future<Map<String, dynamic>> deleteFolder(String id) async {
    try {
      var link = "${getLink()}/folder/$id";
      var pref = await SharedPreferences.getInstance();
      String? token = pref.getString(KEY_LOGIN);

      var res = await http.delete(
        Uri.parse(link),
        headers: {"Authorization": "Bearer $token"},
      );

      var resBody = jsonDecode(res.body);

      if (res.statusCode == 200) {
        return {'success': true, 'message': "Folder deleted successfully"};
      }

      return {'success': false, 'message': resBody["message"]};
    } catch (e) {
      return {
        'success': false,
        'message': "Failed to delete folder. Please try again later!",
        'exception': e.toString(),
      };
    }
  }

  static Future<String> addTopicsToFolder(
      String folderId, List<String> topicIds) async {
    var link = "${getLink()}/folder/$folderId/topic/";
    var pref = await SharedPreferences.getInstance();
    String? token = pref.getString(KEY_LOGIN);

    var body = jsonEncode({
      'topics': topicIds,
    });

    var res = await http.post(
      Uri.parse(link),
      headers: {
        "Authorization": "Bearer $token",
        "Content-Type": "application/json"
      },
      body: body,
    );

    var resBody = jsonDecode(res.body);

    if (res.statusCode == 200) {
      return "Topics added to folder successfully!";
    } else {
      throw Exception(
          "Failed to add topics to folder , topic already exists in folder. Please try again later!");
    }
  }

  static Future<Map<String, dynamic>> removeTopicFromFolder(
      String folderId, String topicId) async {
    try {
      var link = "${getLink()}/folder/$folderId/topic/$topicId";
      var pref = await SharedPreferences.getInstance();
      String? token = pref.getString(KEY_LOGIN);

      var res = await http.delete(
        Uri.parse(link),
        headers: {"Authorization": "Bearer $token"},
      );

      var resBody = jsonDecode(res.body);

      if (res.statusCode == 200) {
        return {'success': true, 'data': resBody["data"]};
      }

      return {'success': false, 'message': resBody["message"]};
    } catch (e) {
      return {
        'success': false,
        'message':
            "Failed to remove topic from folder. Please try again later!",
        'exception': e.toString(),
      };
    }
  }

  static Future<Map<String, dynamic>> editFolder(
      String id, Folder folder) async {
    try {
      var link = "${getLink()}/folder/$id";
      var pref = await SharedPreferences.getInstance();
      String? token = pref.getString(KEY_LOGIN);

      var body = jsonEncode({
        'folderName': folder.folderName,
        'desc': folder.desc,
      });

      var res = await http.patch(
        Uri.parse(link),
        headers: {
          "Authorization": "Bearer $token",
          "Content-Type": "application/json"
        },
        body: body,
      );

      var resBody = jsonDecode(res.body);

      if (res.statusCode == 200) {
        return {
          'success': true,
          'message': resBody["message"],
          '_id': resBody["data"]["_id"]
        };
      }

      return {'success': false, 'message': resBody["message"]};
    } catch (e) {
      return {
        'success': false,
        'message': "Failed to edit folder. Please try again later!",
        'exception': e.toString(),
      };
    }
  }
}
