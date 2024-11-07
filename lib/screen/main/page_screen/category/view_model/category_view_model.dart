import 'package:BliU/api/default_repository.dart';
import 'package:BliU/const/constant.dart';
import 'package:BliU/dto/category_response_dto.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class CategoryModel {
  CategoryResponseDTO? categoryResponseDTO;
  int selectedCategoryIndex = 0;
}

class CategoryViewModel extends StateNotifier<CategoryModel> {
  final Ref ref;
  final repository = DefaultRepository();

  CategoryViewModel(super.state, this.ref);

  void getCategory(Map<String, dynamic> requestData) async {
    final response = await repository.reqPost(url: Constant.apiMainCategoryUrl, data: requestData);
    try {
      if (response != null) {
        if (response.statusCode == 200) {
          Map<String, dynamic> responseData = response.data;
          CategoryResponseDTO categoryResponseDTO = CategoryResponseDTO.fromJson(responseData);
          state.categoryResponseDTO = categoryResponseDTO;
          ref.notifyListeners();
        }
      }
    } catch(e) {
      // Catch and log any exceptions
      if (kDebugMode) {
        print('Error request Api: $e');
      }
    }
  }

  void setSelectedCategoryIndex(int index) {
    state.selectedCategoryIndex = index;
    ref.notifyListeners();
  }
}

// ViewModel Provider 정의
final categoryViewModelProvider =
StateNotifierProvider<CategoryViewModel, CategoryModel>((ref) {
  return CategoryViewModel(CategoryModel(), ref);
});