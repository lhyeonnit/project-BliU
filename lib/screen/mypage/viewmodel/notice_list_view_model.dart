import 'package:BliU/api/default_repository.dart';
import 'package:BliU/const/constant.dart';
import 'package:BliU/dto/notice_list_response_dto.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class NoticeListModel {}

class NoticeListViewModel extends StateNotifier<NoticeListModel?> {
  final Ref ref;
  final repository = DefaultRepository();

  NoticeListViewModel(super.state, this.ref);

  Future<NoticeListResponseDTO?> getList(Map<String, dynamic> requestData) async {
    try {
      final response = await repository.reqPost(url: Constant.apiMyPageNoticeUrl, data: requestData);
      if (response != null) {
        if (response.statusCode == 200) {
          Map<String, dynamic> responseData = response.data;
          NoticeListResponseDTO noticeListResponseDTO = NoticeListResponseDTO.fromJson(responseData);
          return noticeListResponseDTO;
        }
      }
      return null;
    } catch (e) {
      // Catch and log any exceptions
      print('Error fetching : $e');
      return null;
    }
  }
}

final noticeListModelProvider =
StateNotifierProvider<NoticeListViewModel, NoticeListModel?>((req) {
  return NoticeListViewModel(null, req);
});