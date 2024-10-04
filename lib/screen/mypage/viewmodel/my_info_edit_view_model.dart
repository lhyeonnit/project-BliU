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

  Future<DefaultResponseDTO> editMyInfo(Map<String, dynamic> requestData) async {
    try {
      final response = await repository.reqPost(url: Constant.apiMyPageSaveUrl, data: requestData);
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

  Future<DefaultResponseDTO?> editMyName(Map<String, dynamic> requestData) async {
    try {
      final response = await repository.reqPost(url: Constant.apiMyPageChangeNameUrl, data: requestData);
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

  Future<DefaultResponseDTO?> editMyPh(Map<String, dynamic> requestData) async {
    try {
      final response = await repository.reqPost(url: Constant.apiMyPageChangeHpUrl, data: requestData);
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

  Future<DefaultResponseDTO?> editMyPassword(Map<String, dynamic> requestData) async {
    try {
      final response = await repository.reqPost(url: Constant.apiAuthChangePwdUrl, data: requestData);
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
  Future<DefaultResponseDTO> retire(Map<String, dynamic> requestData) async {
    try {
      final response = await repository.reqPost(url: Constant.apiMyPageRetireUrl, data: requestData);
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

final myInfoEditViewModelProvider =
    StateNotifierProvider<MyInfoEditViewModel, MyInfoEditModel?>((req) {
  return MyInfoEditViewModel(null, req);
});
