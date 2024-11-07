import 'package:BliU/api/default_repository.dart';
import 'package:BliU/const/constant.dart';
import 'package:BliU/data/category_data.dart';
import 'package:BliU/data/style_category_data.dart';
import 'package:BliU/dto/category_response_dto.dart';
import 'package:BliU/dto/style_category_response_dto.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class MainModel {
  List<CategoryData> categories1 = [];
  List<CategoryData> categories2 = [];
  List<CategoryData> ageCategories = [];
  List<StyleCategoryData> styleCategories = [];

  List<CategoryData> productCategories = [
    CategoryData(ctIdx: 0, cstIdx: 0, img: '', ctName: '전체', catIdx: 0, catName: '', subList: [])
  ];
}

class MainViewModel extends StateNotifier<MainModel> {
  final Ref ref;
  final repository = DefaultRepository();

  MainViewModel(super.state, this.ref);

  MainModel _changeModel() {
    final model = MainModel();
    model.categories1 = state.categories1;
    model.categories2 = state.categories2;
    model.ageCategories = state.ageCategories;
    model.styleCategories = state.styleCategories;
    model.productCategories = state.productCategories;
    return model;
  }

  void getCategory(String categoryType) async {
    Map<String, dynamic> requestData = {'category_type': categoryType};

    final response = await repository.reqPost(url: Constant.apiMainCategoryUrl, data: requestData);
    try {
      if (response != null) {
        if (response.statusCode == 200) {
          Map<String, dynamic> responseData = response.data;
          CategoryResponseDTO categoryResponseDTO = CategoryResponseDTO.fromJson(responseData);
          final model = _changeModel();
          if (categoryType == '1') {
            model.categories1 = categoryResponseDTO.list ?? [];
          } else {
            model.categories2 = categoryResponseDTO.list ?? [];
            model.productCategories.addAll(categoryResponseDTO.list ?? []);
          }
          state = model;
        }
      }
    } catch(e) {
      // Catch and log any exceptions
      if (kDebugMode) {
        print('Error request Api: $e');
      }
    }
  }

  void getAgeCategory() async {
    final response = await repository.reqGet(url: Constant.apiCategoryAgeUrl);
    try {
      if (response != null) {
        if (response.statusCode == 200) {
          Map<String, dynamic> responseData = response.data;
          CategoryResponseDTO categoryResponseDTO = CategoryResponseDTO.fromJson(responseData);
          final model = _changeModel();
          model.ageCategories = categoryResponseDTO.list ?? [];
          state = model;
        }
      }
    } catch(e) {
      // Catch and log any exceptions
      if (kDebugMode) {
        print('Error request Api: $e');
      }
    }
  }

  void getStyleCategory() async {
    final response = await repository.reqGet(url: Constant.apiAuthStyleCategoryUrl);
    try {
      if (response != null) {
        if (response.statusCode == 200) {
          Map<String, dynamic> responseData = response.data;
          StyleCategoryResponseDTO styleCategoryResponseDTO = StyleCategoryResponseDTO.fromJson(responseData);
          final model = _changeModel();
          model.styleCategories = styleCategoryResponseDTO.list ?? [];
          state = model;
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

// ViewModel Provider 정의
final mainViewModelProvider =
StateNotifierProvider<MainViewModel, MainModel>((ref) {
  return MainViewModel(MainModel(), ref);
});