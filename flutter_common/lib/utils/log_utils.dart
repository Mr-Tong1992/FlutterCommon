import '../utils/constant.dart';
//import 'package:toon_plugin/toon_plugin.dart';
import 'package:flutter_plugin/flutter_plugin.dart';

class Log {

  static d(String msg, {tag: '>>>'}) {
    if(!Constant.inProduction) {
      FlutterPlugin.platLog({'tag': tag, 'msg': msg});
    }
  }

  static json(String msg, {tag: '>>>'}) {
    if (!Constant.inProduction) {
      FlutterPlugin.jsonLog({'tag': tag, 'msg': msg});
    }
  }
}