import 'package:BliU/api/default_repository.dart';
import 'package:BliU/const/constant.dart';
import 'package:BliU/data/qna_data.dart';
import 'package:BliU/dto/qna_list_response_dto.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class ProductInquiryModel {
  QnaListResponseDTO? qnaListResponseDTO;

  ProductInquiryModel({
    this.qnaListResponseDTO,
  });
}

class ProductInquiryViewModel extends StateNotifier<ProductInquiryModel?> {
  final Ref ref;
  final repository = DefaultRepository();

  ProductInquiryViewModel(super.state, this.ref);

  Future<void> getList(Map<String, dynamic> requestData) async {
    try {
      final response = await repository.reqPost(url: Constant.apiProductQnaListUrl, data: requestData);
      if (response != null) {
        if (response.statusCode == 200) {
          Map<String, dynamic> responseData = response.data;
          QnaListResponseDTO qnaListResponseDTO = QnaListResponseDTO.fromJson(responseData);

          var list = state?.qnaListResponseDTO?.list ?? [];
          List<QnaData> addList = qnaListResponseDTO.list ?? [];
          for (var item in  addList) {
            list.add(item);
          }

          qnaListResponseDTO.list = list;

          state = ProductInquiryModel(qnaListResponseDTO: qnaListResponseDTO);
          return;
        }
      }
      state = state;
    } catch (e) {
      // Catch and log any exceptions
      print('Error fetching : $e');
      state = state;
    }
  }
}

final productInquiryModelProvider =
StateNotifierProvider<ProductInquiryViewModel, ProductInquiryModel?>((req) {
  return ProductInquiryViewModel(null, req);
});