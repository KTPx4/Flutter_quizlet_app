import 'dart:convert';
import 'dart:io';

import 'package:client_app/models/folder.dart';
import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

const WEB_URL = 'http://localhost:3000'; // kết nối từ web
const ANDROID_URL = 'http://10.0.2.2:3000';
const KEY_LOGIN = "quizlet-login";

class PublicService {
  static final PublicService _instance = PublicService._init();

  PublicService._init();

  factory PublicService() {
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



}
