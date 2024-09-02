import 'package:BliU/const/constant.dart';
import 'package:dio/dio.dart';

//푸터
class FootRepository {
  final Dio _dio = Dio();

  // 푸터
  Future<Response<dynamic>?> reqFoot() async {
    try {
      final response = await _dio.get(
        Constant.apiFootUrl,
      );
      return response;
    } catch (e) {
      print("Error toggling store like: $e");
      return null;
    }
  }
}