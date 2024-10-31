import 'package:BliU/api/default_repository.dart';
import 'package:BliU/const/constant.dart';
import 'package:BliU/dto/category_response_dto.dart';
import 'package:BliU/dto/product_list_response_dto.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class HomeModel {
}

class HomeViewModel extends StateNotifier<HomeModel?> {
  final Ref ref;
  final repository = DefaultRepository();

  HomeViewModel(super.state, this.ref);

  Future<CategoryResponseDTO?> getCategory(Map<String, dynamic> requestData) async {
    final response = await repository.reqPost(url: Constant.apiMainCategoryUrl, data: requestData);
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

  Future<CategoryResponseDTO?> getAgeCategory() async {
    final response = await repository.reqGet(url: Constant.apiCategoryAgeUrl);
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

  Future<String?> getCartCount(Map<String, dynamic> requestData) async {
    final response = await repository.reqPost(url: Constant.apiCartCountUrl, data: requestData);
    try {
      if (response != null) {
        if (response.statusCode == 200) {
          Map<String, dynamic> responseData = response.data;
          int cartCount = responseData['data']['count'];
          return cartCount.toString();
        }
      }
      return null;
    } catch(e) {
      // Catch and log any exceptions
      if (kDebugMode) {
        print("Error request Api: $e");
      }
      return null;
    }
  }

  Future<ProductListResponseDTO?> getList(Map<String, dynamic> requestData) async {
    try {
      final response = await repository.reqPost(url: Constant.apiMainSellRankUrl, data: requestData);
      if (response != null) {
        if (response.statusCode == 200) {
          Map<String, dynamic> responseData = response.data;
          ProductListResponseDTO productListResponseDTO = ProductListResponseDTO.fromJson(responseData);
          return productListResponseDTO;
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

// ViewModel Provider 정의
final homeViewModelProvider =
StateNotifierProvider<HomeViewModel, HomeModel?>((ref) {
  return HomeViewModel(null, ref);
});