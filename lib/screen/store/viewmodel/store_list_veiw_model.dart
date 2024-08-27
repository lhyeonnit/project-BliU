import 'package:BliU/data/dto/store_data.dart';
import 'package:BliU/repository/store_repository.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter/material.dart';

class StoreDetailModel {
  final StoreDetailDataDTO? storeDetailData;
  final List<ProductDTO>? productList; // 상품 목록
  final bool isBookmarked; // 즐겨찾기 여부

  StoreDetailModel({
    this.storeDetailData,
    this.productList,
    this.isBookmarked = true, // 기본적으로 즐겨찾기로 설정
  });
}

class StoreDetailViewModel extends StateNotifier<StoreDetailModel?> {
  final StoreRepository storeRepository;
  final int mtIdx;
  final int stIdx;
  final String category;

  StoreDetailViewModel({
    required this.storeRepository,
    required this.mtIdx,
    required this.stIdx,
    this.category = 'all',
  }) : super(null);

  // 상점 정보 및 상품 목록 초기화
  Future<void> fetchStoreDetail() async {
    try {
      final response = await storeRepository.fetchStore(
        mtIdx: mtIdx,
        stIdx: stIdx,
        pg: 1,
        category: category,
      );

      if (response.status == 200) {
        // 항상 result를 true로 설정하고 데이터 처리
        final storeData = StoreDetailResponseDTO.fromJson({
          'result': true,
          'data': response.response['data'], // 실제 API로부터의 데이터
        });

        state = StoreDetailModel(
          storeDetailData: storeData.data,
          productList: storeData.data.productList,
          isBookmarked: true, // 기본적으로 즐겨찾기 설정
        );
      } else {
        print('Failed to load store details: ${response.errorMessage}');
      }
    } catch (e) {
      print('Error fetching store details: $e');
    }
  }

  // // 즐겨찾기 상태 토글
  // Future<void> toggleLike() async {
  //   try {
  //     final currentStatus = state?.isBookmarked ?? false;
  //     final newStatus = !currentStatus;
  //
  //     final response = await storeRepository.toggleStoreLike(
  //       mtIdx: mtIdx,
  //       stIdx: stIdx,
  //     );
  //
  //     if (response.status == 200) {
  //       state = StoreDetailModel(
  //         storeDetailData: state?.storeDetailData,
  //         productList: state?.productList,
  //         isBookmarked: newStatus,
  //       );
  //     } else {
  //       print('Failed to toggle like: ${response.errorMessage}');
  //     }
  //   } catch (e) {
  //     print('Error toggling like: $e');
  //   }
  // }
  //
  // // 즐겨찾기 목록 가져오기
  // Future<void> fetchBookmarkList(int page) async {
  //   try {
  //     final response = await storeRepository.fetchBookmarkList(
  //       mtIdx: mtIdx,
  //       pg: page,
  //     );
  //
  //     if (response.status == 200) {
  //       final bookmarkList = response.response['list'];
  //       print('Fetched bookmarks: $bookmarkList');
  //     } else {
  //       print('Failed to fetch bookmarks: ${response.errorMessage}');
  //     }
  //   } catch (e) {
  //     print('Error fetching bookmarks: $e');
  //   }
  // }

  // 즐겨찾기한 상점의 상품 목록 가져오기
  Future<void> fetchBookmarkedStoreProducts(int page) async {
    try {
      final response = await storeRepository.fetchStoreProducts(
        mtIdx: mtIdx,
        stIdx: stIdx,
        pg: page,
        category: category,
      );

      if (response.status == 200) {
        final productList = response.response['list'];
        print('Fetched products: $productList');
      } else {
        print('Failed to fetch products: ${response.errorMessage}');
      }
    } catch (e) {
      print('Error fetching products: $e');
    }
  }
}

// StoreDetailViewModel을 사용하는 Riverpod Provider
final storeDetailProvider = StateNotifierProvider.family<StoreDetailViewModel, StoreDetailModel?, int>((ref, stIdx) {
  final repository = ref.read(storeRepositoryProvider);
  final mtIdx = 2; // 실제 사용자의 mtIdx로 교체 필요
  final viewModel = StoreDetailViewModel(
    storeRepository: repository,
    mtIdx: mtIdx,
    stIdx: stIdx,
  );
  viewModel.fetchStoreDetail(); // 초기화
  return viewModel;
});

final storeRepositoryProvider = Provider<StoreRepository>((ref) {
  return StoreRepository(); // StoreRepository 인스턴스를 반환
});
