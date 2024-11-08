import 'package:BliU/api/default_repository.dart';
import 'package:BliU/const/constant.dart';
import 'package:BliU/data/category_data.dart';
import 'package:BliU/data/store_rank_data.dart';
import 'package:BliU/data/style_category_data.dart';
import 'package:BliU/dto/store_rank_response_dto.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class StoreRankingModel {
  bool listEmpty = false;
  List<StoreRankData> storeRankList = [];

  CategoryData? selectedAgeGroup;
  StyleCategoryData? selectedStyle;

  int page = 1;
  bool hasNextPage = true;
  bool isFirstLoadRunning = false;
  bool isLoadMoreRunning = false;
}

class StoreRankingViewModel extends StateNotifier<StoreRankingModel> {
  final Ref ref;
  final repository = DefaultRepository();

  StoreRankingViewModel(super.state, this.ref);

  void listLoad(Map<String, dynamic> requestData) async {
    state.isFirstLoadRunning = true;
    state.page = 1;
    state.hasNextPage = true;

    requestData.addAll({
      'pg': state.page,
    });

    final storeRankResponseDTO = await _getRank(requestData); // 서버에서 데이터 가져오기
    state.storeRankList = storeRankResponseDTO?.list ?? [];
    if (state.storeRankList.isNotEmpty) {
      state.listEmpty = false;
    } else {
      state.listEmpty = true;
    }
    state.isFirstLoadRunning = false;
    ref.notifyListeners();
  }

  void listNextLoad(Map<String, dynamic> requestData) async {
    if (state.hasNextPage && !state.isFirstLoadRunning && !state.isLoadMoreRunning){

      state.isLoadMoreRunning = true;
      state.page += 1;

      requestData.addAll({
        'pg': state.page,
      });

      final storeRankResponseDTO = await _getRank(requestData); // 서버에서 데이터 가져오기
      if (storeRankResponseDTO != null) {
        if ((storeRankResponseDTO.list ?? []).isNotEmpty) {
          state.storeRankList.addAll(storeRankResponseDTO.list ?? []);
        } else {
          state.hasNextPage = false;
        }
        ref.notifyListeners();
      }
      state.isLoadMoreRunning = false;
    }
  }

  Future<StoreRankResponseDTO?> _getRank(Map<String, dynamic> requestData) async {
    try {
      final response = await repository.reqPost(url: Constant.apiStoreRankUrl, data: requestData);
      if (response != null) {
        if (response.statusCode == 200) {
          Map<String, dynamic> responseData = response.data;
          StoreRankResponseDTO storeRankResponseDTO = StoreRankResponseDTO.fromJson(responseData);
          return storeRankResponseDTO;
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

  Future<bool> toggleLike(Map<String, dynamic> requestData) async {
    try {
      final response = await repository.reqPost(url: Constant.apiStoreLikeUrl, data: requestData,);
      if (response != null && response.statusCode == 200) {
        bool result = response.data['result'];
        return result;
      }
    } catch (e) {
      if (kDebugMode) {
        print('Error toggling like: $e');
      }
    }
    return false;
  }

  void setSelectedAgeGroup(CategoryData? selectedAgeGroup) {
    state.selectedAgeGroup = selectedAgeGroup;
    ref.notifyListeners();
  }

  void setSelectedStyle(StyleCategoryData? selectedStyle) {
    state.selectedStyle = selectedStyle;
    ref.notifyListeners();
  }
}

final storeRankingViewModelProvider =
StateNotifierProvider<StoreRankingViewModel, StoreRankingModel>((req) {
  return StoreRankingViewModel(StoreRankingModel(), req);
});