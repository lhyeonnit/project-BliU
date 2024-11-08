import 'package:BliU/api/default_repository.dart';
import 'package:BliU/const/constant.dart';
import 'package:BliU/data/qna_data.dart';
import 'package:BliU/dto/qna_list_response_dto.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class MyInquiryProductModel {
  int currentPage = 1;
  int totalPages = 1;

  int count = 0;
  List<QnaData> qnaList = [];
}

class MyInquiryProductViewModel extends StateNotifier<MyInquiryProductModel> {
  final Ref ref;
  final repository = DefaultRepository();

  MyInquiryProductViewModel(super.state, this.ref);

  Future<void> getList(Map<String, dynamic> requestData) async {
    try {
      final response = await repository.reqPost(url: Constant.apiMyPageQnaListUrl, data: requestData);
      if (response != null) {
        if (response.statusCode == 200) {
          Map<String, dynamic> responseData = response.data;
          QnaListResponseDTO qnaListResponseDTO = QnaListResponseDTO.fromJson(responseData);

          state.count =  qnaListResponseDTO.count ?? 0;
          List<QnaData> addList = qnaListResponseDTO.list ?? [];
          for (var item in  addList) {
            state.qnaList.add(item);
          }

          if (state.count > 0) {
            state.totalPages = (state.count~/10);
            if ((state.count%10) > 0) {
              state.totalPages = state.totalPages + 1;
            }
          }

          ref.notifyListeners();
          return;
        }
      }
    } catch (e) {
      // Catch and log any exceptions
      if (kDebugMode) {
        print('Error fetching : $e');
      }
    }
  }

  void clearQnaList() {
    state.qnaList.clear();
  }

  void setCurrentPage(int page) {
    state.currentPage = page;
  }

}

final myInquiryProductViewModelProvider =
StateNotifierProvider<MyInquiryProductViewModel, MyInquiryProductModel>((req) {
  return MyInquiryProductViewModel(MyInquiryProductModel(), req);
});