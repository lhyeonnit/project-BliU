import 'package:BliU/api/default_repository.dart';
import 'package:BliU/const/constant.dart';
import 'package:BliU/dto/find_id_pwd_response_dto.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class NewPasswordModel {
}

class NewPasswordViewModel extends StateNotifier<NewPasswordModel?> {
  final Ref ref;
  final repository = DefaultRepository();

  NewPasswordViewModel(super.state, this.ref);

  Future<FindIdPwdResponseDTO?> changePassword(Map<String, dynamic> requestData) async {
    try {
      final response = await repository.reqPost(url: Constant.apiAuthChangePwdUrl, data: requestData);
      if (response != null) {
        if (response.statusCode == 200) {
          Map<String, dynamic> responseData = response.data;
          FindIdPwdResponseDTO findIdPwdResponseDTO = FindIdPwdResponseDTO.fromJson(responseData);
          return findIdPwdResponseDTO;
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

// ViewModel Provider 정의
final newPasswordViewModelProvider =
StateNotifierProvider<NewPasswordViewModel, NewPasswordModel?>((ref) {
  return NewPasswordViewModel(null, ref);
});