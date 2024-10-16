import 'package:BliU/api/default_repository.dart';
import 'package:BliU/const/constant.dart';
import 'package:BliU/dto/pay_order_detail_dto.dart';
import 'package:BliU/dto/product_option_response_dto.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class ProductOrderBottomOptionModel {
}

class ProductOrderBottomOptionViewModel extends StateNotifier<ProductOrderBottomOptionModel?> {
  final Ref ref;
  final repository = DefaultRepository();

  ProductOrderBottomOptionViewModel(super.state, this.ref);

  Future<ProductOptionResponseDTO?> getList(Map<String, dynamic> requestData) async {
    try {
      final response = await repository.reqPost(url: Constant.apiProductOptionUrl, data: requestData);
      if (response != null) {
        if (response.statusCode == 200) {
          Map<String, dynamic> responseData = response.data;
          return ProductOptionResponseDTO.fromJson(responseData);
        }
      }
      return null;
    } catch (e) {
      // Catch and log any exceptions
      print('Error fetching : $e');
      return null;
    }
  }

  Future<Map<String, dynamic> ?> addCart(Map<String, dynamic> requestData) async {
    try {
      final response = await repository.reqPost(url: Constant.apiCartAddUrl, data: requestData);
      if (response != null) {
        if (response.statusCode == 200) {
          Map<String, dynamic> responseData = response.data;
          return responseData;
        }
      }
      return null;
    } catch (e) {
      // Catch and log any exceptions
      print('Error fetching : $e');
      return null;
    }
  }

  Future<PayOrderDetailDTO?> orderDetail(Map<String, dynamic> requestData) async {
    try {
      final response = await repository.reqPost(url: Constant.apiOrderDetailUrl, data: requestData);
      if (response != null) {
        if (response.statusCode == 200) {
          Map<String, dynamic> responseData = response.data;
          return PayOrderDetailDTO.fromJson(responseData);
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

final productOrderBottomOptionModelProvider =
StateNotifierProvider<ProductOrderBottomOptionViewModel, ProductOrderBottomOptionModel?>((req) {
  return ProductOrderBottomOptionViewModel(null, req);
});