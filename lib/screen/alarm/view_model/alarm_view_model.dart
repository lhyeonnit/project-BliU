import 'package:BliU/api/default_repository.dart';
import 'package:BliU/const/constant.dart';
import 'package:BliU/dto/push_response_dto.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class AlarmModel {}

class AlarmViewModel extends StateNotifier<AlarmModel?> {
  final Ref ref;
  final repository = DefaultRepository();

  AlarmViewModel(super.state, this.ref);


  Future<PushResponseDTO?> getList(Map<String, dynamic> requestData) async {
    try {
      final response = await repository.reqPost(url: Constant.apiMainPushListUrl, data: requestData);
      if (response != null) {
        if (response.statusCode == 200) {
          Map<String, dynamic> responseData = response.data;
          return PushResponseDTO.fromJson(responseData);
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

final alarmViewModelProvider =
StateNotifierProvider<AlarmViewModel, AlarmModel?>((req) {
  return AlarmViewModel(null, req);
});