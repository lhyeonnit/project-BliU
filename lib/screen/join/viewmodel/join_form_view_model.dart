import 'package:BliU/api/default_repository.dart';
import 'package:BliU/const/constant.dart';
import 'package:BliU/dto/default_response_dto.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class JoinFormModel {
}

class JoinFormViewModel extends StateNotifier<JoinFormModel?> {
  final Ref ref;
  final repository = DefaultRepository();

  JoinFormViewModel(super.state, this.ref);

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
      print('Error fetching : $e');
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
      print('Error fetching : $e');
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
      print('Error fetching : $e');
      return DefaultResponseDTO(
        result: false,
        message: e.toString(),
      );
    }
  }


  Future<DefaultResponseDTO> join(Map<String, dynamic> requestData) async {
    try {
      final response = await repository.reqPost(url: Constant.apiAuthJoinUrl, data: requestData);
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

final joinFormModelProvider =
StateNotifierProvider<JoinFormViewModel, JoinFormModel?>((req) {
  return JoinFormViewModel(null, req);
});