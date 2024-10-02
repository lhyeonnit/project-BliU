import 'package:BliU/api/default_repository.dart';
import 'package:BliU/const/constant.dart';
import 'package:BliU/data/product_data.dart';
import 'package:BliU/dto/category_response_dto.dart';
import 'package:BliU/dto/product_list_response_dto.dart';
import 'package:BliU/dto/store_response_dto.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class StoreProductModel {
  StoreResponseDTO? storeResponseDTO;
  StoreProductModel({
    this.storeResponseDTO,
  });
}

class StoreProductViewModel extends StateNotifier<StoreProductModel?> {
  final Ref ref;
  final repository = DefaultRepository();

  StoreProductViewModel(super.state, this.ref);

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
      print('Error request Api: $e');
      return null;
    }
  }
  Future<StoreResponseDTO?> getStoreList(Map<String, dynamic> requestData) async {
    try {
      final response = await repository.reqPost(url: Constant.apiStoreUrl, data: requestData);
      if (response != null) {
        if (response.statusCode == 200) {
          Map<String, dynamic> responseData = response.data;
          StoreResponseDTO storeResponseDTO = StoreResponseDTO.fromJson(responseData);
          var list = state?.storeResponseDTO?.data.list ?? [];
          List<ProductData> productList = storeResponseDTO.data.list ?? [];
          for (var item in  productList) {
            list.add(item);
          }
          storeResponseDTO.data.list = productList;

          state = StoreProductModel(storeResponseDTO: storeResponseDTO);
          return storeResponseDTO;
        }
      }
      return null;
    } catch (e) {
      // Catch and log any exceptions
      print('Error fetching : $e');
      return null;
    }
  }
}

final StoreProductViewModelProvider =
StateNotifierProvider<StoreProductViewModel, StoreProductModel?>((req) {
  return StoreProductViewModel(null, req);
});