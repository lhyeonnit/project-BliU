import 'package:BliU/api/default_repository.dart';
import 'package:BliU/const/constant.dart';
import 'package:BliU/dto/review_info_response_dto.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class MyReviewModel {}

class MyReviewViewModel extends StateNotifier<MyReviewModel?> {
  final Ref ref;
  final repository = DefaultRepository();

  MyReviewViewModel(super.state, this.ref);

  Future<ReviewInfoResponseDTO?> getList(Map<String, dynamic> requestData) async {
    try {
      final response = await repository.reqPost(url: Constant.apiMyPageReviewListUrl, data: requestData);
      if (response != null) {
        if (response.statusCode == 200) {
          Map<String, dynamic> responseData = response.data;
          ReviewInfoResponseDTO reviewInfoResponseDTO = ReviewInfoResponseDTO.fromJson(responseData);
          return reviewInfoResponseDTO;
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

final myReviewViewModelProvider =
StateNotifierProvider<MyReviewViewModel, MyReviewModel?>((req) {
  return MyReviewViewModel(null, req);
});