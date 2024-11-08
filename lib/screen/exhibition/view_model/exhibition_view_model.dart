import 'package:BliU/api/default_repository.dart';
import 'package:BliU/const/constant.dart';
import 'package:BliU/data/exhibition_data.dart';
import 'package:BliU/data/product_data.dart';
import 'package:BliU/dto/exhibition_detail_response_dto.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class ExhibitionModel {
  ExhibitionData? exhibitionData;

  List<ProductData> productList = [];

  int page = 1;
  bool hasNextPage = true;
  bool isFirstLoadRunning = false;
  bool isLoadMoreRunning = false;
}

class ExhibitionViewModel extends StateNotifier<ExhibitionModel> {
  final Ref ref;
  final repository = DefaultRepository();

  ExhibitionViewModel(super.state, this.ref);

  void listLoad(Map<String, dynamic> requestData) async {
    state.isFirstLoadRunning = true;
    state.page = 1;
    state.hasNextPage = true;

    requestData.addAll({
      'pg': state.page,
    });

    state.productList = [];
    ref.notifyListeners();

    final exhibitionDetailResponseDTO = await _getDetail(requestData);
    if (exhibitionDetailResponseDTO != null) {
      if (exhibitionDetailResponseDTO.result == true) {
        state.exhibitionData = exhibitionDetailResponseDTO.data;
        state.productList = exhibitionDetailResponseDTO.data?.product ?? [];
      }
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

      final exhibitionDetailResponseDTO = await _getDetail(requestData);
      if (exhibitionDetailResponseDTO != null) {
        if ((exhibitionDetailResponseDTO.data?.product ?? []).isNotEmpty) {
          state.productList.addAll(exhibitionDetailResponseDTO.data?.product ?? []);
        } else {
          state.hasNextPage = false;
        }
        ref.notifyListeners();
      }

      state.isLoadMoreRunning = false;
    }
  }

  Future<ExhibitionDetailResponseDTO?> _getDetail(Map<String, dynamic> requestData) async {
    final response = await repository.reqPost(url: Constant.apiMainExhibitionDetailUrl, data: requestData);
    try {
      if (response != null) {
        if (response.statusCode == 200) {
          Map<String, dynamic> responseData = response.data;
          ExhibitionDetailResponseDTO exhibitionDetailResponseDTO = ExhibitionDetailResponseDTO.fromJson(responseData);
          return exhibitionDetailResponseDTO;
        }
      }
      return null;
    } catch(e) {
      // Catch and log any exceptions
      if (kDebugMode) {
        print('Error request Api: $e');
      }
      return null;
    }
  }
}

// ViewModel Provider 정의
final exhibitionViewModelProvider =
StateNotifierProvider<ExhibitionViewModel, ExhibitionModel>((ref) {
  return ExhibitionViewModel(ExhibitionModel(), ref);
});