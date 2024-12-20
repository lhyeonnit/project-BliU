import 'package:BliU/api/default_repository.dart';
import 'package:BliU/const/constant.dart';
import 'package:BliU/dto/default_response_dto.dart';
import 'package:BliU/dto/style_category_response_dto.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class RecommendInfoModel {
}

class RecommendInfoViewModel extends StateNotifier<RecommendInfoModel?>{
  final Ref ref;
  final repository = DefaultRepository();

  RecommendInfoViewModel(super.state, this.ref);

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

  Future<DefaultResponseDTO?> saveRecommendInfo(Map<String, dynamic> requestData) async {
    try {
      final response = await repository.reqPost(url: Constant.apiAuthChildInfoUrl, data: requestData);
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
      if (kDebugMode) {
        print('Error fetching : $e');
      }
      return null;
    }
  }
}


final recommendInfoViewModelProvider =
StateNotifierProvider<RecommendInfoViewModel, RecommendInfoModel?>((req) {
  return RecommendInfoViewModel(null, req);
});