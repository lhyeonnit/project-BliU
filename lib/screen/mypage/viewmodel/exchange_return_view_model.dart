import 'package:BliU/api/default_repository.dart';
import 'package:BliU/const/constant.dart';
import 'package:BliU/dto/category_response_dto.dart';
import 'package:BliU/dto/default_response_dto.dart';
import 'package:BliU/dto/order_detail_info_response_dto.dart';
import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class ExchangeReturnModel {

}

class ExchangeReturnViewModel extends StateNotifier<ExchangeReturnModel?> {
  final Ref ref;
  final repository = DefaultRepository();

  ExchangeReturnViewModel(super.state, this.ref);

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
      print('Error fetching : $e');
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
      print('Error request Api: $e');
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
      print('Error request Api: $e');
      return null;
    }
  }

  Future<DefaultResponseDTO> orderReturn(FormData formData) async {
    final response = await repository.reqPostFiles(url: Constant.apiMyPageOrderReturnUrl, data: formData);
    try {
      if (response != null) {
        if (response.statusCode == 200) {
          Map<String, dynamic> responseData = response.data;
          DefaultResponseDTO defaultResponseDTO = DefaultResponseDTO.fromJson(responseData);
          return defaultResponseDTO;
        }
      }
      return DefaultResponseDTO(result: false, message: "Network Or Data Error");
    } catch (e) {
      // Catch and log any exceptions
      print('Error fetching : $e');
      return DefaultResponseDTO(result: false, message: e.toString());
    }
  }
}

final exchangeReturnViewModelProvider =
StateNotifierProvider<ExchangeReturnViewModel, ExchangeReturnModel?>((req) {
  return ExchangeReturnViewModel(null, req);
});