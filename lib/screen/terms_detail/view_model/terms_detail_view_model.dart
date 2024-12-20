import 'package:BliU/api/default_repository.dart';
import 'package:BliU/const/constant.dart';
import 'package:BliU/dto/default_response_dto.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class TermsDetailModel {
}

class TermsDetailViewModel extends StateNotifier<TermsDetailModel?> {
  final Ref ref;
  final repository = DefaultRepository();

  TermsDetailViewModel(super.state, this.ref);

  Future<DefaultResponseDTO?> getTermsAndPrivacy(int type) async {
    // type 0 - 이용약관 1 - 개인정보 처리 방침 2 - 개인정보 수집 이용 동의 3 - 개인정보 제 3자 정보 제공 동의 4 - 결제대행 서비스 이용약관 동의
    String url = Constant.apiMyPageTermsUrl;
    String key = "terms";

    switch(type) {
      case 0:
        url = Constant.apiMyPageTermsUrl;
        key = "terms";
        break;
      case 1:
        url = Constant.apiMyPagePrivacyUrl;
        key = "privacy";
        break;
      case 2:
        url = Constant.apiMyPageCollectionUrl;
        key = "collection";
        break;
      case 3:
        url = Constant.apiMyPageInformationUrl;
        key = "information";
        break;
      case 4:
        url = Constant.apiMyPageServiceUrl;
        key = "service";
        break;
    }

    final response = await repository.reqGet(url: url);
    try {
      if (response != null) {
        if (response.statusCode == 200) {
          Map<String, dynamic> responseData = response.data;

          String? message = responseData["data"]["message"];
          if (message == null || message.isEmpty) {
            String content = (responseData["data"][key]).toString();
            DefaultResponseDTO defaultResponseDTO = DefaultResponseDTO(result: true, message: content);
            return defaultResponseDTO;
          } else {
            DefaultResponseDTO defaultResponseDTO = DefaultResponseDTO(result: false, message: message);
            return defaultResponseDTO;
          }
        }
      }
      return DefaultResponseDTO(result: false, message: "Network Or Data Error");
    } catch(e) {
      // Catch and log any exceptions
      if (kDebugMode) {
        print('Error request Api: $e');
      }
      return DefaultResponseDTO(result: false, message: e.toString());
    }
  }
}

final termsDetailViewModelProvider =
StateNotifierProvider<TermsDetailViewModel, TermsDetailModel?>((ref) {
  return TermsDetailViewModel(null, ref);
});