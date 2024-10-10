import 'package:BliU/api/default_repository.dart';
import 'package:BliU/const/constant.dart';
import 'package:BliU/dto/recommend_info_response_dto.dart';
import 'package:BliU/dto/style_category_response_dto.dart';
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
      print('Error request Api: $e');
      return null;
    }
  }

  Future<RecommendInfoResponseDTO?> saveRecommendInfo(Map<String, dynamic> requestData) async {
    try {
      final response = await repository.reqPost(url: Constant.apiAuthChildInfoUrl, data: requestData);
      if (response != null) {
        if (response.statusCode == 200) {
          Map<String, dynamic> responseData = response.data;
          RecommendInfoResponseDTO recommendInfoResponseDTO = RecommendInfoResponseDTO.fromJson(responseData);
          return recommendInfoResponseDTO;
        }
      }
      return null;
    } catch (e) {
      // Catch and log any exceptions
      print('Error fetching : $e');
      return RecommendInfoResponseDTO(result: false, message: e.toString(), data: null);
    }
  }
  Future<RecommendInfoResponseDTO?> getRecommendInfo(Map<String, dynamic> requestData) async {
    try {
      // 서버 API 호출
      final response = await repository.reqPost(url: Constant.apiAuthChildInfoUrl, data: requestData);

      // 성공적으로 응답을 받은 경우
      if (response != null && response.statusCode == 200) {
        Map<String, dynamic> responseData = response.data;
        // 응답 데이터를 DTO로 변환
        RecommendInfoResponseDTO recommendInfoResponseDTO = RecommendInfoResponseDTO.fromJson(responseData);
        return recommendInfoResponseDTO; // 추천 정보 반환
      }

      return null; // 오류가 발생했을 때
    } catch (e) {
      // 예외 처리 (로그 등)
      print('Error fetching recommend info: $e');
      return RecommendInfoResponseDTO(result: false, message: e.toString(), data: null);
    }
  }

}


final RecommendInfoModelProvider =
StateNotifierProvider<RecommendInfoViewModel, RecommendInfoModel?>((req) {
  return RecommendInfoViewModel(null, req);
});