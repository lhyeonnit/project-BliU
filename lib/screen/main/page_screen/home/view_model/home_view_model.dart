import 'package:BliU/api/default_repository.dart';
import 'package:BliU/const/constant.dart';
import 'package:BliU/data/category_data.dart';
import 'package:BliU/data/product_data.dart';
import 'package:BliU/dto/category_response_dto.dart';
import 'package:BliU/dto/product_list_response_dto.dart';
import 'package:BliU/utils/shared_preferences_manager.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class HomeModel {
  String cartCount = "0";
  List<CategoryData> categories = [];
  List<CategoryData> ageCategories = [];

  int selectedCategoryIndex = 0;
  List<CategoryData> productCategories = [
    CategoryData(ctIdx: 0, cstIdx: 0, img: '', ctName: '전체', catIdx: 0, catName: '', subList: [])
  ];

  CategoryData? selectedAgeGroup;

  int page = 1;
  bool hasNextPage = true;
  bool isFirstLoadRunning = false;
  bool isLoadMoreRunning = false;

  List<ProductData> productList = [];

}

class HomeViewModel extends StateNotifier<HomeModel> {
  final Ref ref;
  final repository = DefaultRepository();

  HomeViewModel(super.state, this.ref);

  void getCategory(Map<String, dynamic> requestData) async {

    final response = await repository.reqPost(url: Constant.apiMainCategoryUrl, data: requestData);
    try {
      if (response != null) {
        if (response.statusCode == 200) {
          Map<String, dynamic> responseData = response.data;
          CategoryResponseDTO categoryResponseDTO = CategoryResponseDTO.fromJson(responseData);
          state.categories = categoryResponseDTO.list ?? [];
          state.productCategories.addAll(state.categories);
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

  void getAgeCategory() async {
    final response = await repository.reqGet(url: Constant.apiCategoryAgeUrl);
    try {
      if (response != null) {
        if (response.statusCode == 200) {
          Map<String, dynamic> responseData = response.data;
          CategoryResponseDTO categoryResponseDTO = CategoryResponseDTO.fromJson(responseData);
          state.ageCategories = categoryResponseDTO.list ?? [];
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

  void getCartCount(Map<String, dynamic> requestData) async {
    final response = await repository.reqPost(url: Constant.apiCartCountUrl, data: requestData);
    try {
      if (response != null) {
        if (response.statusCode == 200) {
          Map<String, dynamic> responseData = response.data;
          int cartCount = responseData['data']['count'];
          state.cartCount = cartCount.toString();
          ref.notifyListeners();
        }
      }
    } catch(e) {
      // Catch and log any exceptions
      if (kDebugMode) {
        print("Error request Api: $e");
      }
    }
  }

  void listLoad() async {
    state.isFirstLoadRunning = true;
    state.page = 1;
    state.hasNextPage = true;

    final requestData = await _makeRequestData();
    state.productList = [];
    ref.notifyListeners();

    final productListResponseDTO = await ref.read(homeViewModelProvider.notifier).getList(requestData);
    state.productList = productListResponseDTO?.list ?? [];

    state.isFirstLoadRunning = false;
    ref.notifyListeners();
  }

  void listNextLoad() async {
    if (state.hasNextPage && !state.isFirstLoadRunning && !state.isLoadMoreRunning){
      state.isLoadMoreRunning = true;
      state.page += 1;

      final requestData = await _makeRequestData();

      final productListResponseDTO = await ref.read(homeViewModelProvider.notifier).getList(requestData);
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

  Future<Map<String, dynamic>> _makeRequestData() async {
    final pref = await SharedPreferencesManager.getInstance();
    final mtIdx = pref.getMtIdx();

    final category = state.productCategories[state.selectedCategoryIndex];

    String categoryStr = "all";
    if (state.selectedCategoryIndex > 0) {
      categoryStr = category.ctIdx.toString();
    }

    String ageStr = "all";
    if (state.selectedAgeGroup != null) {
      ageStr = (state.selectedAgeGroup?.catIdx ?? 0).toString();
    }

    Map<String, dynamic> requestData = {
      'mt_idx' : mtIdx ?? "",
      'category' : categoryStr,
      'age' : ageStr,
      'pg': state.page,
    };

    return requestData;
  }

  Future<ProductListResponseDTO?> getList(Map<String, dynamic> requestData) async {
    try {
      final response = await repository.reqPost(url: Constant.apiMainSellRankUrl, data: requestData);
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

  void setSelectedCategoryIndex(int index) {
    state.selectedCategoryIndex = index;
    ref.notifyListeners();
  }

  void setSelectedAgeGroup(CategoryData? category) {
    state.selectedAgeGroup = category;
    ref.notifyListeners();
  }

  String getSelectedAgeGroupText() {
    if (state.selectedAgeGroup == null) {
      return '연령';
    } else {
      return state.selectedAgeGroup?.catName ?? "";
    }
  }
}

// ViewModel Provider 정의
final homeViewModelProvider =
StateNotifierProvider<HomeViewModel, HomeModel>((ref) {
  return HomeViewModel(HomeModel(), ref);
});