import 'package:BliU/api/default_repository.dart';
import 'package:BliU/const/constant.dart';
import 'package:BliU/dto/product_list_response_dto.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class HomeBodyBestSalesModel {
}

class HomeBodyBestSalesViewModel extends StateNotifier<HomeBodyBestSalesModel?> {
  final Ref ref;
  final repository = DefaultRepository();

  HomeBodyBestSalesViewModel(super.state, this.ref);

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
      print('Error fetching : $e');
      return null;
    }
  }
}

// ViewModel Provider 정의
final homeBodyBestSalesViewModelProvider =
StateNotifierProvider<HomeBodyBestSalesViewModel, HomeBodyBestSalesModel?>((ref) {
  return HomeBodyBestSalesViewModel(null, ref);
});