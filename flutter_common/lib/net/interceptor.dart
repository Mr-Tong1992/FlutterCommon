
import 'dart:convert';
import 'package:dio/dio.dart';
import 'package:flustars/flustars.dart';
import 'package:sprintf/sprintf.dart';
import '../utils/constant.dart';
import '../utils/log_utils.dart';
import '../net/error_handler.dart';


class AuthInterceptor extends Interceptor {

  @override
  onRequest(RequestOptions options) {
    String accessToken = SpUtil.getString(Constant.access_Token);
    if(accessToken.isNotEmpty) {
      options.headers["Authorization"] = SpUtil.getString(Constant.access_Token);
    }

    return super.onRequest(options);
  }
}

class LogginInterceptor extends Interceptor {
  DateTime startTime;
  DateTime endTime;

  @override
  onRequest(RequestOptions options) {
    startTime = DateTime.now();
    Log.d('>>> start request');
    Log.d("\n" + options.method + "\tUrl: " + options.baseUrl + options.path);
    Log.json(options.headers.toString(), tag: '请求头参数：');
    if(options.method == 'GET') {
      Log.json(options.data.toString(), tag: '请求入参：');
    }else{
      Log.json(Transformer.urlEncodeMap(options.queryParameters), tag: '请求入参');
    }
    return super.onRequest(options);
  }

  @override
  onResponse(Response response) {
    endTime = DateTime.now();
    int duration = endTime.difference(startTime).inMilliseconds;

    Log.json(response.data.toString(), tag: '请求结果：');
    Log.d(">>> end request : 耗时 $duration 毫秒");
  }

  @override
  onError(DioError error) {
    Log.d(">>> error");
    return super.onError(error);
  }
}

class AdapterInterceptor extends Interceptor {

  static const String MSG = "msg";
  static const String SLASH = "\"";
  static const String MESSAGE = "message";

  static const String DEFAULT = "\"无返回信息\"";
  static const String NOT_FOUND = "未找到查询信息";

  static const String FAILURE_FORMAT = "{\"code\":%d,\"message\":\"%s\"}";
  static const String SUCCESS_FORMAT = "{\"code\":0,\"data\":%s,\"message\":\"\"}";

  @override
  onResponse(Response response) {
    Response r = adapterData(response);
    return super.onResponse(r);
  }

  @override
  onError(DioError error) {
    if(error.response != null) {
      adapterData(error.response);
    }
    return super.onError(error);
  }

  Response adapterData(Response response) {
    return response;
  }
}