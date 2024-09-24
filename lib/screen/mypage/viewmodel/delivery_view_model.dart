import 'package:BliU/api/default_repository.dart';
import 'package:BliU/const/constant.dart';
import 'package:BliU/dto/order_delivery_response_dto.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class DeliveryModel {
}

class DeliveryViewModel extends StateNotifier<DeliveryModel?> {
  final Ref ref;
  final repository = DefaultRepository();

  DeliveryViewModel(super.state, this.ref);

  Future<OrderDeliveryResponseDTO?> getList(Map<String, dynamic> requestData) async {
    try {
      final response = await repository.reqPost(url: Constant.apiMyPageOrderDeliveryUrl, data: requestData);
      if (response != null) {
        if (response.statusCode == 200) {
          Map<String, dynamic> responseData = response.data;
          OrderDeliveryResponseDTO orderDeliveryResponseDTO = OrderDeliveryResponseDTO.fromJson(responseData);
          return orderDeliveryResponseDTO;
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

final deliveryViewModelProvider =
StateNotifierProvider<DeliveryViewModel, DeliveryModel?>((req) {
  return DeliveryViewModel(null, req);
});