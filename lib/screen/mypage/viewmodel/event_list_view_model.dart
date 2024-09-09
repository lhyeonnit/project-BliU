import 'package:BliU/api/default_repository.dart';
import 'package:BliU/const/constant.dart';
import 'package:BliU/data/event_data.dart';
import 'package:BliU/dto/event_list_response_dto.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class EventListModel {
  EventListResponseDTO? eventListResponseDTO;

  EventListModel({
    required this.eventListResponseDTO,
  });
}

class EventListViewModel extends StateNotifier<EventListModel?> {
  final Ref ref;
  final repository = DefaultRepository();

  EventListViewModel(super.state, this.ref);

  Future<void> getList(Map<String, dynamic> requestData) async {
    try {
      final response = await repository.reqPost(url: Constant.apiMyPageEventUrl, data: requestData);
      if (response != null) {
        if (response.statusCode == 200) {
          Map<String, dynamic> responseData = response.data;
          EventListResponseDTO eventListResponseDTO = EventListResponseDTO.fromJson(responseData);

          var list = state?.eventListResponseDTO?.list ?? [];
          List<EventData> addList = eventListResponseDTO.list ?? [];
          for (var item in  addList) {
            list.add(item);
          }

          eventListResponseDTO.list = list;

          state = EventListModel(eventListResponseDTO: eventListResponseDTO);
          return;
        }
      }
      state = state;
    } catch (e) {
      // Catch and log any exceptions
      print('Error fetching : $e');
      state = state;
    }
  }
}

final eventListModelProvider =
StateNotifierProvider<EventListViewModel, EventListModel?>((req) {
  return EventListViewModel(null, req);
});
