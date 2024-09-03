import 'package:BliU/const/constant.dart';
import 'package:BliU/dto/coupon_response_dto.dart';
import 'package:dio/dio.dart';
//결제
class OrderRepository {
  final Dio _dio = Dio();
  // TODO
  // 결제 상세
  Future<Response<dynamic>?> reqOrderDetail({
    required String otCode,
    required int mtIdx,
    required String cartArr,
  }) async {
    try {
      final response = await _dio.post(
        Constant.apiOrderDetailUrl,
        data: {
          'ot_code': otCode,
          'mt_idx': mtIdx.toString(),
          'cart_arr': cartArr,
        },
      );
      return response;
    } catch (e) {
      print("Error toggling store like: $e");
      return null;
    }
  }
  // TODO
  //제주 / 도서산간 추가 비용
  Future<Response<dynamic>?> reqOrderLocal({
    required String otCode,
    required String cartArr,
    required String mtZip,
    required String mtAdd1,
    required int allDeliveryPrice,
  }) async {
    try {
      final response = await _dio.post(
        Constant.apiOrderLocalUrl,
        data: {
          'ot_code': otCode,
          'cart_arr': cartArr,
          'mt_zip': mtZip,
          'mt_add1': mtAdd1,
          'all_delivery_price': allDeliveryPrice.toString(),
        },
      );
      return response;
    } catch (e) {
      print("Error toggling store like: $e");
      return null;
    }
  }
  // TODO - 결과값 확인
  //포인트 사용
  Future<Response<dynamic>?> reqOrderPoint({
    required String otCode,
    required int mtIdx,
    required int usePoint,
  }) async {
    try {
      final response = await _dio.post(
        Constant.apiOrderPointUrl,
        data: {
          'ot_code': otCode,
          'mt_idx': mtIdx,
          'use_point': usePoint,
        },
      );
      return response;
    } catch (e) {
      print("Error toggling store like: $e");
      return null;
    }
  }
  //쿠폰 리스트
  Future<Response<dynamic>?> reqOrderCoupon({
    required int mtIdx,
    required String storeArr,
    required int allPrice,
  }) async {
    try {
      final response = await _dio.post(
        Constant.apiOrderCouponUrl,
        data: {
          'mt_idx': mtIdx,
          'store_arr': storeArr,
          'all_price': allPrice,
        },
      );

      if (response.statusCode == 200 ) {
        Map<String, dynamic> responseData = response.data;
        CouponResponseDTO couponResponseDTO = CouponResponseDTO.fromJson(responseData);
        if (couponResponseDTO.result == true) {
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
  // TODO - 결과 확인 필요
  //쿠폰 사용
  Future<Response<dynamic>?> reqOrderCouponUse({
    required String otCode,
    required int couponIdx,
    required int mtIdx,
  }) async {
    try {
      final response = await _dio.post(
        Constant.apiOrderCouponUseUrl,
        data: {
          'ot_code': otCode,
          'coupon_idx': couponIdx.toString(),
          'mt_idx': mtIdx.toString(),
        },
      );
      return response;
    } catch (e) {
      print("Error toggling store like: $e");
      return null;
    }
  }
  // TODO
  //결제 요청
  Future<Response<dynamic>?> reqOrder({
    required String otCode,
    required int mtIdx,
    required String mtRname,
    required String mtRhp,
    required String mtZip,
    required String mtAdd1,
    required String mtAdd2,
    required String mtSaveAdd,
    required String memo,
  }) async {
    try {
      final response = await _dio.post(
        Constant.apiOrderUrl,
        data: {
          'ot_code': otCode,
          'mt_idx': mtIdx,
          'mt_rname': mtRname,
          'mt_rhp': mtRhp,
          'mt_zip': mtZip,
          'mt_add1': mtAdd1,
          'mt_add2': mtAdd2,
          'mt_save_add': mtSaveAdd,
          'memo': memo,
        },
      );
      return response;
    } catch (e) {
      print("Error toggling store like: $e");
      return null;
    }
  }
  // TODO - 결과 확인
  //결제검증
  Future<Response<dynamic>?> reqOrderCheck({
    required String orderId,
  }) async {
    try {
      final response = await _dio.post(
        Constant.apiOrderCheckUrl,
        data: {
          'orderId': orderId,
        },
      );
      return response;
    } catch (e) {
      print("Error toggling store like: $e");
      return null;
    }
  }
  // TODO - 결과 확인
  //결제 완료
  Future<Response<dynamic>?> reqOrderEnd({
    required String mtIdx,
    required String otCode,
  }) async {
    try {
      final response = await _dio.post(
        Constant.apiOrderEndUrl,
        data: {
          'mt_idx': mtIdx,
          'ot_code': otCode,
        },
      );
      return response;
    } catch (e) {
      print("Error toggling store like: $e");
      return null;
    }
  }
}
