import 'package:BliU/api/default_repository.dart';
import 'package:BliU/const/constant.dart';
import 'package:BliU/dto/store_download_response_dto.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class CouponDownloadModel {
  StoreDownloadResponseDTO? storeDownloadResponseDTO;

  CouponDownloadModel({
    this.storeDownloadResponseDTO,
  });
}

class CouponDownloadViewModel extends StateNotifier<CouponDownloadModel?> {
  final Ref ref;
  final repository = DefaultRepository();

  CouponDownloadViewModel(super.state, this.ref);

  Future<void> getList(Map<String, dynamic> requestData) async {
    try {
      final response = await repository.reqPost(url: Constant.apiStoreCouponUrl, data: requestData);
      if (response != null) {
        if (response.statusCode == 200) {
          Map<String, dynamic> responseData = response.data;
          StoreDownloadResponseDTO storeDownloadResponseDTO = StoreDownloadResponseDTO.fromJson(responseData);
          state = CouponDownloadModel(storeDownloadResponseDTO: storeDownloadResponseDTO);
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
}


final couponDownloadModelProvider =
StateNotifierProvider<CouponDownloadViewModel, CouponDownloadModel?>((req) {
  return CouponDownloadViewModel(null, req);
});