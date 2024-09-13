import 'package:BliU/api/default_repository.dart';
import 'package:BliU/const/constant.dart';
import 'package:BliU/dto/product_coupon_response_dto.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class CouponReceiveModel {
  ProductCouponResponseDTO? productCouponResponseDTO;

  CouponReceiveModel({
    this.productCouponResponseDTO,
  });
}

class CouponReceiveViewModel extends StateNotifier<CouponReceiveModel?> {
  final Ref ref;
  final repository = DefaultRepository();

  CouponReceiveViewModel(super.state, this.ref);

  Future<void> getList(Map<String, dynamic> requestData) async {
    try {
      final response = await repository.reqPost(url: Constant.apiProductCouponListUrl, data: requestData);
      if (response != null) {
        if (response.statusCode == 200) {
          Map<String, dynamic> responseData = response.data;
          ProductCouponResponseDTO productCouponResponseDTO = ProductCouponResponseDTO.fromJson(responseData);
          state = CouponReceiveModel(productCouponResponseDTO: productCouponResponseDTO);
          return;
        }
      }
      state = state;
    } catch (e) {
      // Catch and log any exceptions
      print('Error fetching : $e');
      state = state;
    }
  }
}


final couponReceiveModelProvider =
StateNotifierProvider<CouponReceiveViewModel, CouponReceiveModel?>((req) {
  return CouponReceiveViewModel(null, req);
});