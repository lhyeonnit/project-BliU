


// // 북마크 추가/제거 처리
// Future<void> toggleBookmark(BookmarkStoreDTO store) async {
//   try {
//     final isBookmarked = store.stLike > 0;
//     final newLikeCount = isBookmarked ? store.stLike - 1 : store.stLike + 1;
//
//     // 서버에 북마크 상태 업데이트 요청
//     final response = await StoreRepository().toggleStoreLike(mtIdx: 2, stIdx: store.stIdx);
//     if (response.status == 200) {
//       // 성공적으로 북마크 상태가 변경되면 상태 업데이트
//       state = store.map((s) {
//         if (s.stIdx == store.stIdx) {
//           return BookmarkStoreDTO(
//             stIdx: s.stIdx,
//             stName: s.stName,
//             stProfile: s.stProfile,
//             stLike: newLikeCount, // 새로운 북마크 수 반영
//           );
//         }
//         return s;
//       }).toList();
//     } else {
//       print('Failed to toggle like: ${response.errorMessage}');
//     }
//   } catch (e) {
//     print('Error toggling like: $e');
//   }
// }