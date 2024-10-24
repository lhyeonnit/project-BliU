import 'package:BliU/api/default_repository.dart';
import 'package:BliU/const/constant.dart';
import 'package:BliU/dto/coupon_response_dto.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class MyCouponModel {}

class MyCouponViewModel extends StateNotifier<MyCouponModel?> {
  final Ref ref;
  final repository = DefaultRepository();
  MyCouponViewModel(super.state, this.ref);

  Future<CouponResponseDTO?> getList(Map<String, dynamic> requestData) async {
    try {
      final response = await repository.reqPost(url: Constant.apiMyPageCouponUrl, data: requestData);
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
}

final myCouponViewModelProvider =
StateNotifierProvider<MyCouponViewModel, MyCouponModel?>((req) {
  return MyCouponViewModel(null, req);
});