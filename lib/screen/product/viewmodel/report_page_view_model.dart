import 'package:BliU/api/default_repository.dart';
import 'package:BliU/const/constant.dart';
import 'package:BliU/dto/category_response_dto.dart';
import 'package:BliU/dto/default_response_dto.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class ReportPageModel {}

class ReportPageViewModel extends StateNotifier<ReportPageModel?> {
  final Ref ref;
  final repository = DefaultRepository();

  ReportPageViewModel(super.state, this.ref);

  Future<CategoryResponseDTO?> getCategory() async {
    final response = await repository.reqGet(url: Constant.apiProductSingoCateUrl,);
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

  Future<DefaultResponseDTO?> reviewSingo(Map<String, dynamic> requestData) async {
    final response = await repository.reqPost(url: Constant.apiProductReviewSingoUrl, data: requestData);
    try {
      if (response != null) {
        if (response.statusCode == 200) {
          Map<String, dynamic> responseData = response.data;
          DefaultResponseDTO defaultResponseDTO = DefaultResponseDTO.fromJson(responseData);
          return defaultResponseDTO;
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

final reportPageViewModelProvider =
StateNotifierProvider<ReportPageViewModel, ReportPageModel?>((req) {
  return ReportPageViewModel(null, req);
});