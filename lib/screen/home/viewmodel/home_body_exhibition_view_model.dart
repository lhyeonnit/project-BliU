import 'package:BliU/api/default_repository.dart';
import 'package:BliU/const/constant.dart';
import 'package:BliU/dto/exhibition_list_response_dto.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class HomeBodyExhibitionModel {
}

class HomeBodyExhibitionViewModel extends StateNotifier<HomeBodyExhibitionModel?> {
  final Ref ref;
  final repository = DefaultRepository();

  HomeBodyExhibitionViewModel(super.state, this.ref);

  Future<ExhibitionListResponseDTO?> getList() async {
    try {
      final response = await repository.reqPost(url: Constant.apiMainExhibitionListUrl,);
      if (response != null) {
        if (response.statusCode == 200) {
          Map<String, dynamic> responseData = response.data;
          ExhibitionListResponseDTO exhibitionListResponseDTO = ExhibitionListResponseDTO.fromJson(responseData);
          return exhibitionListResponseDTO;
        }
      }
      return null;
    } catch (e) {
      // Catch and log any exceptions
      print('Error fetching : $e');
      return null;
    }
  }

}

// ViewModel Provider 정의
final homeBodyExhibitionViewModelProvider =
StateNotifierProvider<HomeBodyExhibitionViewModel, HomeBodyExhibitionModel?>((ref) {
  return HomeBodyExhibitionViewModel(null, ref);
});