import 'package:BliU/api/default_repository.dart';
import 'package:BliU/const/constant.dart';
import 'package:BliU/dto/product_list_response_dto.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class HomeBodyAiModel {
  ProductListResponseDTO? productListResponseDTO;
}

class HomeBodyAiViewModel extends StateNotifier<HomeBodyAiModel> {
  final Ref ref;
  final repository = DefaultRepository();

  HomeBodyAiViewModel(super.state, this.ref);

  void getList(Map<String, dynamic> requestData) async {
    try {
      final response = await repository.reqPost(url: Constant.apiMainAiListUrl, data: requestData);
      if (response != null) {
        if (response.statusCode == 200) {
          Map<String, dynamic> responseData = response.data;
          ProductListResponseDTO productListResponseDTO = ProductListResponseDTO.fromJson(responseData);
          state.productListResponseDTO = productListResponseDTO;
          ref.notifyListeners();
        }
      }
    } catch (e) {
      // Catch and log any exceptions
      if (kDebugMode) {
        print('Error fetching : $e');
      }
    }
  }
}

// ViewModel Provider 정의
final homeBodyAiViewModelProvider =
StateNotifierProvider<HomeBodyAiViewModel, HomeBodyAiModel>((ref) {
  return HomeBodyAiViewModel(HomeBodyAiModel(), ref);
});