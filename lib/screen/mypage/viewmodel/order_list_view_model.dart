import 'package:BliU/api/default_repository.dart';
import 'package:BliU/const/constant.dart';
import 'package:BliU/dto/order_response_dto.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class OrderListModel {
}

class OrderListViewModel extends StateNotifier<OrderListModel?> {
  final Ref ref;
  final repository = DefaultRepository();

  OrderListViewModel(super.state, this.ref);

  Future<OrderResponseDTO?> getList(Map<String, dynamic> requestData) async {
    try {
      final response = await repository.reqPost(url: Constant.apiMyPageOrderListUrl, data: requestData);
      if (response != null) {
        if (response.statusCode == 200) {
          Map<String, dynamic> responseData = response.data;
          OrderResponseDTO orderResponseDTO = OrderResponseDTO.fromJson(responseData);
          return orderResponseDTO;
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

final orderListViewModelProvider =
StateNotifierProvider<OrderListViewModel, OrderListModel?>((req) {
  return OrderListViewModel(null, req);
});