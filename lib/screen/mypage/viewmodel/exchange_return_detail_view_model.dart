import 'package:BliU/api/default_repository.dart';
import 'package:BliU/const/constant.dart';
import 'package:BliU/dto/category_response_dto.dart';
import 'package:BliU/dto/order_detail_info_response_dto.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class ExchangeReturnDetailModel {

}

class ExchangeReturnDetailViewModel extends StateNotifier<ExchangeReturnDetailModel?> {
  final Ref ref;
  final repository = DefaultRepository();

  ExchangeReturnDetailViewModel(super.state, this.ref);

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

  Future<CategoryResponseDTO?> getCategory(Map<String, dynamic> requestData) async {
    final response = await repository.reqGet(url: Constant.apiMyPageOrderReturnCategoryUrl, data: requestData);
    try {
      if (response != null) {
        if (response.statusCode == 200) {
          Map<String, dynamic> responseData = response.data;
          CategoryResponseDTO categoryResponseDTO = CategoryResponseDTO.fromJson(responseData);
          return categoryResponseDTO;
        }
      }
      return null;
    } catch(e) {
      // Catch and log any exceptions
      if (kDebugMode) {
        print('Error request Api: $e');
      }
      return null;
    }
  }

  Future<CategoryResponseDTO?> getExchangeDeliveryCostCategory() async {
    final response = await repository.reqGet(url: Constant.apiMyPageOrderReturnPayUrl);
    try {
      if (response != null) {
        if (response.statusCode == 200) {
          Map<String, dynamic> responseData = response.data;
          CategoryResponseDTO categoryResponseDTO = CategoryResponseDTO.fromJson(responseData);
          return categoryResponseDTO;
        }
      }
      return null;
    } catch(e) {
      // Catch and log any exceptions
      if (kDebugMode) {
        print('Error request Api: $e');
      }
      return null;
    }
  }
}

final exchangeReturnDetailViewModelProvider =
StateNotifierProvider<ExchangeReturnDetailViewModel, ExchangeReturnDetailModel?>((req) {
  return ExchangeReturnDetailViewModel(null, req);
});