import 'package:BliU/api/default_repository.dart';
import 'package:BliU/const/constant.dart';
import 'package:BliU/data/bookmark_data.dart';
import 'package:BliU/data/category_data.dart';
import 'package:BliU/data/product_data.dart';
import 'package:BliU/dto/bookmark_response_dto.dart';
import 'package:BliU/dto/default_response_dto.dart';
import 'package:BliU/dto/product_list_response_dto.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class StoreFavoriteModel {
  String sortOptionSelected = '';
  CategoryData? selectedAgeGroup;

  int bookMarkCount = 0;
  int bookMarkVisibleCount = 0;
  final List<List<BookmarkData>> bookMarkList = [];


  int count = 0;
  List<ProductData> productList = [];

  int page = 1;
  bool hasNextPage = true;
  bool isFirstLoadRunning = false;
  bool isLoadMoreRunning = false;
}

class StoreFavoriteViewModel extends StateNotifier<StoreFavoriteModel> {
  final Ref ref;
  final repository = DefaultRepository();

  StoreFavoriteViewModel(super.state, this.ref);

  /// 북마크 목록 초기화 및 가져오기
  void getBookmark(Map<String, dynamic> requestData, int page) async {
    final response = await repository.reqPost(url: Constant.apiStoreBookMarkUrl, data: requestData);
    try {
      if (response != null) {
        if (response.statusCode == 200) {
          Map<String, dynamic> responseData = response.data;
          BookmarkResponseDTO bookmarkResponseDTO = BookmarkResponseDTO.fromJson(responseData);
          final list = bookmarkResponseDTO.list ?? [];

          state.bookMarkCount = bookmarkResponseDTO.count ?? 0;
          state.bookMarkVisibleCount = list.length;

          if (state.bookMarkList.length >= page) {
            state.bookMarkList[page - 1] = list;
          } else {
            state.bookMarkList.add([]);
            state.bookMarkList[page - 1] = list;
          }

          ref.notifyListeners();
        }
      }
    } catch(e) {
      // Catch and log any exceptions
      if (kDebugMode) {
        print('Error request Api: $e');
      }
    }
  }

  void listLoad(Map<String, dynamic> requestProductData) async {

    state.isFirstLoadRunning = true;
    state.page = 1;
    state.hasNextPage = true;

    requestProductData.addAll({
      'pg': state.page,
    });

    state.count = 0;
    state.productList = [];
    ref.notifyListeners();

    final productListResponseDTO = await _getProductList(requestProductData);
    state.count = productListResponseDTO?.count ?? 0;
    state.productList = productListResponseDTO?.list ?? [];

    state.isFirstLoadRunning = false;
    ref.notifyListeners();
  }

  void listNextLoad(Map<String, dynamic> requestProductData) async {
    if (state.hasNextPage && !state.isFirstLoadRunning && !state.isLoadMoreRunning){
      state.isLoadMoreRunning = true;
      state.page += 1;

      requestProductData.addAll({
        'pg': state.page,
      });

      final productListResponseDTO = await _getProductList(requestProductData);
      if (productListResponseDTO != null) {
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

  Future<ProductListResponseDTO?> _getProductList(Map<String, dynamic> requestData) async {
    try {
      final response = await repository.reqPost(url: Constant.apiStoreProductsUrl, data: requestData);
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

  Future<DefaultResponseDTO?> productLike(Map<String, dynamic> requestData) async {
    try {
      final response = await repository.reqPost(url: Constant.apiProductLikeUrl, data: requestData);
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
      if (kDebugMode) {
        print('Error fetching : $e');
      }
      return null;
    }
  }

  /// 북마크 상태를 토글하는 메서드
  Future<void> toggleLike(Map<String, dynamic> requestData) async {
    await repository.reqPost(url: Constant.apiStoreLikeUrl, data: requestData,);
  }

  void setSortOptionSelected(String sortOptionSelected) {
    state.sortOptionSelected = sortOptionSelected;
    ref.notifyListeners();
  }

  void setSelectedAgeGroup(CategoryData? selectedAgeGroup) {
    state.selectedAgeGroup = selectedAgeGroup;
    ref.notifyListeners();
  }
}

// ViewModel Provider 정의
final storeFavoriteViewModelProvider =
    StateNotifierProvider<StoreFavoriteViewModel, StoreFavoriteModel>((req) {
  return StoreFavoriteViewModel(StoreFavoriteModel(), req);
});
