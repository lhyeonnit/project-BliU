import 'package:BliU/api/default_repository.dart';
import 'package:BliU/const/constant.dart';
import 'package:BliU/dto/coupon_response_dto.dart';
import 'package:BliU/dto/default_response_dto.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class CouponReceiveModel {}

class CouponReceiveViewModel extends StateNotifier<CouponReceiveModel?> {
  final Ref ref;
  final repository = DefaultRepository();

  CouponReceiveViewModel(super.state, this.ref);

  Future<CouponResponseDTO?> getList(Map<String, dynamic> requestData) async {
    try {
      final response = await repository.reqPost(url: Constant.apiProductCouponListUrl, data: requestData);
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

  Future<DefaultResponseDTO?> couponDown(Map<String, dynamic> requestData) async {
    try {
      final response = await repository.reqPost(url: Constant.apiProductCouponDownUrl, data: requestData);
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
}


final couponReceiveModelProvider =
StateNotifierProvider<CouponReceiveViewModel, CouponReceiveModel?>((req) {
  return CouponReceiveViewModel(null, req);
});