import 'package:BliU/api/dio_interceptor.dart';
import 'package:BliU/const/constant.dart';
import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';

class DefaultRepository {
  Dio _dio = Dio();

  DefaultRepository() {
    BaseOptions options = BaseOptions(
      baseUrl: Constant.USER_URL,
      connectTimeout: const Duration(milliseconds: 30000),
      receiveTimeout: const Duration(milliseconds: 30000),
      sendTimeout: const Duration(milliseconds: 30000),
      headers: {
        'Authorization': 'Bearer bground_bliu_dmonter_20240729'
      },
    );

    _dio = Dio(options);
    _dio.interceptors.add(DioInterceptor());
    _dio.options.contentType = Headers.formUrlEncodedContentType;
  }
  // POST
  Future<Response<dynamic>?> reqPost({required String url, Object? data,}) async {
    try {
      _dio.options.contentType = Headers.formUrlEncodedContentType;

      final response = await _dio.post(url, data: data,);
      return response;
    } catch (e) {
      if (kDebugMode) {
        print("Error reqPost : $e");
      }
      return null;
    }
  }
  //POST FILE
  Future<Response<dynamic>?> reqPostFiles({required String url, FormData? data,}) async {
    try {
      _dio.options.contentType = Headers.multipartFormDataContentType;

      final response = await _dio.post(url, data: data,);
      return response;
    } catch (e) {
      if (kDebugMode) {
        print("Error reqPostFiles : $e");
      }
      return null;
    }
  }
  //GET
  Future<Response<dynamic>?> reqGet({required String url, Map<String, dynamic>? data,}) async {
    try {
      _dio.options.contentType = Headers.formUrlEncodedContentType;

      final response = await _dio.get(url, queryParameters: data,);
      return response;
    } catch (e) {
      if (kDebugMode) {
        print("Error reqGet : $e");
      }
      return null;
    }
  }
}