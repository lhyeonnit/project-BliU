import 'package:BliU/api/default_repository.dart';
import 'package:BliU/const/constant.dart';
import 'package:BliU/data/faq_category_data.dart';
import 'package:BliU/dto/faq_category_response_dto.dart';
import 'package:BliU/dto/faq_response_dto.dart';
import 'package:flutter/foundation.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

class FaqModel {}

class FaqViewModel extends StateNotifier<FaqModel?> {
  final Ref ref;
  final repository = DefaultRepository();

  FaqViewModel(super.state, this.ref);

  Future<List<FaqCategoryData>?> getCategory() async {
    try {
      final response = await repository.reqPost(url: Constant.apiMyPageFaqCategoryUrl);
      if (response != null) {
        if (response.statusCode == 200) {
          Map<String, dynamic> responseData = response.data;
          FaqCategoryResponseDTO faqCategoryResponseDTO = FaqCategoryResponseDTO.fromJson(responseData);
          return faqCategoryResponseDTO.list;
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

  Future<FaqResponseDTO?> getList(Map<String, dynamic> requestData) async {
    try {
      final response = await repository.reqPost(url: Constant.apiMyPageFaqUrl, data: requestData);
      if (response != null) {
        if (response.statusCode == 200) {
          Map<String, dynamic> responseData = response.data;
          FaqResponseDTO faqResponseDTO = FaqResponseDTO.fromJson(responseData);
          return faqResponseDTO;
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

final faqViewModelProvider =
StateNotifierProvider<FaqViewModel, FaqModel?>((req) {
  return FaqViewModel(null, req);
});