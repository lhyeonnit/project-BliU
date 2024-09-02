import 'package:dio/dio.dart';

class DefaultRepository {
  final Dio _defaultDio = Dio();
  final Dio _multiPartDio = Dio();

  DefaultRepository() {
    _multiPartDio.options.contentType = 'multipart/form-data';
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