import 'package:BliU/api/default_repository.dart';
import 'package:BliU/const/constant.dart';
import 'package:BliU/data/bookmark_data.dart';
import 'package:BliU/dto/bookmark_response_dto.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';


class StoreFavoriteModel {
  BookmarkResponseDTO? bookmarkResponseDTO;

  StoreFavoriteModel({
    required this.bookmarkResponseDTO,
  });
}

class StoreFavoriteViewModel extends StateNotifier<StoreFavoriteModel?> {
  final Ref ref;
  final repository = DefaultRepository();

  StoreFavoriteViewModel(super.state, this.ref);

  /// 북마크 목록 초기화 및 가져오기
  Future<void> getBookmark(Map<String, dynamic> requestData) async {
    try {
      final response = await repository.reqPost(
        url: Constant.apiStoreBookMarkUrl,
        data: requestData,
      );
      if (response != null) {
        if (response.statusCode == 200) {
          Map<String, dynamic> responseData = response.data;
          BookmarkResponseDTO bookmarkResponseDTO =
              BookmarkResponseDTO.fromJson(responseData);

          List<BookmarkData> list = bookmarkResponseDTO.list ?? [];

          bookmarkResponseDTO.list = list;

          state = StoreFavoriteModel(bookmarkResponseDTO: bookmarkResponseDTO);
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

  /// 북마크 상태를 토글하는 메서드
  Future<void> toggleLike(Map<String, dynamic> requestData) async {
    try {
      final response = await repository.reqPost(
        url: Constant.apiStoreLikeUrl,
        data: requestData,
      );

      if (response != null && response.statusCode == 200) {
        bool result = response.data['result'];
        int stIdx = requestData['st_idx'];

        if (result) {
          // 북마크 리스트에서 stIdx를 찾아 상태 반전
          List<BookmarkData>? updatedList = state?.bookmarkResponseDTO?.list?.map((store) {
            if (store.stIdx == stIdx) {
              store.stLike = store.stLike == 1 ? 0 : 1; // 북마크 상태 반전
            }
            return store;
          }).toList();

          // 상태 업데이트
          state = StoreFavoriteModel(
            bookmarkResponseDTO: BookmarkResponseDTO(
              result: state?.bookmarkResponseDTO?.result ?? false,
              count: updatedList?.length ?? 0,
              list: updatedList,
            ),
          );
        }
      }
    } catch (e) {
      print('Error toggling like: $e');
    }
  }
}

// ViewModel Provider 정의
final storeFavoriteViewModelProvider =
    StateNotifierProvider<StoreFavoriteViewModel, StoreFavoriteModel?>((req) {
  return StoreFavoriteViewModel(null, req);
});
