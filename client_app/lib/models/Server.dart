import 'dart:io';

import 'package:flutter/foundation.dart';

const WEB_URL = 'https://flutter-quizlet-app.onrender.com'; // kết nối từ web
// const ANDROID_URL = 'http://10.0.2.2:3000'; // kết nối từ máy ảo android
const ANDROID_URL = 'https://flutter-quizlet-app.onrender.com';

class ServerAPI{
  static final ServerAPI _instance = ServerAPI._init();
  ServerAPI._init();

  factory ServerAPI()
  {
    return _instance;
  }

  static String GetServer()
  {
    var url = ANDROID_URL;
    if (kIsWeb || Platform.isWindows || Platform.isMacOS || Platform.isLinux) {
      url = WEB_URL;
    }
    return url;
  }

  static String GetLink() {   
    return (GetServer() + "/api");
  }

}