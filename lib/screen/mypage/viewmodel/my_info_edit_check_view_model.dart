import 'package:BliU/api/default_repository.dart';
import 'package:BliU/const/constant.dart';
import 'package:BliU/dto/default_response_dto.dart';
import 'package:BliU/dto/mypage_info_response_dto.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class MyInfoEditCheckModel {}

class MyInfoEditCheckViewModel extends StateNotifier<MyInfoEditCheckModel?> {

  final Ref ref;
  final repository = DefaultRepository();

  MyInfoEditCheckViewModel(super.state, this.ref);

  Future<MyPageInfoResponseDTO?> passwordCheck(Map<String, dynamic> requestData) async {
    try {
      final response = await repository.reqPost(url: Constant.apiMyPageCheckMyPageUrl, data: requestData);
      if (response != null) {
        if (response.statusCode == 200) {
          Map<String, dynamic> responseData = response.data;
          MyPageInfoResponseDTO myPageInfoResponseDTO = MyPageInfoResponseDTO.fromJson(responseData);
          return myPageInfoResponseDTO;
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

final myInfoEditCheckViewModelProvider =
StateNotifierProvider<MyInfoEditCheckViewModel, MyInfoEditCheckModel?>((req) {
  return MyInfoEditCheckViewModel(null, req);
});