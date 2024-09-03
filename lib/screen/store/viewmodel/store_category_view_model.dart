import 'package:BliU/api/default_repository.dart';
import 'package:BliU/const/constant.dart';
import 'package:BliU/data/product_data.dart';
import 'package:BliU/dto/store_response_dto.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

// 모델 클래스 정의 (데이터 상태를 관리하기 위한 DTO)
class StoreCategoryModel {
  final StoreResponseDTO? storeResponseDTO;
  final int? count;
  final List<ProductData>? productList;

  StoreCategoryModel({
    required this.storeResponseDTO,
    required this.count,
    required this.productList,
  });

  // copyWith 메서드를 통해 상태 복사 및 수정
  StoreCategoryModel copyWith({
    StoreResponseDTO? storeResponseDTO,
    int? count,
    List<ProductData>? productList,
  }) {
    return StoreCategoryModel(
      storeResponseDTO: storeResponseDTO ?? this.storeResponseDTO,
      count: this.count ?? 0,
      productList: this.productList ?? [],
    );
  }
}

// ViewModel 정의
class StoreCategoryViewModel extends StateNotifier<StoreCategoryModel?> {
  final Ref ref;
  final repository = DefaultRepository();

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
      storeResponseDTO: null,
      count: null,
      productList: [],
    );
    Map<String, dynamic> requestData = {
      'mt_idx': mtIdx.toString(),
      'pg': pg.toString(),
      'search_txt': searchTxt,
      'category': category,
      'age': age,
      'sort': sort.toString(),
    };
    try {
      final response = await repository.reqPost(
          url: Constant.apiStoreProductsUrl, data: requestData);
      if (response != null) {
        if (response.statusCode == 200) {

          if (requestData is List) {
            // 응답이 List 타입인 경우, List<ProductDTO>로 처리
            List<ProductData> productList = (requestData as List)
                .map((item) => ProductData.fromJson(item as Map<String, dynamic>))
                .toList();

            state = state?.copyWith(productList: productList);
          } else if (requestData is Map<String, dynamic>) {
            // 응답이 Map<String, dynamic>인 경우 처리
            // final Map<String, dynamic> storeFavoriteProductListJson = requestData;
            //
            // if (storeFavoriteProductListJson.containsKey('data') &&
            //     storeFavoriteProductListJson['data'].containsKey('list')) {
            //   final List<dynamic> listJson =
            //   storeFavoriteProductListJson['data']['list'];
            //   StoreFavoriteProductResponseDTO storeFavoriteProductResponseDTO =
            //   StoreFavoriteProductResponseDTO.fromJson(requestData);
            //   // ProductDTO 리스트로 변환
            //   List<ProductDTO> storeFavoriteProductList = listJson.map((item) {
            //     return ProductDTO.fromJson(item as Map<String, dynamic>);
            //   }).toList();
            //
            //   state = state?.copyWith(
            //       storeFavoriteProductResponseDTO:
            //       storeFavoriteProductResponseDTO,
            //       productDetail: storeFavoriteProductList);
            // } else {
            //   throw Exception('Failed to load products');
            // }
          }
        }
      } else {

      }
    } catch (e) {
      print("Error loading products: $e");
    }
  }

// // 연령대 선택 BottomSheet 호출 및 상태 업데이트
// void showAgeGroupSelection(BuildContext context) {
//   showModalBottomSheet(
//     context: context,
//     backgroundColor: Colors.white,
//     builder: (BuildContext context) {
//       return StoreAgeGroupSelection(
//         selectedAgeGroups: state?.selectedAgeGroups ?? [],
//         onSelectionChanged: (List<String> newSelection) {
//           state = state?.copyWith(selectedAgeGroups: newSelection);
//         },
//       );
//     },
//   );
// }
//
// // 선택된 연령대 텍스트 반환
// String getSelectedAgeGroupsText() {
//   if (state?.selectedAgeGroups.isEmpty ?? true) {
//     return '연령';
//   } else {
//     return state?.selectedAgeGroups.join(', ') ?? '연령';
//   }
// }
}

// ViewModel Provider 정의
final storeCategoryViewModelProvider =
    StateNotifierProvider<StoreCategoryViewModel, StoreCategoryModel?>((ref) {
  return StoreCategoryViewModel(null, ref);
});
