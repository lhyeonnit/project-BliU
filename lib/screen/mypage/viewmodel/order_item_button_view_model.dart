import 'package:BliU/api/default_repository.dart';
import 'package:BliU/const/constant.dart';
import 'package:BliU/dto/default_response_dto.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class OrderItemButtonModel {}

class OrderItemButtonViewModel extends StateNotifier<OrderItemButtonModel?> {
  final Ref ref;
  final repository = DefaultRepository();

  OrderItemButtonViewModel(super.state, this.ref);

  Future<DefaultResponseDTO?> requestOrder(Map<String, dynamic> requestData) async {
    try {
      final response = await repository.reqPost(url: Constant.apiMyPageOrderUrl, data: requestData);
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


final orderItemButtonViewModelProvider =
StateNotifierProvider<OrderItemButtonViewModel, OrderItemButtonModel?>((req) {
  return OrderItemButtonViewModel(null, req);
});