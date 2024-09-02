import 'package:BliU/data/dto/store_data.dart';
import 'package:BliU/repository/store_repository.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

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

}

// StoreDetailViewModel을 사용하는 Riverpod Provider
final storeDetailProvider = StateNotifierProvider.family<StoreDetailViewModel, StoreDetailModel?, int>((ref, stIdx) {
  final repository = ref.read(storeRepositoryProvider);
  const mtIdx = 2; // 실제 사용자의 mtIdx로 교체 필요
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
