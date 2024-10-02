import 'package:BliU/api/default_repository.dart';
import 'package:BliU/const/constant.dart';
import 'package:BliU/dto/category_response_dto.dart';
import 'package:BliU/dto/default_response_dto.dart';
import 'package:BliU/dto/product_list_response_dto.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class LikeModel {
}

class LikeViewModel extends StateNotifier<LikeModel?> {
  final Ref ref;
  final repository = DefaultRepository();

  LikeViewModel(super.state, this.ref);

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
      print('Error request Api: $e');
      return null;
    }
  }

  Future<ProductListResponseDTO?> getList(Map<String, dynamic> requestData) async {
    try {
      final response = await repository.reqPost(url: Constant.apiProductLikeListUrl, data: requestData);
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
      print('Error fetching : $e');
      return null;
    }
  }

  Future<DefaultResponseDTO?> productLike(Map<String, dynamic> requestData) async {
    try {
      final response = await repository.reqPost(url: Constant.apiProductLikeUrl, data: requestData);
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
      print('Error fetching : $e');
      return null;
    }
  }
}

// ViewModel Provider 정의
final likeViewModelProvider =
StateNotifierProvider<LikeViewModel, LikeModel?>((ref) {
  return LikeViewModel(null, ref);
});