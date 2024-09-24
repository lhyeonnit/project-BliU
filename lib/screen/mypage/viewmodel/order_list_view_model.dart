import 'package:BliU/api/default_repository.dart';
import 'package:BliU/const/constant.dart';
import 'package:BliU/data/order_data.dart';
import 'package:BliU/dto/order_response_dto.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class OrderListModel {
  OrderResponseDTO? orderResponseDTO;

  OrderListModel({
    this.orderResponseDTO,
  });
}

class OrderListViewModel extends StateNotifier<OrderListModel?> {
  final Ref ref;
  final repository = DefaultRepository();

  OrderListViewModel(super.state, this.ref);

  Future<void> getList(Map<String, dynamic> requestData) async {
    try {
      final response = await repository.reqPost(url: Constant.apiMyPageOrderListUrl, data: requestData);
      if (response != null) {
        if (response.statusCode == 200) {
          Map<String, dynamic> responseData = response.data;
          OrderResponseDTO orderResponseDTO = OrderResponseDTO.fromJson(responseData);

          var list = state?.orderResponseDTO?.list ?? [];
          List<OrderData> addList = orderResponseDTO.list ?? [];
          for (var item in  addList) {
            list.add(item);
          }

          orderResponseDTO.list = list;

          state = OrderListModel(orderResponseDTO: orderResponseDTO);
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

final orderListViewModelProvider =
StateNotifierProvider<OrderListViewModel, OrderListModel?>((req) {
  return OrderListViewModel(null, req);
});