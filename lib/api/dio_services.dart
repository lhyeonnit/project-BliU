import 'package:BliU/api/dio_interceptor.dart';
import 'package:BliU/const/constant.dart';
import 'package:dio/dio.dart';

class DioServices {
  static final DioServices _dioServices = DioServices._internal();
  factory DioServices() => _dioServices;

  static Dio _dio = Dio();

  DioServices._internal() {
    BaseOptions options = BaseOptions(
      baseUrl: Constant.API_URL,
      connectTimeout: const Duration(milliseconds: 10000),
      receiveTimeout: const Duration(milliseconds: 10000),
      sendTimeout: const Duration(milliseconds: 10000),
      // headers: {},
    );
    _dio = Dio(options);
    _dio.interceptors.add(DioInterceptor());
  }

  Dio to() {
    return _dio;
  }
}