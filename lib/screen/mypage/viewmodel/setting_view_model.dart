import 'package:BliU/api/default_repository.dart';
import 'package:BliU/const/constant.dart';
import 'package:BliU/dto/default_response_dto.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class SettingModel {
  String? mtPushing;
  DefaultResponseDTO? pushInfoResponseDTO;
  DefaultResponseDTO? setPushResponseDTO;

  SettingModel({
    required this.mtPushing,
    this.pushInfoResponseDTO,
    this.setPushResponseDTO
  });
}

class SettingViewModel extends StateNotifier<SettingModel?> {
  final Ref ref;
  final repository = DefaultRepository();

  SettingViewModel(super.state, this.ref);

  Future<void> getPushInfo(Map<String, dynamic> requestData) async {
    final response = await repository.reqPost(url: Constant.apiMyPagePushInfoUrl, data: requestData);
    try {
      if (response != null) {
        if (response.statusCode == 200) {
          Map<String, dynamic> responseData = response.data;

          String? message = responseData["data"]["message"];
          if (message == null || message.isEmpty) {
            String mtPushing = (responseData["data"]['mt_pushing']).toString();
            state = SettingModel(mtPushing: mtPushing, pushInfoResponseDTO: null);
          } else {
            DefaultResponseDTO defaultResponseDTO = DefaultResponseDTO(result: false, message: message);
            state = SettingModel(mtPushing: state?.mtPushing, pushInfoResponseDTO: defaultResponseDTO);
          }
          return;
        }
      }
      state = SettingModel(mtPushing: state?.mtPushing, pushInfoResponseDTO: DefaultResponseDTO(result: false, message: "Network Or Data Error"));
    } catch(e) {
      // Catch and log any exceptions
      print('Error request Api: $e');
      state = SettingModel(mtPushing: state?.mtPushing, pushInfoResponseDTO: DefaultResponseDTO(result: false, message: e.toString()));
    }
  }

  Future<void> setPush(Map<String, dynamic> requestData) async {
    final response = await repository.reqPost(url: Constant.apiMyPagePushUrl, data: requestData);
    try {
      if (response != null) {
        if (response.statusCode == 200) {
          Map<String, dynamic> responseData = response.data;
          DefaultResponseDTO defaultResponseDTO = DefaultResponseDTO.fromJson(responseData);
          state = SettingModel(mtPushing: state?.mtPushing, setPushResponseDTO: defaultResponseDTO);
          return;
        }
      }
      state = SettingModel(mtPushing: state?.mtPushing, setPushResponseDTO: DefaultResponseDTO(result: false, message: "Network Or Data Error"));
    } catch(e) {
      // Catch and log any exceptions
      print('Error request Api: $e');
      state = SettingModel(mtPushing: state?.mtPushing, setPushResponseDTO: DefaultResponseDTO(result: false, message: e.toString()));
    }
  }
}

final settingModelProvider =
StateNotifierProvider<SettingViewModel, SettingModel?>((req) {
  return SettingViewModel(null, req);
});