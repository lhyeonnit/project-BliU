import 'package:BliU/api/default_repository.dart';
import 'package:BliU/const/constant.dart';
import 'package:BliU/data/bookmark_data.dart';
import 'package:BliU/dto/bookmark_response_dto.dart';
import 'package:BliU/dto/category_response_dto.dart';
import 'package:BliU/dto/default_response_dto.dart';
import 'package:BliU/dto/product_list_response_dto.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class StoreFavoriteModel {
  BookmarkResponseDTO? bookmarkResponseDTO;

  StoreFavoriteModel({
    required this.bookmarkResponseDTO,
  });
}

class StoreFavoriteViewModel extends StateNotifier<StoreFavoriteModel?> {
  final Ref ref;
  final repository = DefaultRepository();

  StoreFavoriteViewModel(super.state, this.ref);

  Future<CategoryResponseDTO?> getCategory(Map<String, dynamic> requestData) async {
    final response = await repository.reqPost(url: Constant.apiMainCategoryUrl, data: requestData);
    try {
      if (response != null) {
        if (response.statusCode == 200) {
          Map<String, dynamic> responseData = response.data;
          CategoryResponseDTO categoryResponseDTO = CategoryResponseDTO.fromJson(responseData);
          return categoryResponseDTO;
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
  /// 북마크 목록 초기화 및 가져오기
  Future<BookmarkResponseDTO?> getBookmark(Map<String, dynamic> requestData) async {
    final response = await repository.reqPost(url: Constant.apiStoreBookMarkUrl, data: requestData);
    try {
      if (response != null) {
        if (response.statusCode == 200) {
          Map<String, dynamic> responseData = response.data;
          BookmarkResponseDTO bookmarkResponseDTO = BookmarkResponseDTO.fromJson(responseData);
          return bookmarkResponseDTO;
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
  Future<CategoryResponseDTO?> getAgeCategory() async {
    final response = await repository.reqGet(url: Constant.apiCategoryAgeUrl);
    try {
      if (response != null) {
        if (response.statusCode == 200) {
          Map<String, dynamic> responseData = response.data;
          CategoryResponseDTO categoryResponseDTO = CategoryResponseDTO.fromJson(responseData);
          return categoryResponseDTO;
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
  Future<ProductListResponseDTO?> getProductList(Map<String, dynamic> requestData) async {
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
    try {
      final response = await repository.reqPost(url: Constant.apiStoreLikeUrl, data: requestData,);

      if (response != null && response.statusCode == 200) {
        bool result = response.data['result'];
        int stIdx = requestData['st_idx'];

        if (result) {
          // 북마크 리스트에서 stIdx를 찾아 상태 반전
          List<BookmarkData>? updatedList = state?.bookmarkResponseDTO?.list?.map((store) {
            if (store.stIdx == stIdx) {
              store.stLike = store.stLike == 1 ? 0 : 1; // 북마크 상태 반전
            }
            return store;
          }).toList();

          // 상태 업데이트
          state = StoreFavoriteModel(
            bookmarkResponseDTO: BookmarkResponseDTO(
              result: state?.bookmarkResponseDTO?.result ?? false,
              count: updatedList?.length ?? 0,
              list: updatedList,
            ),
          );
        }
      }
    } catch (e) {
      if (kDebugMode) {
        print('Error toggling like: $e');
      }
    }
  }
}

// ViewModel Provider 정의
final storeFavoriteViewModelProvider =
    StateNotifierProvider<StoreFavoriteViewModel, StoreFavoriteModel?>((req) {
  return StoreFavoriteViewModel(null, req);
});
