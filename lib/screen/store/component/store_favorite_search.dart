// Container(
// margin: const EdgeInsets.symmetric(horizontal: 16),
// height: 44,
// width: Responsive.getWidth(context, 380),
// decoration: BoxDecoration(
// borderRadius: BorderRadius.circular(6),
// border: Border.all(color: const Color(0xFFE1E1E1)),
// ),
// child: Row(
// children: [
// Expanded(
// child: TextField(
// style: const TextStyle(decorationThickness: 0),
// controller: storeFavoriteViewModel.searchController,
// decoration: InputDecoration(
// contentPadding: const EdgeInsets.only(left: 16, bottom: 8),
// hintText: '즐겨찾기한 스토어 상품 검색',
// hintStyle: TextStyle(
// color: const Color(0xFF595959),
// fontSize: Responsive.getFont(context, 14)),
// border: InputBorder.none,
// suffixIcon: storeFavoriteViewModel.searchController.text.isNotEmpty
// ? GestureDetector(
// onTap: () {
// storeFavoriteViewModel.searchController.clear();
// },
// child: SvgPicture.asset(
// 'assets/images/ic_word_del.svg',
// fit: BoxFit.contain,
// ),
// )
//     : null,
// suffixIconConstraints: BoxConstraints.tight(const Size(24, 24)),
// ),
// onSubmitted: (value) {
// if (value.isNotEmpty) {
// storeFavoriteViewModel.saveSearch(value);
// }
// },
// ),
// ),
// Padding(
// padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 10),
// child: GestureDetector(
// onTap: () {
// final search = storeFavoriteViewModel.searchController.text;
// if (search.isNotEmpty) {
// storeFavoriteViewModel.saveSearch(search);
// storeFavoriteViewModel.searchController.clear();
// }
// },
// child: SvgPicture.asset(
// 'assets/images/home/ic_top_sch_w.svg',
// color: Colors.black,
// fit: BoxFit.contain,
// ),
// ),
// ),
// ],
// ),
// ),


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