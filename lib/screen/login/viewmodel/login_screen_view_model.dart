import 'package:BliU/api/default_repository.dart';
import 'package:BliU/const/constant.dart';
import 'package:BliU/dto/member_info_response_dto.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class LoginScreenModel {
  final MemberInfoResponseDTO? memberInfoResponseDTO;

  LoginScreenModel({
    required this.memberInfoResponseDTO,
  });
}

class LoginScreenViewModel extends StateNotifier<LoginScreenModel?> {
  final Ref ref;
  final repository = DefaultRepository();

  LoginScreenViewModel(super.state, this.ref);

  void setState(
      MemberInfoResponseDTO? memberInfoResponseDTO,
  ) {
    state = LoginScreenModel(
        memberInfoResponseDTO: memberInfoResponseDTO,
    );
  }
  Future<MemberInfoResponseDTO?> login(Map<String, dynamic> requestData) async {
    final response = await repository.reqPost(url: Constant.apiAuthLoginUrl, data: requestData);
    try {
      if (response != null) {
        if (response.statusCode == 200) {
          Map<String, dynamic> responseData = response.data;
          MemberInfoResponseDTO memberInfoResponseDTO = MemberInfoResponseDTO.fromJson(responseData);
          return memberInfoResponseDTO;
        }
      }
      return null;
    } catch(e) {
      // Catch and log any exceptions
      print('Error request Api: $e');
      return null;
    }
  }

  Future<void> authAutoLogin(Map<String, dynamic> requestData) async {
    final response = await repository.reqPost(url: Constant.apiAuthAutoLoginUrl, data: requestData);
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
      print('Error request Api: $e');
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
      print('Error request Api: $e');
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
StateNotifierProvider<LoginScreenViewModel, LoginScreenModel?>((ref) {
  return LoginScreenViewModel(null, ref);
});