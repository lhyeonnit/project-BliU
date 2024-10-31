import 'package:BliU/api/default_repository.dart';
import 'package:BliU/const/constant.dart';
import 'package:BliU/dto/change_order_detail_dto.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class ChangeOrderDetailModel {
}

class ChangeOrderDetailViewModel extends StateNotifier<ChangeOrderDetailModel?> {
  final Ref ref;
  final repository = DefaultRepository();

  ChangeOrderDetailViewModel(super.state, this.ref);

  Future<ChangeOrderDetailDTO?> getCancelDetail(Map<String, dynamic> requestData) async {
    try {
      final response = await repository.reqPost(url: Constant.apiMyPageOrderCancelDetailUrl, data: requestData);
      if (response != null) {
        if (response.statusCode == 200) {
          Map<String, dynamic> responseData = response.data;
          ChangeOrderDetailDTO changeOrderDetailDTO = ChangeOrderDetailDTO.fromJson(responseData);

          return changeOrderDetailDTO;
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

  Future<ChangeOrderDetailDTO?> getReturnDetail(Map<String, dynamic> requestData) async {
    try {
      final response = await repository.reqPost(url: Constant.apiMyPageOrderReturnDetailUrl, data: requestData);
      if (response != null) {
        if (response.statusCode == 200) {
          Map<String, dynamic> responseData = response.data;
          ChangeOrderDetailDTO changeOrderDetailDTO = ChangeOrderDetailDTO.fromJson(responseData);

          return changeOrderDetailDTO;
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
}

final changeOrderDetailViewModelProvider =
StateNotifierProvider<ChangeOrderDetailViewModel, ChangeOrderDetailModel?>((req) {
  return ChangeOrderDetailViewModel(null, req);
});