import 'package:BliU/api/default_repository.dart';
import 'package:BliU/const/constant.dart';
import 'package:BliU/data/review_data.dart';
import 'package:BliU/dto/review_info_response_dto.dart';
import 'package:BliU/utils/shared_preferences_manager.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class MyReviewModel {
  List<ReviewData> reviewList = [];

  bool isListVisible = false;
  int reviewCount = 0;

  int page = 1;
  bool hasNextPage = true;
  bool isFirstLoadRunning = false;
  bool isLoadMoreRunning = false;
}

class MyReviewViewModel extends StateNotifier<MyReviewModel> {
  final Ref ref;
  final repository = DefaultRepository();

  MyReviewViewModel(super.state, this.ref);

  void listLoad() async {
    state.isFirstLoadRunning = true;
    state.page = 1;
    state.hasNextPage = true;

    final requestData = await _makeRequestData();

    state.reviewCount = 0;
    state.reviewList = [];
    ref.notifyListeners();

    final reviewInfoResponseDTO = await _getList(requestData);
    state.reviewCount = reviewInfoResponseDTO?.count ?? 0;
    state.reviewList = reviewInfoResponseDTO?.list ?? [];
    if (state.reviewList.isNotEmpty) {
      state.isListVisible = true;
    }

    state.isFirstLoadRunning = false;
    ref.notifyListeners();
  }

  void listNextLoad() async {
    if (state.hasNextPage && !state.isFirstLoadRunning && !state.isLoadMoreRunning){
      state.isLoadMoreRunning = true;
      state.page += 1;

      final requestData = await _makeRequestData();

      final reviewInfoResponseDTO = await _getList(requestData);
      if (reviewInfoResponseDTO != null) {
        if ((reviewInfoResponseDTO.list ?? []).isNotEmpty) {
          state.reviewCount = reviewInfoResponseDTO.count ?? 0;
          state.reviewList.addAll(reviewInfoResponseDTO.list ?? []);
        } else {
          state.hasNextPage = false;
        }
        ref.notifyListeners();
      }

      state.isLoadMoreRunning = false;
    }
  }

  Future<Map<String, dynamic>> _makeRequestData() async {
    final pref = await SharedPreferencesManager.getInstance();
    final mtIdx = pref.getMtIdx();
    Map<String, dynamic> requestData = {
      'mt_idx': mtIdx,
      'pg' : state.page,
    };

    return requestData;
  }

  Future<ReviewInfoResponseDTO?> _getList(Map<String, dynamic> requestData) async {
    try {
      final response = await repository.reqPost(url: Constant.apiMyPageReviewListUrl, data: requestData);
      if (response != null) {
        if (response.statusCode == 200) {
          Map<String, dynamic> responseData = response.data;
          ReviewInfoResponseDTO reviewInfoResponseDTO = ReviewInfoResponseDTO.fromJson(responseData);
          return reviewInfoResponseDTO;
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

final myReviewViewModelProvider =
StateNotifierProvider<MyReviewViewModel, MyReviewModel>((req) {
  return MyReviewViewModel(MyReviewModel(), req);
});