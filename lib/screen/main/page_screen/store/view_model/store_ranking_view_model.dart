import 'package:BliU/api/default_repository.dart';
import 'package:BliU/const/constant.dart';
import 'package:BliU/dto/category_response_dto.dart';
import 'package:BliU/dto/store_rank_response_dto.dart';
import 'package:BliU/dto/style_category_response_dto.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class StoreRankingModel {}

class StoreRankingViewModel extends StateNotifier<StoreRankingModel?> {
  final Ref ref;
  final repository = DefaultRepository();

  StoreRankingViewModel(super.state, this.ref);

  Future<StoreRankResponseDTO?> getRank(Map<String, dynamic> requestData) async {
    try {
      final response = await repository.reqPost(url: Constant.apiStoreRankUrl, data: requestData);
      if (response != null) {
        if (response.statusCode == 200) {
          Map<String, dynamic> responseData = response.data;
          StoreRankResponseDTO storeRankResponseDTO = StoreRankResponseDTO.fromJson(responseData);
          return storeRankResponseDTO;
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

  Future<StyleCategoryResponseDTO?> getStyleCategory() async {
    final response = await repository.reqGet(url: Constant.apiAuthStyleCategoryUrl);
    try {
      if (response != null) {
        if (response.statusCode == 200) {
          Map<String, dynamic> responseData = response.data;
          StyleCategoryResponseDTO styleCategoryResponseDTO = StyleCategoryResponseDTO.fromJson(responseData);
          return styleCategoryResponseDTO;
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

final storeRankingViewModelProvider =
StateNotifierProvider<StoreRankingViewModel, StoreRankingModel?>((req) {
  return StoreRankingViewModel(null, req);
});