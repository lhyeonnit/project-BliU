import 'package:BliU/api/default_repository.dart';
import 'package:BliU/const/constant.dart';
import 'package:BliU/dto/store_download_response_dto.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class StoreInfoModel {
  StoreDownloadResponseDTO? storeDownloadResponseDTO;

  StoreInfoModel({
    this.storeDownloadResponseDTO,
  });
}

class StoreInfoViewModel extends StateNotifier<StoreInfoModel?> {
  final Ref ref;
  final repository = DefaultRepository();

  StoreInfoViewModel(super.state, this.ref);

  Future<void> downStoreCoupon(Map<String, dynamic> requestData) async {
    try {
      final response = await repository.reqPost(url: Constant.apiStoreCouponUrl, data: requestData);
      if (response != null) {
        if (response.statusCode == 200) {
          Map<String, dynamic> responseData = response.data;
          StoreDownloadResponseDTO storeDownloadResponseDTO = StoreDownloadResponseDTO.fromJson(responseData);
          state = StoreInfoModel(storeDownloadResponseDTO: storeDownloadResponseDTO);
          return;
        }
      }
      state = state;
    } catch (e) {
      // Catch and log any exceptions
      if (kDebugMode) {
        print('Error fetching : $e');
      }
      state = state;
    }
  }

  Future<Map<String, dynamic>?> toggleLike(Map<String, dynamic> requestData) async {
    try {
      final response = await repository.reqPost(url: Constant.apiStoreLikeUrl, data: requestData,);

      if (response != null && response.statusCode == 200) {
        Map<String, dynamic> responseData = response.data;
        return responseData;
      }
      return null;
    } catch (e) {
      if (kDebugMode) {
        print('Error toggling like: $e');
      }
      return null;
    }
  }
}


final storeInfoViewModelProvider =
StateNotifierProvider<StoreInfoViewModel, StoreInfoModel?>((req) {
  return StoreInfoViewModel(null, req);
});