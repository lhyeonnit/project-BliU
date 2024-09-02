import 'package:BliU/api/dio_interceptor.dart';
import 'package:BliU/const/constant.dart';
import 'package:dio/dio.dart';

class DefaultRepository {
  Dio _defaultDio = Dio();
  Dio _multiPartDio = Dio();

  DefaultRepository() {
    BaseOptions options = BaseOptions(
      baseUrl: Constant.USER_URL,
      connectTimeout: const Duration(milliseconds: 10000),
      receiveTimeout: const Duration(milliseconds: 10000),
      sendTimeout: const Duration(milliseconds: 10000),
      // headers: {},
    );

    _defaultDio = Dio(options);
    _defaultDio.interceptors.add(DioInterceptor());

    _multiPartDio = Dio(options);
    _multiPartDio.interceptors.add(DioInterceptor());
    _multiPartDio.options.contentType = Headers.multipartFormDataContentType;
    _multiPartDio.options.maxRedirects.isFinite;
  }
  // POST
  Future<Response<dynamic>?> reqPost({
    required String url,
    Map<String, dynamic>? data,
  }) async {
    try {
      final response = await _defaultDio.post(
        url,
        data: data,
      );
      return response;
    } catch (e) {
      print("Error toggling store like: $e");
      return null;
    }
  }
  //POST FILE
  Future<Response<dynamic>?> reqPostFiles({
    required String url,
    Map<String, dynamic>? data,
  }) async {
    try {
      final response = await _multiPartDio.post(
        url,
        data: data,
      );
      return response;
    } catch (e) {
      print("Error toggling store like: $e");
      return null;
    }
  }
  //GET
  Future<Response<dynamic>?> reqMyPageOrderReturnCategory({
    required String url,
    Map<String, dynamic>? data,
  }) async {
    try {
      final response = await _defaultDio.get(
          url,
          queryParameters: data,
      );
      return response;
    } catch (e) {
      print("Error toggling store like: $e");
      return null;
    }
  }
}