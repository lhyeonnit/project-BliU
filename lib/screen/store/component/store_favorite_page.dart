import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:BliU/utils/responsive.dart';
import 'package:BliU/screen/_component/move_top_button.dart';
import '../viewmodel/store_favorite_view_model.dart';

class StoreFavoritePage extends ConsumerWidget {
  const StoreFavoritePage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final model = ref.watch(storeFavoriteViewModelProvider);
    final storeFavoriteViewModel = ref.read(storeFavoriteViewModelProvider.notifier);
    final storeFavoriteList = model?.bookmarkStoreDTO ?? [];
    final int itemsPerPage = 5;
    final PageController pageController = PageController();

    // 상태가 null인 경우, 로딩 상태로 처리
    if (storeFavoriteList.isEmpty) {
      return const Center(
        child: Text(
          '북마크된 스토어가 없습니다.',
          style: TextStyle(fontSize: 16, color: Colors.grey),
        ),// 로딩 인디케이터 추가
      );
    }

    return Scaffold(
      backgroundColor: Colors.white,
      body: Stack(
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                margin: const EdgeInsets.only(left: 16, top: 20),
                child: Text(
                  '즐겨찾기 ${storeFavoriteList.length}',
                  style: TextStyle(fontSize: Responsive.getFont(context, 14)),
                ),
              ),
              const SizedBox(height: 15),
              Container(
                height: 305, // 즐겨찾기 항목의 고정된 높이
                child: PageView.builder(
                  controller: pageController,
                  itemCount: (storeFavoriteList.length / itemsPerPage).ceil(),
                  onPageChanged: (int page) {
                    storeFavoriteViewModel.searchController.clear(); // 페이지 변경 시 검색 필드 초기화
                  },
                  itemBuilder: (context, pageIndex) {
                    final startIndex = pageIndex * itemsPerPage;
                    final endIndex = startIndex + itemsPerPage;
                    final displayedStores = storeFavoriteList.sublist(
                      startIndex,
                      endIndex > storeFavoriteList.length ? storeFavoriteList.length : endIndex,
                    );

                    return ListView.builder(
                      physics: const NeverScrollableScrollPhysics(),
                      itemCount: displayedStores.length,
                      itemBuilder: (context, index) {
                        final store = displayedStores[index];

                        return GestureDetector(
                          onTap: () {
                            // 상점 상세 화면으로 이동 (필요 시 구현)
                          },
                          child: Container(
                            margin: const EdgeInsets.only(bottom: 15, left: 16),
                            child: Row(
                              children: [
                                Container(
                                  height: 40,
                                  width: 40,
                                  margin: const EdgeInsets.only(right: 10),
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(20),
                                    border: Border.all(color: const Color(0xFFDDDDDD), width: 1.0),
                                  ),
                                  child: ClipRRect(
                                    borderRadius: BorderRadius.circular(20),
                                    child: store.stProfile.isNotEmpty
                                        ? Image.network(store.stProfile, fit: BoxFit.contain)
                                        : Image.asset('assets/images/home/exhi.png'),
                                  ),
                                ),
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        store.stName,
                                        style: TextStyle(fontSize: Responsive.getFont(context, 14)),
                                      ),
                                      const SizedBox(height: 4),
                                    ],
                                  ),
                                ),
                                Padding(
                                  padding: const EdgeInsets.only(right: 16.0),
                                  child: Column(
                                    children: [
                                      GestureDetector(
                                        onTap: () {
                                          // 북마크 상태 변경 (토글)
                                          storeFavoriteViewModel.toggleBookmark(store);
                                        },
                                        child: SvgPicture.asset(
                                          'assets/images/store/book_mark.svg',
                                          color: store.stLike > 0
                                              ? const Color(0xFFFF6192)
                                              : Colors.grey,
                                          height: Responsive.getHeight(context, 30),
                                          width: Responsive.getWidth(context, 30),
                                          fit: BoxFit.contain,
                                        ),
                                      ),
                                      const SizedBox(height: 6),
                                      Text(
                                        '${store.stLike}',
                                        style: TextStyle(
                                          color: const Color(0xFFA4A4A4),
                                          fontSize: Responsive.getFont(context, 12),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          ),
                        );
                      },
                    );
                  },
                ),
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: List.generate((storeFavoriteList.length / itemsPerPage).ceil(), (index) {
                  return Container(
                    margin: const EdgeInsets.only(right: 6),
                    width: 6.0,
                    height: 6.0,
                    decoration: BoxDecoration(
                      color: pageController.page?.round() == index ? Colors.black : const Color(0xFFDDDDDD),
                      shape: BoxShape.circle,
                    ),
                  );
                }),
              ),
            ],
          ),
          MoveTopButton(scrollController: ScrollController()),
        ],
      ),
    );
  }
}
