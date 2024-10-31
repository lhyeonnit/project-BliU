import 'package:BliU/api/default_repository.dart';
import 'package:BliU/const/constant.dart';
import 'package:BliU/dto/coupon_response_dto.dart';
import 'package:BliU/dto/default_response_dto.dart';
import 'package:BliU/dto/member_info_response_dto.dart';
import 'package:BliU/dto/pay_order_detail_dto.dart';
import 'package:BliU/dto/pay_order_result_detail_dto.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class PaymentModel {

}

class PaymentViewModel extends StateNotifier<PaymentModel?> {
  final Ref ref;
  final repository = DefaultRepository();

  PaymentViewModel(super.state, this.ref);

  Future<MemberInfoResponseDTO?> getMy(Map<String, dynamic> requestData) async {
    try {
      final response = await repository.reqPost(url: Constant.apiMyPageUrl, data: requestData);
      if (response != null) {
        if (response.statusCode == 200) {
          Map<String, dynamic> responseData = response.data;
          MemberInfoResponseDTO memberInfoResponseDTO = MemberInfoResponseDTO.fromJson(responseData);
          return memberInfoResponseDTO;
        }
      }
      return null;
    } catch (e) {
      // Catch and log any exceptions
      if (kDebugMode) {
        print('Error fetching : $e');
      }
      return null;
    }
  }

  Future<CouponResponseDTO?> getOrderCoupon(Map<String, dynamic> requestData) async {
    try {
      final response = await repository.reqPost(url: Constant.apiOrderCouponUrl, data: requestData);
      if (response != null) {
        if (response.statusCode == 200) {
          Map<String, dynamic> responseData = response.data;
          CouponResponseDTO couponResponseDTO = CouponResponseDTO.fromJson(responseData);
          return couponResponseDTO;
        }
      }
      return null;
    } catch (e) {
      // Catch and log any exceptions
      if (kDebugMode) {
        print('Error fetching : $e');
      }
      return null;
    }
  }

  //결제상세
  Future<PayOrderDetailDTO?> orderDetail(Map<String, dynamic> requestData) async {
    try {
      final response = await repository.reqPost(url: Constant.apiOrderDetailUrl, data: requestData);
      if (response != null) {
        if (response.statusCode == 200) {
          Map<String, dynamic> responseData = response.data;
          return PayOrderDetailDTO.fromJson(responseData);
        }
      }
      return null;
    } catch (e) {
      // Catch and log any exceptions
      if (kDebugMode) {
        print('Error fetching : $e');
      }
      return null;
    }
  }
  //결제요청
  Future<Map<String, dynamic>?> reqOrder(Map<String, dynamic> requestData) async {
    try {
      final response = await repository.reqPost(url: Constant.apiOrderUrl, data: requestData);
      if (response != null) {
        if (response.statusCode == 200) {
          Map<String, dynamic> responseData = response.data;
          return responseData;
        }
      }
      return null;
    } catch (e) {
      // Catch and log any exceptions
      if (kDebugMode) {
        print('Error fetching : $e');
      }
      return null;
    }
  }
  //결제 검증
  Future<DefaultResponseDTO?> orderCheck(Map<String, dynamic> requestData) async {
    try {
      final response = await repository.reqPost(url: Constant.apiOrderCheckUrl, data: requestData);
      if (response != null) {
        if (response.statusCode == 200) {
          Map<String, dynamic> responseData = response.data;
          DefaultResponseDTO defaultResponseDTO = DefaultResponseDTO.fromJson(responseData);
          return defaultResponseDTO;
        }
      }
      return null;
    } catch (e) {
      // Catch and log any exceptions
      if (kDebugMode) {
        print('Error fetching : $e');
      }
      return null;
    }
  }
  //결제완료
  Future<PayOrderResultDetailDTO?> orderEnd(Map<String, dynamic> requestData) async {
    try {
      final response = await repository.reqPost(url: Constant.apiOrderEndUrl, data: requestData);
      if (response != null) {
        if (response.statusCode == 200) {
          Map<String, dynamic> responseData = response.data;
          PayOrderResultDetailDTO payOrderResultDetailDTO = PayOrderResultDetailDTO.fromJson(responseData);
          return payOrderResultDetailDTO;
        }
      }
      return null;
    } catch (e) {
      // Catch and log any exceptions
      if (kDebugMode) {
        print('Error fetching : $e');
      }
      return null;
    }
  }
  //쿠폰사용
  Future<DefaultResponseDTO?> couponUse(Map<String, dynamic> requestData) async {
    try {
      final response = await repository.reqPost(url: Constant.apiOrderCouponUseUrl, data: requestData);
      if (response != null) {
        if (response.statusCode == 200) {
          Map<String, dynamic> responseData = response.data;
          DefaultResponseDTO defaultResponseDTO = DefaultResponseDTO.fromJson(responseData);
          return defaultResponseDTO;
        }
      }
      return null;
    } catch (e) {
      // Catch and log any exceptions
      if (kDebugMode) {
        print('Error fetching : $e');
      }
      return null;
    }
  }
  //포인트 사용
  Future<DefaultResponseDTO?> pointUse(Map<String, dynamic> requestData) async {
    try {
      final response = await repository.reqPost(url: Constant.apiOrderPointUrl, data: requestData);
      if (response != null) {
        if (response.statusCode == 200) {
          Map<String, dynamic> responseData = response.data;
          DefaultResponseDTO defaultResponseDTO = DefaultResponseDTO.fromJson(responseData);
          return defaultResponseDTO;
        }
      }
      return null;
    } catch (e) {
      // Catch and log any exceptions
      if (kDebugMode) {
        print('Error fetching : $e');
      }
      return null;
    }
  }
  //제주/도서산간 추가비용
  Future<Map<String, dynamic>?> orderLocal(Map<String, dynamic> requestData) async {
    try {
      final response = await repository.reqPost(url: Constant.apiOrderLocalUrl, data: requestData);
      if (response != null) {
        if (response.statusCode == 200) {
          Map<String, dynamic> responseData = response.data;
          return responseData;
        }
      }
      return null;
    } catch (e) {
      // Catch and log any exceptions
      if (kDebugMode) {
        print('Error fetching : $e');
      }
      return null;
    }
  }
}

// ViewModel Provider 정의
final paymentViewModelProvider =
StateNotifierProvider<PaymentViewModel, PaymentModel?>((ref) {
  return PaymentViewModel(null, ref);
});