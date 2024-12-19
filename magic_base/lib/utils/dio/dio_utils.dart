import 'package:dio/dio.dart';
import 'package:magic_base/utils/dio/dio_result.dart';

class DioUtils{
  factory DioUtils() => _getInstance();
  static DioUtils get instance => _getInstance();
  static DioUtils? _instance;
  static DioUtils _getInstance() {
    _instance ??= DioUtils._internal();
    return _instance!;
  }
  DioUtils._internal(){
    if (_dio == null) {
      BaseOptions options = BaseOptions(
        responseType: ResponseType.json,
        receiveDataWhenStatusError: false,
        connectTimeout: const Duration(milliseconds: 30000),
        receiveTimeout: const Duration(milliseconds: 30000),
      );
      _dio = Dio(options);
    }
  }

  Dio? _dio;

  Future<DioResult> requestGet({required String url,}) async{
    try{
      var response = await _dio?.request<String>(
          url,
          options: Options(method: "get")
      );
      if(response?.statusCode==200){
        return DioResult(success: true, result: response?.data?.toString()??"");
      }else{
        return DioResult(success: false, result: "");
      }
    }catch(e){
      return DioResult(success: false, result: "");
    }
  }

  Future<DioResult> requestPost({
    required String url,
    required Map<String, dynamic> dataMap,
    Map<String, dynamic>? headerMap,
  })async{
    _dio?.options.headers = headerMap;
    try{
      var response = await _dio?.request<String>(
          url,
          data: dataMap,
          options: Options(method: "post")
      );
      if(response?.statusCode==200){
        return DioResult(success: true, result: response?.data?.toString()??"");
      }else{
        return DioResult(success: false, result: "");
      }
    }catch(e){
      return DioResult(success: false, result: "");
    }
  }

  Future<DioResult> requestListPost({
    required String url,
    required List list,
    String? contentType,
    Map<String, dynamic>? headerMap,
  })async{
    _dio?.options.headers = headerMap;
    _dio?.options.contentType=contentType??"application/json";
    try{
      var response = await _dio?.request<String>(
          url,
          data: list,
          options: Options(method: "post")
      );
      if(response?.statusCode==200){
        return DioResult(success: true, result: response?.data?.toString()??"");
      }else{
        return DioResult(success: false, result: "");
      }
    }catch(e){
      return DioResult(success: false, result: "");
    }
  }
}