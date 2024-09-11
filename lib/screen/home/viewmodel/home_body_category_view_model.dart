import 'package:BliU/api/default_repository.dart';
import 'package:BliU/const/constant.dart';
import 'package:BliU/dto/category_response_dto.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class HomeBodyCategoryModel {
  CategoryResponseDTO? categoryResponseDTO;

  HomeBodyCategoryModel({
    this.categoryResponseDTO,
  });
}

class HomeBodyCategoryViewModel extends StateNotifier<HomeBodyCategoryModel?> {
  final Ref ref;
  final repository = DefaultRepository();

  HomeBodyCategoryViewModel(super.state, this.ref);

  Future<void> getCategory(Map<String, dynamic> requestData) async {
    final response = await repository.reqPost(url: Constant.apiMainCategoryUrl, data: requestData);
    try {
      if (response != null) {
        if (response.statusCode == 200) {
          Map<String, dynamic> responseData = response.data;
          CategoryResponseDTO categoryResponseDTO = CategoryResponseDTO.fromJson(responseData);
          state = HomeBodyCategoryModel(categoryResponseDTO: categoryResponseDTO);
          return;
        }
      }
      state = HomeBodyCategoryModel(categoryResponseDTO: CategoryResponseDTO(result: false, message: "Network Or Data Error"));
    } catch(e) {
      // Catch and log any exceptions
      print('Error request Api: $e');
      state = HomeBodyCategoryModel(categoryResponseDTO: CategoryResponseDTO(result: false, message: e.toString()));
    }
  }
}

// ViewModel Provider 정의
final homeBodyCategoryModelProvider =
StateNotifierProvider<HomeBodyCategoryViewModel, HomeBodyCategoryModel?>((ref) {
  return HomeBodyCategoryViewModel(null, ref);
});