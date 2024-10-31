import 'package:BliU/api/default_repository.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class CancelDetailModel {
}

class CancelDetailViewModel extends StateNotifier<CancelDetailModel?> {
  final Ref ref;
  final repository = DefaultRepository();

  CancelDetailViewModel(super.state, this.ref);

  // Future<CancelDetailDTO?> getCancelDetail(Map<String, dynamic> requestData) async {
  //   try {
  //     final response = await repository.reqPost(url: Constant.apiMyPageOrderCancelDetailUrl, data: requestData);
  //     if (response != null) {
  //       if (response.statusCode == 200) {
  //         Map<String, dynamic> responseData = response.data;
  //         CancelDetailDTO cancelDetailDTO = CancelDetailDTO.fromJson(responseData);
  //
  //         return cancelDetailDTO;
  //       }
  //     }
  //     return null;
  //   } catch (e) {
  //     // Catch and log any exceptions
  //     if (kDebugMode) {
  //       print('Error fetching : $e');
  //     }
  //     return null;
  //   }
  // }
}

final cancelDetailViewModelProvider =
StateNotifierProvider<CancelDetailViewModel, CancelDetailModel?>((req) {
  return CancelDetailViewModel(null, req);
});