import 'package:BliU/api/default_repository.dart';
import 'package:BliU/const/constant.dart';
import 'package:BliU/dto/member_info_response_dto.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class LoginModel {
  final MemberInfoResponseDTO? memberInfoResponseDTO;

  LoginModel({
    required this.memberInfoResponseDTO,
  });
}

class LoginViewModel extends StateNotifier<LoginModel?> {
  final Ref ref;
  final repository = DefaultRepository();

  LoginViewModel(super.state, this.ref);

  void setState(MemberInfoResponseDTO? memberInfoResponseDTO) {
    state = LoginModel(memberInfoResponseDTO: memberInfoResponseDTO);
  }
  Future<void> login(Map<String, dynamic> requestData) async {
    final response = await repository.reqPost(url: Constant.apiAuthLoginUrl, data: requestData);
    try {
      if (response != null) {
        if (response.statusCode == 200) {
          Map<String, dynamic> responseData = response.data;
          MemberInfoResponseDTO memberInfoResponseDTO = MemberInfoResponseDTO.fromJson(responseData);
          setState(memberInfoResponseDTO);
          return;
        }
      }
      setState(
        MemberInfoResponseDTO(
          result: false,
          message: "Network Or Data Error"
        )
      );
    } catch(e) {
      // Catch and log any exceptions
      if (kDebugMode) {
        print('Error request Api: $e');
      }
      setState(
        MemberInfoResponseDTO(
          result: false,
          message: e.toString()
        )
      );
    }
  }

  Future<void> authSnsLogin(Map<String, dynamic> requestData) async {
    final response = await repository.reqPost(url: Constant.apiAuthSnsLoginUrl, data: requestData);
    try {
      if (response != null) {
        if (response.statusCode == 200) {
          Map<String, dynamic> responseData = response.data;
          MemberInfoResponseDTO memberInfoResponseDTO = MemberInfoResponseDTO.fromJson(responseData);
          setState(memberInfoResponseDTO);
          return;
        }
      }
      setState(
          MemberInfoResponseDTO(
              result: false,
              message: "Network Or Data Error"
          )
      );
    } catch(e) {
      // Catch and log any exceptions
      if (kDebugMode) {
        print('Error request Api: $e');
      }
      setState(
          MemberInfoResponseDTO(
              result: false,
              message: e.toString()
          )
      );
    }
  }
}

// ViewModel Provider 정의
final loginViewModelProvider =
StateNotifierProvider<LoginViewModel, LoginModel?>((ref) {
  return LoginViewModel(null, ref);
});