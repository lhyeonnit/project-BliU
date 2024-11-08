import 'package:BliU/api/default_repository.dart';
import 'package:BliU/const/constant.dart';
import 'package:BliU/dto/event_detail_response_dto.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class EventDetailModel {
  EventDetailResponseDTO? eventDetailResponseDTO;
}

class EventDetailViewModel extends StateNotifier<EventDetailModel> {
  final Ref ref;
  final repository = DefaultRepository();

  EventDetailViewModel(super.state, this.ref);

  Future<void> getDetail(Map<String, dynamic> requestData) async {
    try {
      final response = await repository.reqPost(url: Constant.apiMyPageEventDetailUrl, data: requestData);
      if (response != null) {
        if (response.statusCode == 200) {
          Map<String, dynamic> responseData = response.data;
          EventDetailResponseDTO eventDetailResponseDTO = EventDetailResponseDTO.fromJson(responseData);
          state.eventDetailResponseDTO = eventDetailResponseDTO;
          ref.notifyListeners();
          return;
        }
      }
      state.eventDetailResponseDTO = EventDetailResponseDTO(
        result: false,
        message: "Network Or Data Error",
        data: null,
      );
      ref.notifyListeners();
    } catch (e) {
      // Catch and log any exceptions
      if (kDebugMode) {
        print('Error fetching : $e');
      }
      state.eventDetailResponseDTO = EventDetailResponseDTO(
        result: false,
        message: e.toString(),
        data: null,
      );
      ref.notifyListeners();
    }
  }
}

final eventDetailViewModelProvider =
StateNotifierProvider<EventDetailViewModel, EventDetailModel>((req) {
  return EventDetailViewModel(EventDetailModel(), req);
});