import 'package:client_app/middleware/PlatformRun.dart';
import 'package:flutter_web_plugins/flutter_web_plugins.dart';

class WebPlatform implements PlatformRun{
  @override
  void main()
  {
    setUrlStrategy(PathUrlStrategy());
  }
  
}