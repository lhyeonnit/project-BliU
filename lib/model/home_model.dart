import 'package:BliU/api/dio_services.dart';
import 'package:BliU/model_listener/home_model_listener.dart';
import 'package:dio/dio.dart';

class HomeModel {
  late Dio _dio;
  HomeModelListener listener;

  HomeModel(this.listener) {
    _dio = DioServices().to();
  }
}