import 'package:BliU/const/constant.dart';
import 'package:BliU/dto/cart_response_dto.dart';
import 'package:BliU/dto/default_response_dto.dart';
import 'package:dio/dio.dart';

//장바구니
class CartRepository {
  final Dio _dio = Dio();
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
      /*
      *
      {
        "result": true,
        "data": {
          "count": 3
        }
      }
      * */

      if (response.statusCode == 200 ) {
        Map<String, dynamic> responseData = response.data;
        if (responseData['result'] == true) {
          //성공
          int count = responseData['count'];
        } else {
          //실패
        }
      } else {
        //실패
      }

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

      if (response.statusCode == 200 ) {
        Map<String, dynamic> responseData = response.data;
        CartResponseDTO cartResponseDTO = CartResponseDTO.fromJson(responseData);
        if (cartResponseDTO.result == true) {
          //성공
        } else {
          //실패
        }
      } else {
        //실패
      }

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

      if (response.statusCode == 200 ) {
        Map<String, dynamic> responseData = response.data;
        DefaultResponseDTO defaultResponseDTO = DefaultResponseDTO.fromJson(responseData);
        if (defaultResponseDTO.result == true) {
          //성공
        } else {
          //실패
        }
      } else {
        //실패
      }

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

      if (response.statusCode == 200 ) {
        Map<String, dynamic> responseData = response.data;
        DefaultResponseDTO defaultResponseDTO = DefaultResponseDTO.fromJson(responseData);
        if (defaultResponseDTO.result == true) {
          //성공
        } else {
          //실패
        }
      } else {
        //실패
      }

      return response;
    } catch (e) {
      print("Error toggling store like: $e");
      return null;
    }
  }
}