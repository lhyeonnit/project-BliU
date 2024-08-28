import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:BliU/data/dto/store_favorite_product_data.dart';
import 'package:BliU/repository/store_repository.dart';
import 'package:BliU/data/response_dto.dart';

// 모델 클래스 정의 (데이터 상태를 관리하기 위한 DTO)
class StoreCategoryModel {
  StoreFavoriteProductResponseDTO? storeFavoriteProductResponseDTO;
  ProductListDTO? productListDTO;
  List<ProductDTO>? productDetail;
  bool isLoading;
  bool hasMore;
  int page; // 페이지 번호 추가

  StoreCategoryModel({
    required this.storeFavoriteProductResponseDTO,
    required this.productListDTO,
    required this.productDetail,
    required this.isLoading,
    required this.hasMore,
    required this.page,
  });

  // copyWith 메서드를 통해 상태 복사 및 수정
  StoreCategoryModel copyWith({
    StoreFavoriteProductResponseDTO? storeFavoriteProductResponseDTO,
    ProductListDTO? productListDTO,
    List<ProductDTO>? productDetail,
    bool? isLoading,
    bool? hasMore,
    int? page,
  }) {
    return StoreCategoryModel(
      storeFavoriteProductResponseDTO: storeFavoriteProductResponseDTO ?? this.storeFavoriteProductResponseDTO,
      productListDTO: productListDTO ?? this.productListDTO,
      productDetail: productDetail ?? this.productDetail,
      isLoading: isLoading ?? this.isLoading,
      hasMore: hasMore ?? this.hasMore,
      page: page ?? this.page,
    );
  }
}

// ViewModel 정의
class StoreCategoryViewModel extends StateNotifier<StoreCategoryModel?> {
  final Ref ref;

  StoreCategoryViewModel(this.ref) : super(null) {
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
      isLoading: true,
      hasMore: true,
      page: 1,
    );

    try {
      // 실제 API 호출
      final ResponseDTO responseDTO = await StoreRepository().fetchStoreProducts(
        mtIdx,
        pg,
        searchTxt,
        category,
        age,
        sort,
      );

      if (responseDTO.status == 200 && responseDTO.response != null) {
        StoreFavoriteProductResponseDTO storeFavoriteProductResponseDTO = StoreFavoriteProductResponseDTO.fromJson(responseDTO.response);
        ProductListDTO productListDTO = storeFavoriteProductResponseDTO.data;

        state = state?.copyWith(
          storeFavoriteProductResponseDTO: storeFavoriteProductResponseDTO,
          productListDTO: productListDTO,
          productDetail: productListDTO.list,
          isLoading: false,
          hasMore: productListDTO.list.length >= 10,
        );
      } else {
        throw Exception('Failed to load products');
      }
    } catch (e) {
      state = state?.copyWith(isLoading: false);
      print("Error loading products: $e");
    }
  }

  Future<void> loadMore({
    required int tabIndex,
    required int mtIdx,
    String searchTxt = '',
    String category = 'all',
    String age = 'all',
    int sort = 2,
  }) async {
    if (state == null || state!.isLoading || !state!.hasMore) return;

    int nextPage = state!.page + 1; // 다음 페이지 설정

    state = state?.copyWith(isLoading: true);

    try {
      // 추가 데이터 로드
      final ResponseDTO responseDTO = await StoreRepository().fetchStoreProducts(
        mtIdx,
        nextPage,
        searchTxt,
        category,
        age,
        sort,
      );

      if (responseDTO.status == 200 && responseDTO.response != null) {
        ProductListDTO newProductListDTO = ProductListDTO.fromJson(responseDTO.response['data']);

        state = state?.copyWith(
          productDetail: [...state!.productDetail!, ...newProductListDTO.list],
          isLoading: false,
          hasMore: newProductListDTO.list.length >= 10, // 데이터가 10개 이상인 경우만 계속 로드 가능
          page: nextPage, // 페이지 번호 증가
        );
      } else {
        throw Exception('Failed to load more products');
      }
    } catch (e) {
      state = state?.copyWith(isLoading: false);
      print("Error loading more products: $e");
    }
  }
}


// ViewModel Provider 정의
final storeCategoryViewModelProvider =
StateNotifierProvider<StoreCategoryViewModel, StoreCategoryModel?>(
        (ref) => StoreCategoryViewModel(ref));
