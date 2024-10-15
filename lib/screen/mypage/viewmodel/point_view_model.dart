import 'package:BliU/api/default_repository.dart';
import 'package:BliU/const/constant.dart';
import 'package:BliU/dto/point_list_response_dto.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class PointModel {}

class PointViewModel extends StateNotifier<PointModel?> {
  final Ref ref;
  final repository = DefaultRepository();

  PointViewModel(super.state, this.ref);

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
      print('Error fetching : $e');
      return null;
    }
  }
}

final pointViewModelProvider =
StateNotifierProvider<PointViewModel, PointModel?>((req) {
  return PointViewModel(null, req);
});