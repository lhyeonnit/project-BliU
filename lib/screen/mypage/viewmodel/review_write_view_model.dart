import 'package:BliU/api/default_repository.dart';
import 'package:BliU/const/constant.dart';
import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class ReviewWriteModel {}

class ReviewWriteViewModel extends StateNotifier<ReviewWriteModel?> {
  final Ref ref;
  final repository = DefaultRepository();

  ReviewWriteViewModel(super.state, this.ref);

  Future<Map<String, dynamic>?> reviewWrite(FormData formData) async {
    try {
      final response = await repository.reqPostFiles(url: Constant.apiMyPageReviewWriteUrl, data: formData);
      if (response != null) {
        if (response.statusCode == 200) {
          Map<String, dynamic> responseData = response.data;
          return responseData;
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

final reviewWriteViewModelProvider =
StateNotifierProvider<ReviewWriteViewModel, ReviewWriteModel?>((req) {
  return ReviewWriteViewModel(null, req);
});