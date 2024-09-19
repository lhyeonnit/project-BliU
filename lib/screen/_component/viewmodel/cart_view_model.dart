import 'package:BliU/api/default_repository.dart';
import 'package:BliU/const/constant.dart';
import 'package:BliU/dto/cart_response_dto.dart';
import 'package:BliU/dto/default_response_dto.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class CartModel {

}

class CartViewModel extends StateNotifier<CartModel?> {
  final Ref ref;
  final repository = DefaultRepository();

  CartViewModel(super.state, this.ref);

  Future<CartResponseDTO?> getList(Map<String, dynamic> requestData) async {
    try {
      final response = await repository.reqPost(url: Constant.apiCartListUrl, data: requestData);
      if (response != null) {
        if (response.statusCode == 200) {
          Map<String, dynamic> responseData = response.data;
          return CartResponseDTO.fromJson(responseData);
        }
      }
      return null;
    } catch (e) {
      // Catch and log any exceptions
      print('Error fetching : $e');
      return null;
    }
  }

  Future<DefaultResponseDTO?> cartUpdate(Map<String, dynamic> requestData) async {
    try {
      final response = await repository.reqPost(url: Constant.apiCartUpdateUrl, data: requestData);
      if (response != null) {
        if (response.statusCode == 200) {
          Map<String, dynamic> responseData = response.data;
          return DefaultResponseDTO.fromJson(responseData);
        }
      }
      return null;
    } catch (e) {
      // Catch and log any exceptions
      print('Error fetching : $e');
      return null;
    }
  }

  Future<DefaultResponseDTO?> cartDel(Map<String, dynamic> requestData) async {
    try {
      final response = await repository.reqPost(url: Constant.apiCartDelUrl, data: requestData);
      if (response != null) {
        if (response.statusCode == 200) {
          Map<String, dynamic> responseData = response.data;
          return DefaultResponseDTO.fromJson(responseData);
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

// ViewModel Provider 정의
final cartModelProvider =
StateNotifierProvider<CartViewModel, CartModel?>((ref) {
  return CartViewModel(null, ref);
});