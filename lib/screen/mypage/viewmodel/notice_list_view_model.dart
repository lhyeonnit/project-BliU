import 'package:BliU/api/default_repository.dart';
import 'package:BliU/const/constant.dart';
import 'package:BliU/data/notice_data.dart';
import 'package:BliU/dto/notice_list_response_dto.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class NoticeListModel {
  NoticeListResponseDTO? noticeListResponseDTO;

  NoticeListModel({
    this.noticeListResponseDTO,
  });
}

class NoticeListViewModel extends StateNotifier<NoticeListModel?> {
  final Ref ref;
  final repository = DefaultRepository();

  NoticeListViewModel(super.state, this.ref);

  Future<void> getList(Map<String, dynamic> requestData) async {
    try {
      final response = await repository.reqPost(url: Constant.apiMyPageNoticeUrl, data: requestData);
      if (response != null) {
        if (response.statusCode == 200) {
          Map<String, dynamic> responseData = response.data;
          NoticeListResponseDTO noticeListResponseDTO = NoticeListResponseDTO.fromJson(responseData);

          var list = state?.noticeListResponseDTO?.list ?? [];
          List<NoticeData> addList = noticeListResponseDTO.list ?? [];
          for (var item in  addList) {
            list.add(item);
          }

          noticeListResponseDTO.list = list;

          state = NoticeListModel(noticeListResponseDTO: noticeListResponseDTO);
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

final noticeListModelProvider =
StateNotifierProvider<NoticeListViewModel, NoticeListModel?>((req) {
  return NoticeListViewModel(null, req);
});