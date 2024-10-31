import 'package:BliU/api/default_repository.dart';
import 'package:BliU/const/constant.dart';
import 'package:BliU/dto/notice_detail_response_dto.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class NoticeDetailModel {
  NoticeDetailResponseDTO? noticeDetailResponseDTO;

  NoticeDetailModel({
    required this.noticeDetailResponseDTO,
  });
}

class NoticeDetailViewModel extends StateNotifier<NoticeDetailModel?> {
  final Ref ref;
  final repository = DefaultRepository();

  NoticeDetailViewModel(super.state, this.ref);

  Future<void> getDetail(Map<String, dynamic> requestData) async {
    try {
      final response = await repository.reqPost(url: Constant.apiMyPageNoticeDetailUrl, data: requestData);
      if (response != null) {
        if (response.statusCode == 200) {
          Map<String, dynamic> responseData = response.data;
          NoticeDetailResponseDTO noticeDetailResponseDTO = NoticeDetailResponseDTO.fromJson(responseData);
          state = NoticeDetailModel(noticeDetailResponseDTO: noticeDetailResponseDTO);
          return;
        }
      }
      state = NoticeDetailModel(
          noticeDetailResponseDTO: NoticeDetailResponseDTO(
              result: false,
              message: "Network Or Data Error",
              data: null
          )
      );
    } catch (e) {
      // Catch and log any exceptions
      if (kDebugMode) {
        print('Error fetching : $e');
      }
      state = NoticeDetailModel(
          noticeDetailResponseDTO: NoticeDetailResponseDTO(
              result: false,
              message: e.toString(),
              data: null
          )
      );
    }
  }
}

final noticeDetailViewModelProvider =
StateNotifierProvider<NoticeDetailViewModel, NoticeDetailModel?>((req) {
  return NoticeDetailViewModel(null, req);
});