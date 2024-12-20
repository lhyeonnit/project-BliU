import 'package:BliU/api/default_repository.dart';
import 'package:BliU/const/constant.dart';
import 'package:BliU/dto/default_response_dto.dart';
import 'package:BliU/dto/qna_detail_response_dto.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class InquiryDetailModel {
  QnaDetailResponseDTO? qnaDetailResponseDTO;
}

class InquiryDetailViewModel extends StateNotifier<InquiryDetailModel> {
  final Ref ref;
  final repository = DefaultRepository();

  InquiryDetailViewModel(super.state, this.ref);

  Future<void> getDetail(Map<String, dynamic> requestData) async {
    try {
      final response = await repository.reqPost(url: Constant.apiMyPageQnaDetailUrl, data: requestData);
      if (response != null) {
        if (response.statusCode == 200) {
          Map<String, dynamic> responseData = response.data;
          QnaDetailResponseDTO qnaDetailResponseDTO = QnaDetailResponseDTO.fromJson(responseData);
          state.qnaDetailResponseDTO = qnaDetailResponseDTO;
          ref.notifyListeners();
          return;
        }
      }
      state.qnaDetailResponseDTO = QnaDetailResponseDTO(
        result: false,
        message: "Network Or Data Error",
        data: null,
      );
      ref.notifyListeners();
    } catch (e) {
      // Catch and log any exceptions
      if (kDebugMode) {
        print('Error fetching : $e');
      }
      state.qnaDetailResponseDTO = QnaDetailResponseDTO(
        result: false,
        message: e.toString(),
        data: null,
      );
      ref.notifyListeners();
    }
  }

  Future<DefaultResponseDTO> delete(Map<String, dynamic> requestData) async {
    try {
      final response = await repository.reqPost(url: Constant.apiMyPageQnaDelUrl, data: requestData);
      if (response != null) {
        if (response.statusCode == 200) {
          Map<String, dynamic> responseData = response.data;
          DefaultResponseDTO defaultResponseDTO = DefaultResponseDTO.fromJson(responseData);
          return defaultResponseDTO;
        }
      }
      return DefaultResponseDTO(result: false, message: "Network Error");
    } catch (e) {
      // Catch and log any exceptions
      if (kDebugMode) {
        print('Error fetching : $e');
      }
      return DefaultResponseDTO(result: false, message: e.toString());
    }
  }
}

final inquiryDetailViewModelProvider =
StateNotifierProvider<InquiryDetailViewModel, InquiryDetailModel>((req) {
  return InquiryDetailViewModel(InquiryDetailModel(), req);
});