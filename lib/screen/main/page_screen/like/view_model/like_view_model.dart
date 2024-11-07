import 'package:BliU/api/default_repository.dart';
import 'package:BliU/const/constant.dart';
import 'package:BliU/data/product_data.dart';
import 'package:BliU/dto/default_response_dto.dart';
import 'package:BliU/dto/product_list_response_dto.dart';
import 'package:BliU/screen/main/view_model/main_view_model.dart';
import 'package:BliU/utils/shared_preferences_manager.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class LikeModel {

  int count = 0;
  List<ProductData> productList = [];

  bool listEmpty = false;

  int page = 1;
  bool hasNextPage = true;
  bool isFirstLoadRunning = false;
  bool isLoadMoreRunning = false;
}

class LikeViewModel extends StateNotifier<LikeModel> {
  final Ref ref;
  final repository = DefaultRepository();

  LikeViewModel(super.state, this.ref);

  void listLoad(int index) async {
    state.isFirstLoadRunning = true;
    state.page = 1;
    state.hasNextPage = true;

    final requestData = await _makeRequestData(index);
    state.productList = [];
    ref.notifyListeners();


    final productListResponseDTO = await _getList(requestData);
    state.count = productListResponseDTO?.count ?? 0;
    state.productList = productListResponseDTO?.list ?? [];

    if (state.productList.isNotEmpty) {
      state.listEmpty = false;
    } else {
      state.listEmpty = true;
    }
    state.isFirstLoadRunning = false;
    ref.notifyListeners();
  }

  void listNextLoad(int index) async {
    if (state.hasNextPage && !state.isFirstLoadRunning && !state.isLoadMoreRunning){
      state.isLoadMoreRunning = true;
      state.page += 1;

      final requestData = await _makeRequestData(index);

      final productListResponseDTO = await _getList(requestData);
      if (productListResponseDTO != null) {
        state.count = productListResponseDTO.count;
        if (productListResponseDTO.list.isNotEmpty) {
          state.productList.addAll(productListResponseDTO.list);
        } else {
          state.hasNextPage = false;
        }
        ref.notifyListeners();
      }

      state.isLoadMoreRunning = false;
    }
  }

  Future<Map<String, dynamic>> _makeRequestData(int index) async {
    final pref = await SharedPreferencesManager.getInstance();
    final mtIdx = pref.getMtIdx();

    final mainModel = ref.read(mainViewModelProvider);
    final productCategories = mainModel.productCategories;

    String category = "all";
    final categoryData = productCategories[index];
    if ((categoryData.ctIdx ?? 0) > 0) {
      category = categoryData.ctIdx.toString();
    }

    Map<String, dynamic> requestData = {
      'mt_idx': mtIdx,
      'category': category,
      'sub_category': "all",
      'pg': state.page,
    };

    return requestData;
  }

  Future<ProductListResponseDTO?> _getList(Map<String, dynamic> requestData) async {
    try {
      final response = await repository.reqPost(url: Constant.apiProductLikeListUrl, data: requestData);
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

  void productLike(Map<String, dynamic> requestData, int index) async {
    try {
      final response = await repository.reqPost(url: Constant.apiProductLikeUrl, data: requestData);
      if (response != null) {
        if (response.statusCode == 200) {
          Map<String, dynamic> responseData = response.data;
          DefaultResponseDTO defaultResponseDTO = DefaultResponseDTO.fromJson(responseData);
          if (defaultResponseDTO.result == true) {
            state.productList.removeAt(index);
            ref.notifyListeners();
          }
        }
      }
    } catch (e) {
      // Catch and log any exceptions
      if (kDebugMode) {
        print('Error fetching : $e');
      }
    }
  }
}

// ViewModel Provider 정의
final likeViewModelProvider =
StateNotifierProvider<LikeViewModel, LikeModel>((ref) {
  return LikeViewModel(LikeModel(), ref);
});