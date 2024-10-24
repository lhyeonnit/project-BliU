import 'package:BliU/api/default_repository.dart';
import 'package:BliU/const/constant.dart';
import 'package:BliU/dto/banner_list_response_dto.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class HomeHeaderModel {
}

class HomeHeaderViewModel extends StateNotifier<HomeHeaderModel?> {
  final Ref ref;
  final repository = DefaultRepository();

  HomeHeaderViewModel(super.state, this.ref);

  Future<BannerListResponseDTO?> getBanner() async {
    final response = await repository.reqGet(url: Constant.apiMainBannerUrl);
    try {
      if (response != null) {
        if (response.statusCode == 200) {
          Map<String, dynamic> responseData = response.data;
          BannerListResponseDTO bannerListResponseDTO = BannerListResponseDTO.fromJson(responseData);
          return bannerListResponseDTO;
        }
      }
      return null;
    } catch(e) {
      // Catch and log any exceptions
      if (kDebugMode) {
        print('Error request Api: $e');
      }
      return null;
    }
  }
}

// ViewModel Provider 정의
final homeHeaderViewModelProvider =
StateNotifierProvider<HomeHeaderViewModel, HomeHeaderModel?>((ref) {
  return HomeHeaderViewModel(null, ref);
});