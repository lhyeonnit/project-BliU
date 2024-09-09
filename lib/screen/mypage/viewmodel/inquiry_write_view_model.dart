import 'package:BliU/api/default_repository.dart';
import 'package:BliU/const/constant.dart';
import 'package:BliU/dto/default_response_dto.dart';
import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class InquiryWriteViewModel extends StateNotifier<dynamic> {
  final Ref ref;
  final repository = DefaultRepository();

  InquiryWriteViewModel(super.state, this.ref);

  Future<DefaultResponseDTO?> qnaSeller(FormData formData) async {
    try {
      final response = await repository.reqPostFiles(url: Constant.apiMyPageQnaSellerUrl, data: formData);
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
      return DefaultResponseDTO(result: false, message: e.toString());
    }
  }

  Future<DefaultResponseDTO?> qnaWrite(FormData formData) async {
    try {
      final response = await repository.reqPostFiles(url: Constant.apiMyPageQnaWriteUrl, data: formData);
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
      return DefaultResponseDTO(result: false, message: e.toString());
    }
  }
}

final inquiryWriteModelProvider =
StateNotifierProvider<InquiryWriteViewModel, dynamic>((req) {
  return InquiryWriteViewModel(null, req);
});