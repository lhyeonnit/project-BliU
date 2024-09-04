import 'package:BliU/api/default_repository.dart';
import 'package:BliU/const/constant.dart';
import 'package:BliU/dto/member_info_response_dto.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class LoginScreenModel {
  MemberInfoResponseDTO? memberInfoResponseDTO;

  LoginScreenModel({
    required this.memberInfoResponseDTO,
  });
}

class LoginScreenViewModel extends StateNotifier<LoginScreenModel?> {
  final Ref ref;
  final repository = DefaultRepository();

  LoginScreenViewModel(super.state, this.ref);

  Future<void> authLogin(Map<String, dynamic> requestData) async {
    final response = await repository.reqPost(url: Constant.apiAuthLoginUrl, data: requestData);
    try {
      if (response != null) {
        if (response.statusCode == 200) {
          Map<String, dynamic> responseData = response.data;
          MemberInfoResponseDTO memberInfoResponseDTO = MemberInfoResponseDTO.fromJson(responseData);
          state = LoginScreenModel(memberInfoResponseDTO: memberInfoResponseDTO);
          return;
        }
      }
      state = null;
    } catch(e) {
      // Catch and log any exceptions
      print('Error request Api: $e');
      state = null;
    }
  }
}

// ViewModel Provider 정의
final loginViewModelProvider =
StateNotifierProvider<LoginScreenViewModel, LoginScreenModel?>((ref) {
  return LoginScreenViewModel(null, ref);
});