import 'package:BliU/api/default_repository.dart';
import 'package:BliU/const/constant.dart';
import 'package:BliU/dto/default_response_dto.dart';
import 'package:BliU/dto/style_category_response_dto.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class RecommendInfoEditModel {}

class RecommendInfoEditViewModel extends StateNotifier<RecommendInfoEditModel?>{
  final Ref ref;
  final repository = DefaultRepository();

  RecommendInfoEditViewModel(super.state, this.ref);

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


  Future<DefaultResponseDTO?> editRecommendInfo(Map<String, dynamic> requestData) async {
    try {
      final response = await repository.reqPost(url: Constant.apiMyPageChildInfoUrl, data: requestData);
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
      return DefaultResponseDTO(result: false, message: e.toString());
    }
  }
}


final recommendInfoEditViewModelProvider =
StateNotifierProvider<RecommendInfoEditViewModel, RecommendInfoEditModel?>((req) {
  return RecommendInfoEditViewModel(null, req);
});