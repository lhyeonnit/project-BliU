import 'package:BliU/api/default_repository.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../../const/constant.dart';
import '../../../data/dto/store_bookmark_data.dart';

class StoreFavoriteModel {
  BookmarkResponseDTO? bookmarkResponseDTO;
  List<BookmarkStoreDTO>? bookmarkStoreDTO;

  StoreFavoriteModel({
    required this.bookmarkResponseDTO,
    required this.bookmarkStoreDTO,
  });
}

class StoreFavoriteViewModel extends StateNotifier<StoreFavoriteModel?> {
  final Ref ref;
  final repository = DefaultRepository();

  StoreFavoriteViewModel(super.state, this.ref) {
    _loadSearchHistory();
    notifyInit(); // ViewModel 초기화 시 데이터를 가져옴
  }

  Future<void> notifyInit() async {
    int mtIdx = 2;
    int pg = 1;

    Map<String, dynamic> requestData = {
      'mt_idx': mtIdx.toString(),
      'pg': pg.toString(),
    };
    try {
      final response = await repository.reqPost(
          url: Constant.apiStoreBookMarkUrl, data: requestData);

      if (response == 200 && requestData['result'] == true) {
        // 응답 데이터를 최상위 레벨에서 Map<String, dynamic>으로 가져옴
        final Map<String, dynamic> bookmarkListJson = requestData;

        // `data` -> `list` 경로를 통해 실제 리스트를 추출
        final List<dynamic> listJson = bookmarkListJson['data']['list'];

        // Mapping JSON to BookmarkStoreDTO objects
        List<BookmarkStoreDTO> bookmarkList = listJson.map((item) {
          return BookmarkStoreDTO.fromJson(item as Map<String, dynamic>);
        }).toList();

        state = StoreFavoriteModel(
          bookmarkResponseDTO: BookmarkResponseDTO(
              result: true, count: bookmarkList.length, stores: bookmarkList),
          bookmarkStoreDTO: bookmarkList,
        );
      } else {
        print('Error: ');
      }
    } catch (e) {
      // Catch and log any exceptions
      print('Error fetching bookmark list: $e');
      state = null;
    }
  }

  List<String> searchHistory = [];
  TextEditingController searchController = TextEditingController();

  // 검색 기록 불러오기
  Future<void> _loadSearchHistory() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    searchHistory = prefs.getStringList('searchHistory') ?? [];
  }

  // 검색 기록 저장하기
  Future<void> saveSearch(String search) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    searchHistory.add(search);
    await prefs.setStringList('searchHistory', searchHistory);
  }

// 북마크 추가/제거 처리
// Future<void> toggleBookmark(BookmarkStoreDTO store) async {
//   try {
//     // Toggle bookmark like/unlike
//     final isBookmarked = store.stLike > 0;
//     final newLikeCount = isBookmarked ? store.stLike - 1 : store.stLike + 1;
//
//     // Call repository to toggle the bookmark on the server
//     final response = await StoreRepository().toggleStoreLike(mtIdx: 2, stIdx: store.stIdx);
//
//     if (response.status == 200) {
//       // If toggle was successful, update the local state
//       if (state != null && state!.bookmarkStoreDTO != null) {
//         List<BookmarkStoreDTO> updatedStores = state!.bookmarkStoreDTO!.map((s) {
//           if (s.stIdx == store.stIdx) {
//             return BookmarkStoreDTO(
//               stIdx: s.stIdx,
//               stName: s.stName,
//               stProfile: s.stProfile,
//               styleTxt: s.styleTxt,
//               ageTxt: s.ageTxt,
//               stLike: newLikeCount,
//             );
//           }
//           return s;
//         }).toList();
//
//         // Update the state with the modified list
//         state = StoreFavoriteModel(
//           bookmarkResponseDTO: state!.bookmarkResponseDTO,
//           bookmarkStoreDTO: updatedStores,
//         );
//       }
//     } else {
//       print('Failed to toggle like: ${response.errorMessage}');
//     }
//   } catch (e) {
//     print('Error toggling like: $e');
//   }
// }
}

// ViewModel Provider 정의
final storeFavoriteViewModelProvider =
    StateNotifierProvider<StoreFavoriteViewModel, StoreFavoriteModel?>((ref) {
  return StoreFavoriteViewModel(null, ref);
});
