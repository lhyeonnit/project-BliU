import 'package:BliU/api/default_repository.dart';
import 'package:BliU/const/constant.dart';
import 'package:BliU/dto/point_list_response_dto.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class MyPointModel {}

class MyPointViewModel extends StateNotifier<MyPointModel?> {
  final Ref ref;
  final repository = DefaultRepository();

  MyPointViewModel(super.state, this.ref);

  Future<PointListResponseDTO?> getList(Map<String, dynamic> requestData) async {
    try {
      final response = await repository.reqPost(url: Constant.apiMyPagePointUrl, data: requestData);
      if (response != null) {
        if (response.statusCode == 200) {
          Map<String, dynamic> responseData = response.data;
          PointListResponseDTO pointListResponseDTO = PointListResponseDTO.fromJson(responseData);
          return pointListResponseDTO;
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

final myPointViewModelProvider =
StateNotifierProvider<MyPointViewModel, MyPointModel?>((req) {
  return MyPointViewModel(null, req);
});