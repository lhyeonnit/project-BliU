import 'package:BliU/api/default_repository.dart';
import 'package:BliU/const/constant.dart';
import 'package:BliU/dto/default_response_dto.dart';
import 'package:BliU/dto/mypage_info_response_dto.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class JoinAddInfoModel {
}

class JoinAddInfoViewModel extends StateNotifier<JoinAddInfoModel?> {
  final Ref ref;
  final repository = DefaultRepository();

  JoinAddInfoViewModel(super.state, this.ref);

  Future<DefaultResponseDTO> checkId(Map<String, dynamic> requestData) async {
    try {
      final response = await repository.reqPost(url: Constant.apiAuthCheckIdUrl, data: requestData);
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
      if (kDebugMode) {
        print('Error fetching : $e');
      }
      return DefaultResponseDTO(
        result: false,
        message: e.toString(),
      );
    }
  }

  Future<DefaultResponseDTO> reqPhoneAuthCode(Map<String, dynamic> requestData) async {
    try {
      final response = await repository.reqPost(url: Constant.apiAuthSendCodeUrl, data: requestData);
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
      if (kDebugMode) {
        print('Error fetching : $e');
      }
      return DefaultResponseDTO(
          result: false,
          message: e.toString(),
      );
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
      if (kDebugMode) {
        print('Error fetching : $e');
      }
      return DefaultResponseDTO(
        result: false,
        message: e.toString(),
      );
    }
  }


  Future<MyPageInfoResponseDTO> snsAddInfo(Map<String, dynamic> requestData) async {
    try {
      final response = await repository.reqPost(url: Constant.apiAuthJoinUrl, data: requestData);
      if (response != null) {
        if (response.statusCode == 200) {
          Map<String, dynamic> responseData = response.data;
          MyPageInfoResponseDTO myPageInfoResponseDTO = MyPageInfoResponseDTO.fromJson(responseData);
          return myPageInfoResponseDTO;
        }
      }
      return MyPageInfoResponseDTO(
        result: false,
        message: "Network Or Data Error",
        data: null,
      );
    } catch (e) {
      // Catch and log any exceptions
      if (kDebugMode) {
        print('Error fetching : $e');
      }
      return MyPageInfoResponseDTO(
        result: false,
        message: e.toString(),
        data: null,
      );
    }
  }


}

final joinAddInfoModelProvider =
StateNotifierProvider<JoinAddInfoViewModel, JoinAddInfoModel?>((req) {
  return JoinAddInfoViewModel(null, req);
});