import 'package:BliU/const/constant.dart';
import 'package:dio/dio.dart';

//장바구니
class CartRepository {
  final Dio _dio = Dio();
  // TODO
  /*
  *
  {
    "result": true,
    "data": {
      "count": 3
    }
  }
  * */
  //장바구니 수
  Future<Response<dynamic>?> reqCartCount({
    required int mtIdx,
  }) async {
    try {
      final response = await _dio.post(
        Constant.apiCartCountUrl,
        data: {
          'mt_idx': mtIdx.toString()
        },
      );
      return response;
    } catch (e) {
      print("Error toggling store like: $e");
      return null;
    }
  }
  //장바구니 담기
  Future<Response<dynamic>?> reqCartAdd({
    required int addType,
    required int mtIdx,
    required int ptIdx,
    required String products,
  }) async {
    try {
      final response = await _dio.post(
        Constant.apiCartAddUrl,
        data: {
          'add_type': addType.toString(),
          'mt_idx': mtIdx.toString(),
          'pt_idx': ptIdx.toString(),
          'products': products,
        },
      );
      return response;
    } catch (e) {
      print("Error toggling store like: $e");
      return null;
    }
  }
  //장바구니 리스트
  Future<Response<dynamic>?> reqCartList({
    required int mtIdx,
    required int pg,
  }) async {
    try {
      final response = await _dio.post(
        Constant.apiCartListUrl,
        data: {
          'mt_idx': mtIdx.toString(),
          'pg': pg.toString(),
        },
      );
      return response;
    } catch (e) {
      print("Error toggling store like: $e");
      return null;
    }
  }
  //장바구니 삭제
  Future<Response<dynamic>?> reqCartDel({
    required int mtIdx,
    required int ctIdx,
  }) async {
    try {
      final response = await _dio.post(
        Constant.apiCartDelUrl,
        data: {
          'mt_idx': mtIdx.toString(),
          'ct_idx': ctIdx.toString(),
        },
      );
      return response;
    } catch (e) {
      print("Error toggling store like: $e");
      return null;
    }
  }
  //장바구니 수량 증차감
  Future<Response<dynamic>?> reqCartUpdate({
    required int mtIdx,
    required int ctIdx,
    required int ctCount
  }) async {
    try {
      final response = await _dio.post(
        Constant.apiCartUpdateUrl,
        data: {
          'mt_idx': mtIdx.toString(),
          'ct_idx': ctIdx.toString(),
          'ct_count': ctCount.toString(),
        },
      );
      return response;
    } catch (e) {
      print("Error toggling store like: $e");
      return null;
    }
  }
}