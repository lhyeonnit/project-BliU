import 'package:BliU/api/default_repository.dart';
import 'package:BliU/const/constant.dart';
import 'package:BliU/dto/order_detail_info_response_dto.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class OrderDetailModel {

}

class OrderDetailViewModel extends StateNotifier<OrderDetailModel?> {
  final Ref ref;
  final repository = DefaultRepository();

  OrderDetailViewModel(super.state, this.ref);

  Future<OrderDetailInfoResponseDTO?> getOrderDetail(Map<String, dynamic> requestData) async {
    try {
      final response = await repository.reqPost(url: Constant.apiMyPageOrderDetailUrl, data: requestData);
      if (response != null) {
        if (response.statusCode == 200) {
          Map<String, dynamic> responseData = response.data;
          OrderDetailInfoResponseDTO orderDetailInfoResponseDTO = OrderDetailInfoResponseDTO.fromJson(responseData);

          return orderDetailInfoResponseDTO;
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

final orderDetailViewModelProvider =
StateNotifierProvider<OrderDetailViewModel, OrderDetailModel?>((req) {
  return OrderDetailViewModel(null, req);
});