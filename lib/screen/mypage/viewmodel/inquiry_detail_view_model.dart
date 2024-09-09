import 'package:BliU/api/default_repository.dart';
import 'package:BliU/const/constant.dart';
import 'package:BliU/dto/qna_detail_response_dto.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class InquiryDetailModel {
  QnaDetailResponseDTO? qnaDetailResponseDTO;

  InquiryDetailModel({
    this.qnaDetailResponseDTO,
  });
}

class InquiryDetailViewModel extends StateNotifier<InquiryDetailModel?> {
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
          state = InquiryDetailModel(qnaDetailResponseDTO: qnaDetailResponseDTO);
          return;
        }
      }
      state = InquiryDetailModel(
          qnaDetailResponseDTO: QnaDetailResponseDTO(
              result: false,
              message: "Network Or Data Error",
              data: null)
      );
    } catch (e) {
      // Catch and log any exceptions
      print('Error fetching : $e');
      state = InquiryDetailModel(
          qnaDetailResponseDTO: QnaDetailResponseDTO(
              result: false,
              message: e.toString(),
              data: null)
      );
    }
  }
}

final inquiryDetailModelProvider =
StateNotifierProvider<InquiryDetailViewModel, InquiryDetailModel?>((req) {
  return InquiryDetailViewModel(null, req);
});