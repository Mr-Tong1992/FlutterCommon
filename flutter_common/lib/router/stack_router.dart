import 'package:flutter_boost/flutter_boost.dart';

class ToonRouter {

  static push(String url, {Map<dynamic,dynamic> urlParams, Map<dynamic,dynamic> exts}){
    FlutterBoost.singleton.open(url, urlParams: urlParams, exts: exts);
  }

  static pop(){

  }

  static present(){

  }

  static dismiss(){

  }

  static popup(){

  }
}