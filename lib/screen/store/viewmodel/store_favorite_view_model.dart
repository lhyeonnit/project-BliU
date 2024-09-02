import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../../data/dto/store_bookmark_data.dart';
import '../../../repository/store_repository.dart';

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
  StoreFavoriteViewModel(super.state, this.ref) {
    _loadSearchHistory();
    notifyInit(); // ViewModel 초기화 시 데이터를 가져옴
  }

  Future<void> notifyInit() async {
    int mtIdx = 2;
    int pg = 1;

    try {


      if () {

      }else{
        print('Error: ${responseDTO.errorMessage}');
      } state = null;

      if (responseDTO.status == 200 && responseDTO.response != null) {
        if (responseDTO.response is Map<String, dynamic>) {
          // Response is a map, parse as BookmarkResponseDTO
          BookmarkResponseDTO bookmarkResponse = BookmarkResponseDTO.fromJson(responseDTO.response);

          // Update the state with the fetched data
          state = StoreFavoriteModel(
            bookmarkResponseDTO: bookmarkResponse,
            bookmarkStoreDTO: bookmarkResponse.stores,
          );
        } else if (responseDTO.response is List<BookmarkStoreDTO>) {
          // Response is already a List of BookmarkStoreDTO, no need for conversion
          List<BookmarkStoreDTO> bookmarkStores = responseDTO.response as List<BookmarkStoreDTO>;

          // Update the state with the fetched data
          state = StoreFavoriteModel(
            bookmarkResponseDTO: BookmarkResponseDTO(result: true, count: bookmarkStores.length, stores: bookmarkStores),
            bookmarkStoreDTO: bookmarkStores,
          );
        } else {
          print('Unexpected response format');
          state = null;
        }
      } else {
        // Handle error and set state to null

        state = null;
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
final storeFavoriteViewModelProvider = StateNotifierProvider<StoreFavoriteViewModel, StoreFavoriteModel?>((ref) {
  return StoreFavoriteViewModel(null, ref);
});
