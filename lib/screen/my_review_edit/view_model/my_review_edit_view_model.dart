import 'package:BliU/api/default_repository.dart';
import 'package:BliU/const/constant.dart';
import 'package:BliU/dto/default_response_dto.dart';
import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class MyReviewEditModel {}

class MyReviewEditViewModel extends StateNotifier<MyReviewEditModel?> {
  final Ref ref;
  final repository = DefaultRepository();

  MyReviewEditViewModel(super.state, this.ref);

  Future<DefaultResponseDTO?> reviewUpdate(FormData formData) async {
    try {
      final response = await repository.reqPostFiles(url: Constant.apiMyPageReviewUpdateUrl, data: formData);
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
      if (kDebugMode) {
        print('Error fetching : $e');
      }
      return null;
    }
  }

}

final myReviewEditViewModelModelProvider =
StateNotifierProvider<MyReviewEditViewModel, MyReviewEditModel?>((req) {
  return MyReviewEditViewModel(null, req);
});