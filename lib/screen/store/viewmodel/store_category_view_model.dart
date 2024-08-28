import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:BliU/data/dto/store_favorite_product_data.dart';
import 'package:BliU/repository/store_repository.dart';
import 'package:BliU/data/response_dto.dart';

// 모델 클래스 정의 (데이터 상태를 관리하기 위한 DTO)
class StoreCategoryModel {
  final StoreFavoriteProductResponseDTO? storeFavoriteProductResponseDTO;
  final ProductListDTO? productListDTO;
  final List<ProductDTO>? productDetail;

  StoreCategoryModel({
    required this.storeFavoriteProductResponseDTO,
    required this.productListDTO,
    required this.productDetail,
  });

  // copyWith 메서드를 통해 상태 복사 및 수정
  StoreCategoryModel copyWith({
    StoreFavoriteProductResponseDTO? storeFavoriteProductResponseDTO,
    ProductListDTO? productListDTO,
    List<ProductDTO>? productDetail,
  }) {
    return StoreCategoryModel(
      storeFavoriteProductResponseDTO:
      storeFavoriteProductResponseDTO ?? this.storeFavoriteProductResponseDTO,
      productListDTO: productListDTO ?? this.productListDTO,
      productDetail: productDetail ?? this.productDetail,
    );
  }
}

// ViewModel 정의
class StoreCategoryViewModel extends StateNotifier<StoreCategoryModel?> {
  final Ref ref;

  StoreCategoryViewModel(super.state, this.ref) {
    notifyInit(); // ViewModel 초기화 시 데이터를 가져옴
  }

  Future<void> notifyInit() async {
    int mtIdx = 2;
    int pg = 1;
    String searchTxt = '';
    String category = 'all';
    String age = 'all';
    int sort = 2;

    // 로딩 상태로 업데이트
    state = StoreCategoryModel(
      storeFavoriteProductResponseDTO: null,
      productListDTO: null,
      productDetail: [],
    );

    try {
      // API 호출
      final ResponseDTO responseDTO = await StoreRepository()
          .fetchStoreProducts(
        mtIdx,
        pg,
        searchTxt,
        category,
        age,
        sort,
      );

      if (responseDTO.status == 200 && responseDTO.response != null) {
        if (responseDTO.response is List<ProductDTO>) {
          // 응답이 List<ProductDTO>인 경우 처리
          List<ProductDTO> productList = responseDTO.response as List<
              ProductDTO>;

          state = state?.copyWith(
            productDetail: productList,
          );
        } else if (responseDTO.response is Map<String, dynamic>) {
          // 응답이 Map<String, dynamic>인 경우 처리
          StoreFavoriteProductResponseDTO storeFavoriteProductResponseDTO =
          StoreFavoriteProductResponseDTO.fromJson(responseDTO.response);
          ProductListDTO productListDTO = storeFavoriteProductResponseDTO.data;

          state = state?.copyWith(
            storeFavoriteProductResponseDTO: storeFavoriteProductResponseDTO,
            productDetail: productListDTO.list,
          );
        } else {
          throw Exception(
              'Unexpected response type: ${responseDTO.response.runtimeType}');
        }
      } else {
        throw Exception('Failed to load products');
      }
    } catch (e) {
      print("Error loading products: $e");
    }
  }

    Future<void> loadMore({
    required int mtIdx,
    required int pg,
    String searchTxt = '',
    String category = 'all',
    String age = 'all',
    int sort = 2,
  }) async {
    try {
      // 추가 데이터 로드
      final ResponseDTO responseDTO = await StoreRepository().fetchStoreProducts(
        mtIdx,
        pg,
        searchTxt,
        category,
        age,
        sort,
      );

      if (responseDTO.status == 200 && responseDTO.response != null) {
        ProductListDTO newProductListDTO = ProductListDTO.fromJson(responseDTO.response['data']);

        // 상태 업데이트 (기존 데이터에 새 데이터 추가)
        state = state?.copyWith(
          productDetail: [...state!.productDetail!, ...newProductListDTO.list],
        );
      } else {
        throw Exception('Failed to load more products');
      }
    } catch (e) {
      print("Error loading more products: $e");
    }
  }
}

// ViewModel Provider 정의
final storeCategoryViewModelProvider = StateNotifierProvider<StoreCategoryViewModel, StoreCategoryModel?>((ref) {
  return StoreCategoryViewModel(null, ref);
});