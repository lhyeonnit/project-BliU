import 'package:BliU/screen/store/component/detail/store_category.dart';
import 'package:BliU/screen/store/store_detail_screen.dart';
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
    final storeFavoriteViewModel =
        ref.read(storeFavoriteViewModelProvider.notifier);
    final storeFavoriteList = model?.bookmarkList ?? [];
    List<bool> isBookmarked = List<bool>.generate(10, (index) => false);

    const int itemsPerPage = 5;
    final PageController pageController = PageController();
    ScrollController scrollController = ScrollController();

    final totalItem = model?.bookmarkResponseDTO?.count ?? 0; // null인 경우 0으로 처리
    List<String> selectedAgeGroups = [];


    // 상태가 null인 경우, 로딩 상태로 처리
    if (storeFavoriteList.isEmpty) {
      return const Center(
        child: Text(
          '북마크된 스토어가 없습니다.',
          style: TextStyle( fontFamily: 'Pretendard',fontSize: 16, color: Colors.grey),
        ), // 로딩 인디케이터 추가
      );
    }

    return Scaffold(
      resizeToAvoidBottomInset: false,
      backgroundColor: Colors.white,
      body: Stack(
        children: [
          ListView(
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    margin: const EdgeInsets.symmetric(horizontal: 16),
                    padding: EdgeInsets.only(top: 20,bottom: 17),

                    child: Text(
                      '즐겨찾기 $totalItem',
                      style: TextStyle( fontFamily: 'Pretendard',fontSize: Responsive.getFont(context, 14)),
                    ),
                  ),
                  Container(
                    margin: const EdgeInsets.symmetric(horizontal: 16),
                    height: totalItem <= 5 ? (totalItem * 60.0) : 305, // 아이템 수에 따라 높이 조정
                    width: Responsive.getWidth(context, 378),
                    child: PageView.builder(
                      controller: pageController,
                      itemCount: (totalItem / itemsPerPage).ceil(),
                      onPageChanged: (int page) {
                        storeFavoriteViewModel.searchController.clear(); // 페이지 변경 시 검색 필드 초기화
                      },
                      itemBuilder: (context, pageIndex) {
                        final startIndex = pageIndex * itemsPerPage;
                        final endIndex = startIndex + itemsPerPage;
                        final displayedStores = storeFavoriteList.sublist(
                          startIndex,
                          endIndex > totalItem ? totalItem : endIndex,
                        );

                        return ListView.builder(
                          physics: const NeverScrollableScrollPhysics(),
                          itemCount: displayedStores.length,
                          itemBuilder: (context, index) {
                            final store = displayedStores[index];

                            return GestureDetector(
                              onTap: () {
                                // 상점 상세 화면으로 이동 (필요 시 구현)
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => const StoreDetailScreen(
                                      // Pass the store data to the detail screen
                                    ),
                                  ),
                                );
                              },
                              child: Container(
                                margin: const EdgeInsets.only(bottom: 15),
                                child: Row(
                                  children: [
                                    Container(
                                      height: 40,
                                      width: 40,
                                      margin: const EdgeInsets.only(right: 10),
                                      decoration: BoxDecoration(
                                        borderRadius: BorderRadius.circular(20),
                                        border: Border.all(
                                            color: const Color(0xFFDDDDDD), width: 1.0),
                                      ),
                                      child: ClipRRect(
                                        borderRadius: BorderRadius.circular(20),
                                        child: (store.stProfile ?? "").isNotEmpty
                                            ? Image.network(store.stProfile ?? "",
                                            fit: BoxFit.contain)
                                            : Image.asset(
                                            'assets/images/home/exhi.png'),
                                      ),
                                    ),
                                    Expanded(
                                      child: Column(
                                        crossAxisAlignment: CrossAxisAlignment.start,
                                        children: [
                                          Text(
                                            store.stName ?? "",
                                            style: TextStyle( fontFamily: 'Pretendard',
                                                fontSize: Responsive.getFont(context, 14)),
                                          ),
                                          Row(
                                            children: [
                                              Expanded(
                                                child: Text(
                                                  store.styleTxt ?? "",
                                                  style: TextStyle( fontFamily: 'Pretendard',
                                                    fontSize: Responsive.getFont(context, 13),
                                                    color: const Color(0xFF7B7B7B),
                                                  ),
                                                  maxLines: 1,
                                                  overflow: TextOverflow.ellipsis,
                                                ),
                                              ),
                                              const SizedBox(width: 5), // 텍스트 간 여백을 추가
                                              Expanded(
                                                child: Text(
                                                  store.ageTxt ?? "",
                                                  style: TextStyle( fontFamily: 'Pretendard',
                                                    fontSize: Responsive.getFont(context, 13),
                                                    color: const Color(0xFF7B7B7B),
                                                  ),
                                                  maxLines: 1,
                                                  overflow: TextOverflow.ellipsis,
                                                ),
                                              ),
                                            ],
                                          ),
                                        ],
                                      ),
                                    ),
                                    Column(
                                      children: [
                                        Container(
                                          height: Responsive.getHeight(context, 30),
                                          width: Responsive.getWidth(context, 30),
                                          padding: const EdgeInsets.symmetric(vertical: 8),
                                          child: GestureDetector(
                                            onTap: () {
                                              // 북마크 상태 변경 (토글)
                                            },
                                            child: SvgPicture.asset(
                                              'assets/images/store/book_mark.svg',
                                              color: (store.stLike ?? 0) > 0
                                                  ? const Color(0xFFFF6192)
                                                  : Colors.grey,
                                              fit: BoxFit.contain,
                                            ),
                                          ),
                                        ),
                                        Text(
                                          '${store.stLike}',
                                          style: TextStyle( fontFamily: 'Pretendard',
                                            color: const Color(0xFFA4A4A4),
                                            fontSize:
                                            Responsive.getFont(context, 12),
                                          ),
                                        ),
                                      ],
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
                  if (totalItem > 5) // 5개 이상일 때만 페이지네이션 표시
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: List.generate(
                          (storeFavoriteList.length / itemsPerPage).ceil(), (index) {
                        // Safe access to PageController.page, setting it to 0 if uninitialized
                        final currentPage = pageController.hasClients &&
                            pageController.page != null
                            ? pageController.page!.round()
                            : 0;

                        return Container(
                          margin: const EdgeInsets.only(right: 6,top: 25),
                          width: 6.0,
                          height: 6.0,
                          decoration: BoxDecoration(
                            color: currentPage == index
                                ? Colors.black
                                : const Color(0xFFDDDDDD),
                            shape: BoxShape.circle,
                          ),
                        );
                      }),
                    ),
                  const SizedBox(height: 30),
                  Container(
                    height: 44,
                    margin: const EdgeInsets.symmetric(horizontal: 16),
                    width: Responsive.getWidth(context, 380),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(6),
                      border: Border.all(color: const Color(0xFFE1E1E1)),
                    ),
                    child: Row(
                      children: [
                        Expanded(
                          child: TextField(
                            style: const TextStyle( fontFamily: 'Pretendard',decorationThickness: 0),
                            controller: storeFavoriteViewModel.searchController,
                            decoration: InputDecoration(
                              contentPadding: const EdgeInsets.only(left: 16, bottom: 8),
                              hintText: '즐겨찾기한 스토어 상품 검색',
                              hintStyle: TextStyle( fontFamily: 'Pretendard',
                                  color: const Color(0xFF595959),
                                  fontSize: Responsive.getFont(context, 14)),
                              border: InputBorder.none,
                              suffixIcon:
                              storeFavoriteViewModel.searchController.text.isNotEmpty
                                  ? GestureDetector(
                                onTap: () {
                                  storeFavoriteViewModel.searchController
                                      .clear();
                                },
                                child: SvgPicture.asset(
                                  'assets/images/ic_word_del.svg',
                                  fit: BoxFit.contain,
                                ),
                              )
                                  : null,
                              suffixIconConstraints:
                              BoxConstraints.tight(const Size(24, 24)),
                            ),
                            onSubmitted: (value) {
                              if (value.isNotEmpty) {
                                storeFavoriteViewModel.saveSearch(value);
                              }
                            },
                          ),
                        ),
                        Padding(
                          padding:
                          const EdgeInsets.symmetric(horizontal: 15, vertical: 10),
                          child: GestureDetector(
                            onTap: () {
                              final search =
                                  storeFavoriteViewModel.searchController.text;
                              if (search.isNotEmpty) {
                                storeFavoriteViewModel.saveSearch(search);
                                storeFavoriteViewModel.searchController.clear();
                              }
                            },
                            child: SvgPicture.asset(
                              'assets/images/home/ic_top_sch_w.svg',
                              color: Colors.black,
                              fit: BoxFit.contain,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  const StoreCategory(),
                ],
              ),
            ],
          ),
          MoveTopButton(scrollController: scrollController),
        ],
      ),
    );
  }
}
