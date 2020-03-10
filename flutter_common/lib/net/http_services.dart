import 'dart:convert';
import 'package:dio/dio.dart';
import 'package:flutter/services.dart';
import 'interceptor.dart';
import '../utils/constant.dart';
import '../net/base_entity.dart';
import '../net/error_handler.dart';
import '../utils/log_utils.dart';
import 'package:flutter_plugin/flutter_plugin.dart';

class HTTPServices {
  static final HTTPServices _singleton = HTTPServices._internal();
  static HTTPServices get instance => HTTPServices();

  factory HTTPServices() {
    return _singleton;
  }

  static Dio _dio;

  Dio getDio() {
    return _dio;
  }

  HTTPServices._internal() {
   _initDioClient();
  }

  Options _requestOptions = new Options(
    connectTimeout: 15000,
    receiveTimeout: 15000,
    responseType: ResponseType.plain,

    validateStatus: (status) {
      // 不使用HTTP状态码判断状态，使用AdapterInterceptor来处理（适用于标准REST风格）
      return true;
    },
  );


  _initDioClient() async {
    _dio = Dio();

    // 统一添加身份验证请求头
    _dio.interceptors.add(AuthInterceptor());
    // 打印Log
    if(!Constant.inProduction) {
      _dio.interceptors.add(LogginInterceptor());
    }
    // 适配数据
    _dio.interceptors.add(AdapterInterceptor());

    // 抓包代理配置
//    (_dio.httpClientAdapter as DefaultHttpClientAdapter).onHttpClientCreate = (HttpClient client) {
//      client.findProxy = (uri) {
//        return "PROXY 192.168.106:8080";
//      };
//      client.badCertificateCallback = (X509Certificate cert, String host, int port) => true;
//    };

    //获取通用参数
    Map<dynamic, dynamic> params = await FlutterPlugin.requestHeaders();
    _requestOptions.headers = new Map<String, dynamic>.from(params);
  }

  /// ===============================================
  /// 更新Request Header
  /// ===============================================
  void updateRequestHeaders(Map<String, dynamic> headers) {
    headers.forEach((String key, dynamic value){
      _requestOptions.headers[key] = value ?? "";
    });
  }

  /// ===============================================
  /// Get请求
  /// ===============================================
  Future<void> startGetRequest<T>(
      String domain,
      String path,
      {
        Map<String, dynamic> params,
        Function(BaseEntity<T> t) onSuccess,
        Function(int code, String msg) onError,
        CancelToken cancelToken,
        Options options
      }) async {
    return request(Method.get, domain, path, queryParameters: params, onSuccess: onSuccess, onError: onError, cancelToken: cancelToken, options: options);
  }

  /// ===============================================
  /// Post请求
  /// ===============================================
  Future<void> startPostRequest<T>(
      String domain,
      String path,
      {
        Map<String, dynamic> params,
        Map<String, dynamic> queryParameters,
        Function(BaseEntity<T> t) onSuccess,
        Function(int code, String msg) onError,
        CancelToken cancelToken,
        Options options
      }) async {
    return request(Method.post, domain, path, params: params, onSuccess: onSuccess, onError: onError, cancelToken: cancelToken, options: options,queryParameters: queryParameters);
  }

  /// ===============================================
  /// Reqeust
  /// ===============================================
  Future<void> request<T>(
      Method method,
      String domain,
      String path,
      {
        Function(BaseEntity<T> t) onSuccess,
        Function(int code, String msg) onError,
        dynamic params,
        Map<String, dynamic> queryParameters,
        CancelToken cancelToken,
        Options options
      }) async {

    String m = _getRequestMethod(method);
    return await _request<T>(m, domain, path,
        data: params,
        queryParameters: queryParameters,
        options: options,
        cancelToken: cancelToken).then((BaseEntity<T> result){
      if (result.code == 0) {
        if (onSuccess != null) {
          onSuccess(result);
        }
      } else {
        _onError(result.code, result.message, onError);
      }
    }, onError: (e, _) {
      _cancelLogPrint(e, domain+path);
      Error error = ExceptionHandler.handleException(e);
      _onError(error.code, error.msg, onError);
    });
  }

  Future<BaseEntity<T>> _request<T>(
      String method,
      String domain,
      String path,
      {
        dynamic data,
        Map<String, dynamic> queryParameters,
        CancelToken cancelToken,
        Options options
      }) async {

    final String ip = await FlutterPlugin.getIP(domain);
    String url =  ip + path;

    var response = await _dio.request(url, data: data, queryParameters: queryParameters, options: _checkOptions(method, options), cancelToken: cancelToken);

    int _code;
    String _msg;
    T _data;

    try{
      Map<String, dynamic> _map = json.decode(response.data.toString());
      _code = _map[Constant.code];
      _msg = _map[Constant.message];
      _data = _map[Constant.data] as T;

    }catch (e) {
      print(e);
      return BaseEntity(ExceptionHandler.parse_error, "数据解析错误", _data);
    }
    return BaseEntity(_code, _msg, _data);
  }

  Options _checkOptions(method, options) {
    if(options == null) {
      options = _requestOptions;
    }

    options.method = method;
    return options;
  }

  _cancelLogPrint(dynamic e, String url) {
    if (e is DioError && CancelToken.isCancel(e)) {
      Log.d("取消请求接口: $url");
    }
  }

  _onError(int code, String msg, Function(int code, String msg) onError) {
    Log.d("接口异常：code: $code, msg: $msg");
    if(onError != null) {
      onError(code, msg);
    }
  }

  String _getRequestMethod(Method method){
    String m;
    switch(method){
      case Method.get:
        m = "GET";
        break;
      case Method.post:
        m = "POST";
        break;
      case Method.put:
        m = "PUT";
        break;
      case Method.patch:
        m = "PATCH";
        break;
      case Method.delete:
        m = "DELETE";
        break;
    }
    return m;
  }
}

enum Method {
  get,
  post,
  put,
  patch,
  delete,
}