import 'package:BliU/api/default_repository.dart';
import 'package:BliU/const/constant.dart';
import 'package:BliU/data/store_rank_data.dart';
import 'package:BliU/dto/category_response_dto.dart';
import 'package:BliU/dto/store_rank_response_dto.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class RankingModel {
  StoreRankResponseDTO? storeRankResponseDTO;

  RankingModel({
    this.storeRankResponseDTO,
  });
}

class RankingViewModel extends StateNotifier<RankingModel?> {
  final Ref ref;
  final repository = DefaultRepository();

  RankingViewModel(super.state, this.ref);

  Future<void> getRank(Map<String, dynamic> requestData) async {
    try {
      final response = await repository.reqPost(url: Constant.apiStoreRankUrl, data: requestData);
      if (response != null) {
        if (response.statusCode == 200) {
          Map<String, dynamic> responseData = response.data;
          StoreRankResponseDTO storeRankResponseDTO = StoreRankResponseDTO.fromJson(responseData);

          List<StoreRankData> list = storeRankResponseDTO.list ?? [];

          storeRankResponseDTO.list = list;

          state = RankingModel(storeRankResponseDTO: storeRankResponseDTO);
          return;
        }
      }
      state = state;
    } catch (e) {
      // Catch and log any exceptions
      print('Error fetching : $e');
      state = state;
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
      print('Error request Api: $e');
      return null;
    }
  }
}

final storeLankListViewModelProvider =
StateNotifierProvider<RankingViewModel, RankingModel?>((req) {
  return RankingViewModel(null, req);
});