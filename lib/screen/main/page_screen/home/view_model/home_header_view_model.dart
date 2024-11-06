import 'package:BliU/api/default_repository.dart';
import 'package:BliU/const/constant.dart';
import 'package:BliU/dto/banner_list_response_dto.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class HomeHeaderModel {
  BannerListResponseDTO? bannerListResponseDTO;
}

class HomeHeaderViewModel extends StateNotifier<HomeHeaderModel> {
  final Ref ref;
  final repository = DefaultRepository();

  HomeHeaderViewModel(super.state, this.ref);

  void getBanner() async {
    final response = await repository.reqGet(url: Constant.apiMainBannerUrl);
    try {
      if (response != null) {
        if (response.statusCode == 200) {
          Map<String, dynamic> responseData = response.data;
          BannerListResponseDTO bannerListResponseDTO = BannerListResponseDTO.fromJson(responseData);
          state.bannerListResponseDTO = bannerListResponseDTO;
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
}

// ViewModel Provider 정의
final homeHeaderViewModelProvider =
StateNotifierProvider<HomeHeaderViewModel, HomeHeaderModel>((ref) {
  return HomeHeaderViewModel(HomeHeaderModel(), ref);
});