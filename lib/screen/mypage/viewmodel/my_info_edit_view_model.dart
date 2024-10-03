import 'package:BliU/api/default_repository.dart';
import 'package:BliU/const/constant.dart';
import 'package:BliU/dto/default_response_dto.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class MyInfoEditModel {}

class MyInfoEditViewModel extends StateNotifier<MyInfoEditModel?> {

  final Ref ref;
  final repository = DefaultRepository();

  MyInfoEditViewModel(super.state, this.ref);

  Future<DefaultResponseDTO?> getMyInfo(Map<String, dynamic> requestData) async {
    try {
      final response = await repository.reqPost(url: Constant.apiMyPageInfoUrl, data: requestData);
      if (response != null) {
        if (response.statusCode == 200) {
          Map<String, dynamic> responseData = response.data;
          DefaultResponseDTO defaultResponseDTO = DefaultResponseDTO.fromJson(responseData);
          return defaultResponseDTO;
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

final myInfoEditViewModelProvider =
StateNotifierProvider<MyInfoEditViewModel, MyInfoEditModel?>((req) {
  return MyInfoEditViewModel(null, req);
});