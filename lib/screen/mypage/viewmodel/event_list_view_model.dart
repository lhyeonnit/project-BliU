import 'package:BliU/api/default_repository.dart';
import 'package:BliU/const/constant.dart';
import 'package:BliU/dto/event_list_response_dto.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class EventListModel {}

class EventListViewModel extends StateNotifier<EventListModel?> {
  final Ref ref;
  final repository = DefaultRepository();

  EventListViewModel(super.state, this.ref);

  Future<EventListResponseDTO?> getList(Map<String, dynamic> requestData) async {
    try {
      final response = await repository.reqPost(url: Constant.apiMyPageEventUrl, data: requestData);
      if (response != null) {
        if (response.statusCode == 200) {
          Map<String, dynamic> responseData = response.data;
          EventListResponseDTO eventListResponseDTO = EventListResponseDTO.fromJson(responseData);
          return eventListResponseDTO;
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

final eventListModelProvider =
StateNotifierProvider<EventListViewModel, EventListModel?>((req) {
  return EventListViewModel(null, req);
});
