import 'package:BliU/api/default_repository.dart';
import 'package:BliU/const/constant.dart';
import 'package:BliU/dto/default_response_dto.dart';
import 'package:BliU/dto/find_id_pwd_response_dto.dart';
import 'package:BliU/dto/find_id_response_dto.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class FindPasswordScreenModel {
}

class FindPasswordScreenViewModel extends StateNotifier<FindPasswordScreenModel?> {
  final Ref ref;
  final repository = DefaultRepository();

  FindPasswordScreenViewModel(super.state, this.ref);

  Future<FindIdPwdResponseDTO?> findPassword(Map<String, dynamic> requestData) async {
    try {
      final response = await repository.reqPost(url: Constant.apiAuthFindPwdUrl, data: requestData);
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
      print('Error fetching : $e');
      return null;
    }
  }

  Future<DefaultResponseDTO?> reqPhoneAuthCode(Map<String, dynamic> requestData) async {
    try {
      final response = await repository.reqPost(url: Constant.apiAuthSendCodeUrl, data: requestData);
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

  Future<DefaultResponseDTO> checkCode(Map<String, dynamic> requestData) async {
    try {
      final response = await repository.reqPost(url: Constant.apiAuthCheckCodeUrl, data: requestData);
      if (response != null) {
        if (response.statusCode == 200) {
          Map<String, dynamic> responseData = response.data;
          DefaultResponseDTO defaultResponseDTO = DefaultResponseDTO.fromJson(responseData);
          return defaultResponseDTO;
        }
      }
      return DefaultResponseDTO(
        result: false,
        message: "Network Or Data Error",
      );
    } catch (e) {
      // Catch and log any exceptions
      print('Error fetching : $e');
      return DefaultResponseDTO(
        result: false,
        message: e.toString(),
      );
    }
  }
}

// ViewModel Provider 정의
final findPasswordScreenModelProvider =
StateNotifierProvider<FindPasswordScreenViewModel, FindPasswordScreenModel?>((ref) {
  return FindPasswordScreenViewModel(null, ref);
});