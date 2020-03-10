import 'dart:ui';

class Constant {

  // debug开关，上线需要关闭
  // App运行在Release环境时，inProduction为true；当App运行在Debug和Profile环境时，inProduction为false
  static const bool inProduction  = const bool.fromEnvironment("dart.vm.product");

  static const String data = 'data';
  static const String message = 'message';
  static const String code = 'code';

  static const String access_Token = 'accessToken';


  /// 屏幕宽度
  static double screenWidth(){
    return window.physicalSize.width / 2.0;
  }

  /// 屏幕高度
  static double screenHeight(){
    return window.physicalSize.height / 2.0;
  }

  /// iPhoneX尺寸
  static bool isiPhoneX(){
    double height = screenHeight();
    return (height == 812 || height == 896 || height == 1093.5) ? true : false;
  }

  /// iPhone 5尺寸
  static bool isiPhone5(){
    double width = screenWidth();
    return (width == 320.0) ? true : false;
  }

  /// iPhone 6、7、8尺寸
  static bool isiPhone8(){
    double width = screenWidth();
    return (width == 375.0) ? true : false;
  }

  /// iPhone 6 Plus尺寸
  static bool isiPhone6Plus(){
    double width = screenWidth();
    return (width == 414.0) ? true : false;
  }

  /// 状态栏高度
  static double statusBarHeight(){
    return isiPhoneX() ? 44.0 : 20.0;
  }

  /// 导航栏高度
  static double navigationBarHeight(){
    return isiPhoneX() ? 88.0 : 64.0;
  }
}

