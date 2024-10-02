import 'package:BliU/api/default_repository.dart';
import 'package:BliU/const/constant.dart';
import 'package:BliU/dto/default_response_dto.dart';
import 'package:BliU/dto/exhibition_detail_response_dto.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class ExhibitionModel {

}

class ExhibitionViewModel extends StateNotifier<ExhibitionModel?> {
  final Ref ref;
  final repository = DefaultRepository();

  ExhibitionViewModel(super.state, this.ref);

  Future<ExhibitionDetailResponseDTO?> getDetail(Map<String, dynamic> requestData) async {
    final response = await repository.reqPost(url: Constant.apiMainExhibitionDetailUrl, data: requestData);
    try {
      if (response != null) {
        if (response.statusCode == 200) {
          Map<String, dynamic> responseData = response.data;
          ExhibitionDetailResponseDTO exhibitionDetailResponseDTO = ExhibitionDetailResponseDTO.fromJson(responseData);
          return exhibitionDetailResponseDTO;
        }
      }
      return null;
    } catch(e) {
      // Catch and log any exceptions
      print('Error request Api: $e');
      return null;
    }
  }

  Future<DefaultResponseDTO?> productLike(Map<String, dynamic> requestData) async {
    try {
      final response = await repository.reqPost(url: Constant.apiProductLikeUrl, data: requestData);
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
      print('Error fetching : $e');
      return null;
    }
  }
}

// ViewModel Provider 정의
final exhibitionViewModelProvider =
StateNotifierProvider<ExhibitionViewModel, ExhibitionModel?>((ref) {
  return ExhibitionViewModel(null, ref);
});