import 'package:BliU/api/default_repository.dart';
import 'package:BliU/const/constant.dart';
import 'package:BliU/data/faq_category_data.dart';
import 'package:BliU/data/faq_data.dart';
import 'package:BliU/dto/faq_category_response_dto.dart';
import 'package:BliU/dto/faq_response_dto.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class FaqModel {
  List<FaqCategoryData> faqCategories = [];
  List<FaqData> faqList = [];

  int page = 1;
  bool hasNextPage = true;
  bool isFirstLoadRunning = false;
  bool isLoadMoreRunning = false;

  int selectedCategoryIndex = 0;
  String searchTxt = "";
}

class FaqViewModel extends StateNotifier<FaqModel> {
  final Ref ref;
  final repository = DefaultRepository();

  FaqViewModel(super.state, this.ref);

  void getCategory() async {
    try {
      final response = await repository.reqPost(url: Constant.apiMyPageFaqCategoryUrl);
      if (response != null) {
        if (response.statusCode == 200) {
          Map<String, dynamic> responseData = response.data;
          FaqCategoryResponseDTO faqCategoryResponseDTO = FaqCategoryResponseDTO.fromJson(responseData);
          state.faqCategories = [FaqCategoryData(fcIdx: -1, cftName: "전체")];
          state.faqCategories.addAll(faqCategoryResponseDTO.list ?? []);
          ref.notifyListeners();
        }
      }
    } catch (e) {
      // Catch and log any exceptions
      if (kDebugMode) {
        print('Error fetching : $e');
      }
    }
  }

  void listLoad() async {
    state.isFirstLoadRunning = true;
    state.page = 1;
    state.hasNextPage = true;

    var faqCategory = "all";
    if (state.selectedCategoryIndex > 0) {
      faqCategory = state.faqCategories[state.selectedCategoryIndex].fcIdx.toString();
    }

    Map<String, dynamic> requestData = {
      'search_txt': state.searchTxt,
      'faq_category': faqCategory,
      'pg': state.page
    };

    state.faqList = [];
    ref.notifyListeners();

    final faqResponseDTO = await _getList(requestData);
    state.faqList = faqResponseDTO?.list ?? [];
    state.isFirstLoadRunning = false;
    ref.notifyListeners();
  }

  void listNextLoad() async {
    if (state.hasNextPage && !state.isFirstLoadRunning && !state.isLoadMoreRunning){
      state.isLoadMoreRunning = true;
      state.page += 1;

      var faqCategory = "all";
      if (state.selectedCategoryIndex > 0) {
        faqCategory = state.faqCategories[state.selectedCategoryIndex].fcIdx.toString();
      }

      Map<String, dynamic> requestData = {
        'search_txt': state.searchTxt,
        'faq_category': faqCategory,
        'pg': state.page
      };

      final faqResponseDTO = await _getList(requestData);
      if (faqResponseDTO != null) {
        if ((faqResponseDTO.list ?? []).isNotEmpty) {
          state.faqList.addAll(faqResponseDTO.list ?? []);
        } else {
          state.hasNextPage = false;
        }
        ref.notifyListeners();
      }

      state.isLoadMoreRunning = false;
    }
  }

  Future<FaqResponseDTO?> _getList(Map<String, dynamic> requestData) async {
    try {
      final response = await repository.reqPost(url: Constant.apiMyPageFaqUrl, data: requestData);
      if (response != null) {
        if (response.statusCode == 200) {
          Map<String, dynamic> responseData = response.data;
          FaqResponseDTO faqResponseDTO = FaqResponseDTO.fromJson(responseData);
          return faqResponseDTO;
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

  void setSearchTxt(String searchTxt) {
    state.searchTxt = searchTxt;
  }

  void setSelectedCategoryIndex(int index) {
    state.selectedCategoryIndex = index;
    ref.notifyListeners();
  }
}

final faqViewModelProvider =
StateNotifierProvider<FaqViewModel, FaqModel>((req) {
  return FaqViewModel(FaqModel(), req);
});