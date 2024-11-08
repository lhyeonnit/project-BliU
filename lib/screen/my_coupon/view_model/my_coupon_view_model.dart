import 'package:BliU/api/default_repository.dart';
import 'package:BliU/const/constant.dart';
import 'package:BliU/data/coupon_data.dart';
import 'package:BliU/dto/coupon_response_dto.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class MyCouponModel {
  int selectedCategoryIndex = 0;

  List<CouponData> couponList = [];
  int couponCount = 0;

  int page = 1;
  bool hasNextPage = true;
  bool isFirstLoadRunning = false;
  bool isLoadMoreRunning = false;
}

class MyCouponViewModel extends StateNotifier<MyCouponModel> {
  final Ref ref;
  final repository = DefaultRepository();

  MyCouponViewModel(super.state, this.ref);

  void listLoad(Map<String, dynamic> requestData) async {
    state.isFirstLoadRunning = true;
    state.page = 1;
    state.hasNextPage = true;

    requestData.addAll({
      'pg': state.page,
    });

    state.couponCount = 0;
    state.couponList = [];
    ref.notifyListeners();

    final productCouponResponseDTO = await _getList(requestData);
    state.couponCount = productCouponResponseDTO?.count ?? 0;
    state.couponList = productCouponResponseDTO?.list ?? [];

    state.isFirstLoadRunning = false;
    ref.notifyListeners();
  }

  void listNextLoad(Map<String, dynamic> requestData) async {
    if (state.hasNextPage && !state.isFirstLoadRunning && !state.isLoadMoreRunning) {
      state.isLoadMoreRunning = true;
      state.page += 1;

      requestData.addAll({
        'pg': state.page,
      });

      final productCouponResponseDTO = await _getList(requestData);
      if (productCouponResponseDTO != null) {
        if ((productCouponResponseDTO.list ?? []).isNotEmpty) {
          state.couponList.addAll(productCouponResponseDTO.list ?? []);
        } else {
          state.hasNextPage = false;
        }
        ref.notifyListeners();
      }
      state.isLoadMoreRunning = false;
    }
  }

  Future<CouponResponseDTO?> _getList(Map<String, dynamic> requestData) async {
    try {
      final response = await repository.reqPost(url: Constant.apiMyPageCouponUrl, data: requestData);
      if (response != null) {
        if (response.statusCode == 200) {
          Map<String, dynamic> responseData = response.data;
          CouponResponseDTO couponResponseDTO = CouponResponseDTO.fromJson(responseData);
          return couponResponseDTO;
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
}

final myCouponViewModelProvider =
StateNotifierProvider<MyCouponViewModel, MyCouponModel>((req) {
  return MyCouponViewModel(MyCouponModel(), req);
});