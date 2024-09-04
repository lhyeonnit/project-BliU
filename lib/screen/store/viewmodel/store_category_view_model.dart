import 'package:BliU/api/default_repository.dart';
import 'package:BliU/const/constant.dart';
import 'package:BliU/data/product_data.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

// 모델 클래스 정의 (데이터 상태를 관리하기 위한 DTO)
class StoreCategoryModel {
  List<ProductData>? productList;

  StoreCategoryModel({
    required this.productList,
  });

  // copyWith 메서드를 통해 상태 복사 및 수정
  // StoreCategoryModel copyWith({
  //   List<ProductData>? productList,
  // }) {
  //   return StoreCategoryModel(
  //     productList: this.productList ?? [],
  //   );
  // }
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
          final Map<String, dynamic> categoryListJson = response.data;
          final List<dynamic> listJson = categoryListJson['data']['list'];
          List<ProductData> productList = listJson.map((item) {
            return ProductData.fromJson(item as Map<String, dynamic>);
          }).toList();

          var dataList = state?.productList ?? [];
          if (productList.isNotEmpty) {
            for (var e in productList) {
              dataList.add(e);
            }
          }
          state = StoreCategoryModel(productList: dataList);
        }
      } else {
        state = StoreCategoryModel(productList: state?.productList);
      }
    } catch (e) {
      print("Error loading products: $e");
      state = StoreCategoryModel(productList: state?.productList);
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
