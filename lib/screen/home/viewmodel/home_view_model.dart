import 'package:BliU/api/default_repository.dart';
import 'package:BliU/const/constant.dart';
import 'package:BliU/dto/category_response_dto.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class HomeModel {
}

class HomeViewModel extends StateNotifier<HomeModel?> {
  final Ref ref;
  final repository = DefaultRepository();

  HomeViewModel(super.state, this.ref);

  Future<CategoryResponseDTO?> getCategory(Map<String, dynamic> requestData) async {
    final response = await repository.reqPost(url: Constant.apiMainCategoryUrl, data: requestData);
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
      print('Error request Api: $e');
      return null;
    }
  }
}

// ViewModel Provider 정의
final homeViewModelProvider =
StateNotifierProvider<HomeViewModel, HomeModel?>((ref) {
  return HomeViewModel(null, ref);
});