import 'package:BliU/api/default_repository.dart';
import 'package:BliU/const/constant.dart';
import 'package:BliU/dto/default_response_dto.dart';
import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class ProductReviewEditModel {}

class ProductReviewEditViewModel extends StateNotifier<ProductReviewEditModel?> {
  final Ref ref;
  final repository = DefaultRepository();

  ProductReviewEditViewModel(super.state, this.ref);

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
      print('Error fetching : $e');
      return null;
    }
  }

}

final productReviewEditViewModelProvider =
StateNotifierProvider<ProductReviewEditViewModel, ProductReviewEditModel?>((req) {
  return ProductReviewEditViewModel(null, req);
});