import 'package:BliU/api/default_repository.dart';
import 'package:BliU/const/constant.dart';
import 'package:BliU/dto/default_response_dto.dart';
import 'package:BliU/dto/product_list_response_dto.dart';
import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class SmartLensModel {

}

class SmartLensViewModel extends StateNotifier<SmartLensModel?> {
  final Ref ref;
  final repository = DefaultRepository();

  SmartLensViewModel(super.state, this.ref);

  Future<DefaultResponseDTO?> photoUpload(FormData formData) async {
    try {
      final response = await repository.reqPostFiles(url: Constant.apiSearchSmartLensUrl, data: formData);
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
      return DefaultResponseDTO(result: false, message: e.toString());
    }
  }
  Future<ProductListResponseDTO?> getList(FormData formData) async {
    try {
      final response = await repository.reqPostFiles(url: Constant.apiSearchSmartLensUrl, data: formData);
      if (response != null) {
        if (response.statusCode == 200) {
          Map<String, dynamic> responseData = response.data;
          ProductListResponseDTO productListResponseDTO = ProductListResponseDTO.fromJson(responseData);
          return productListResponseDTO;
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
      if (kDebugMode) {
        print('Error fetching : $e');
      }
      return null;
    }
  }
}

// ViewModel Provider 정의
final smartLensViewModelProvider =
StateNotifierProvider<SmartLensViewModel, SmartLensModel?>((ref) {
  return SmartLensViewModel(null, ref);
});