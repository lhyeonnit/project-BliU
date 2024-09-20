import 'package:BliU/api/default_repository.dart';
import 'package:BliU/const/constant.dart';
import 'package:BliU/dto/coupon_response_dto.dart';
import 'package:BliU/dto/member_info_response_dto.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class PaymentDiscountModel {
}

class PaymentDiscountViewModel extends StateNotifier<PaymentDiscountModel?> {
  final Ref ref;
  final repository = DefaultRepository();

  PaymentDiscountViewModel(super.state, this.ref);

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
      print('Error fetching : $e');
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
      print('Error fetching : $e');
      return null;
    }
  }
}

// ViewModel Provider 정의
final paymentDiscountViewModelProvider =
StateNotifierProvider<PaymentDiscountViewModel, PaymentDiscountModel?>((ref) {
  return PaymentDiscountViewModel(null, ref);
});