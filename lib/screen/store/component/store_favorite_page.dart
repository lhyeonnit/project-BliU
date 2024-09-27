import 'package:BliU/screen/category/viewmodel/category_view_model.dart';
import 'package:BliU/screen/store/store_detail_screen.dart';
import 'package:BliU/utils/shared_preferences_manager.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:BliU/utils/responsive.dart';
import 'package:BliU/screen/_component/move_top_button.dart';
import '../viewmodel/store_favorite_view_model.dart';

class StoreFavoritePage extends ConsumerStatefulWidget {
  const StoreFavoritePage({super.key});

  @override
  _StoreFavoritePageState createState() => _StoreFavoritePageState();
}

class _StoreFavoritePageState extends ConsumerState<StoreFavoritePage> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _afterBuild(context);
    });
  }

  final TextEditingController _searchController = TextEditingController();
  late TabController _tabController;

  final int itemsPerPage = 5;
  final PageController pageController = PageController();
  ScrollController scrollController = ScrollController();

  List<String> selectedAgeGroups = [];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      backgroundColor: Colors.white,
      body: Stack(
        children: [
          ListView(
            shrinkWrap: true,
            children: [
              Consumer(builder: (context, ref, widget) {
                final model = ref.watch(storeFavoriteViewModelProvider);
                final list = model?.bookmarkResponseDTO?.list ?? [];
                return Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      margin: const EdgeInsets.symmetric(horizontal: 16),
                      padding: EdgeInsets.only(top: 20, bottom: 17),
                      child: Text(
                        '즐겨찾기 ${list.length}',
                        style: TextStyle(
                          fontFamily: 'Pretendard',
                          fontSize: Responsive.getFont(context, 14),
                          height: 1.2,
                        ),
                      ),
                    ),
                    Container(
                      margin: const EdgeInsets.symmetric(horizontal: 16),
                      height: list.length <= 5 ? (list.length * 60.0) : 305,
                      // 아이템 수에 따라 높이 조정
                      width: Responsive.getWidth(context, 378),
                      child: PageView.builder(
                        controller: pageController,
                        itemCount: (list.length / itemsPerPage).ceil(),
                        onPageChanged: (int page) {
                          _searchController.clear(); // 페이지 변경 시 검색 필드 초기화
                        },
                        itemBuilder: (context, pageIndex) {
                          final startIndex = pageIndex * itemsPerPage;
                          final endIndex = startIndex + itemsPerPage;
                          final bookmarkList = list.sublist(
                            startIndex,
                            endIndex > list.length ? list.length : endIndex,
                          );

                          return ListView.builder(
                            shrinkWrap: true,
                            physics: const NeverScrollableScrollPhysics(),
                            itemCount: bookmarkList.length,
                            itemBuilder: (context, index) {
                              final store = bookmarkList[index];

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
                                        margin:
                                            const EdgeInsets.only(right: 10),
                                        decoration: BoxDecoration(
                                          borderRadius:
                                              BorderRadius.circular(20),
                                          border: Border.all(
                                              color: const Color(0xFFDDDDDD),
                                              width: 1.0),
                                        ),
                                        child: ClipRRect(
                                          borderRadius:
                                              BorderRadius.circular(20),
                                          child: (store.stProfile ?? "")
                                                  .isNotEmpty
                                              ? Image.network(
                                                  store.stProfile ?? "",
                                                  fit: BoxFit.contain)
                                              : Image.asset(
                                                  'assets/images/home/exhi.png'),
                                        ),
                                      ),
                                      Expanded(
                                        child: Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            Text(
                                              store.stName ?? "",
                                              style: TextStyle(
                                                fontFamily: 'Pretendard',
                                                fontSize: Responsive.getFont(context, 14),
                                                height: 1.2,
                                              ),
                                            ),
                                            Row(
                                              children: [
                                                Expanded(
                                                  child: Text(
                                                    store.styleTxt ?? "",
                                                    style: TextStyle(
                                                      fontFamily: 'Pretendard',
                                                      fontSize: Responsive.getFont(context, 13),
                                                      color: const Color(0xFF7B7B7B),
                                                      height: 1.2,
                                                    ),
                                                    maxLines: 1,
                                                    overflow: TextOverflow.ellipsis,
                                                  ),
                                                ),
                                                const SizedBox(width: 5),
                                                // 텍스트 간 여백을 추가
                                                Expanded(
                                                  child: Text(
                                                    store.ageTxt ?? "",
                                                    style: TextStyle(
                                                      fontFamily: 'Pretendard',
                                                      fontSize: Responsive.getFont(context, 13),
                                                      color: const Color(0xFF7B7B7B),
                                                      height: 1.2,
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
                                            height: 30,
                                            width: 30,
                                            padding: const EdgeInsets.symmetric(
                                                vertical: 8),
                                            child: GestureDetector(
                                              onTap: () async {
                                                final pref =
                                                    await SharedPreferencesManager
                                                        .getInstance();
                                                final mtIdx = pref
                                                    .getMtIdx(); // 사용자 mtIdx 가져오기
                                                Map<String, dynamic>
                                                    requestData = {
                                                  'mt_idx': mtIdx,
                                                  'st_idx': store.stIdx,
                                                  // 상점 인덱스 사용
                                                };
                                                await ref
                                                    .read(
                                                        storeFavoriteViewModelProvider
                                                            .notifier)
                                                    .toggleLike(requestData);
                                              },
                                              child: SvgPicture.asset(
                                                'assets/images/store/book_mark.svg',
                                                color: store.stLike == 1
                                                    ? const Color(0xFFFF6192)
                                                    : Colors.grey,
                                                fit: BoxFit.contain,
                                              ),
                                            ),
                                          ),
                                          Text(
                                            '${store.stLike}',
                                            style: TextStyle(
                                              fontFamily: 'Pretendard',
                                              color: const Color(0xFFA4A4A4),
                                              fontSize: Responsive.getFont(context, 12),
                                              height: 1.2,
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
                    if (list.length > 5) // 5개 이상일 때만 페이지네이션 표시
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: List.generate(
                            (list.length / itemsPerPage).ceil(), (index) {
                          // Safe access to PageController.page, setting it to 0 if uninitialized
                          final currentPage = pageController.hasClients &&
                                  pageController.page != null
                              ? pageController.page!.round()
                              : 0;

                          return Container(
                            margin: const EdgeInsets.only(right: 6, top: 25),
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
                              style: const TextStyle(
                                  fontFamily: 'Pretendard',
                                  decorationThickness: 0),
                              // controller:
                              // storeFavoriteViewModel.searchController,
                              decoration: InputDecoration(
                                contentPadding:
                                    const EdgeInsets.only(left: 16, bottom: 8),
                                hintText: '즐겨찾기한 스토어 상품 검색',
                                hintStyle: TextStyle(
                                    fontFamily: 'Pretendard',
                                    color: const Color(0xFF595959),
                                    fontSize: Responsive.getFont(context, 14)),
                                border: InputBorder.none,
                                suffixIcon: _searchController.text.isNotEmpty
                                    ? GestureDetector(
                                        onTap: () {
                                          _searchController.clear();
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
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 15, vertical: 10),
                            child: GestureDetector(
                              onTap: () {
                                final search = _searchController.text;
                                if (search.isNotEmpty) {
                                  _searchController.clear();
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
                    Consumer(builder: (context, ref, widget) {
                      final model = ref.watch(categoryModelProvider);
                      final categories = model?.categoryResponseDTO?.list ?? [];
                      return Container(
                        height: 60.0,
                        padding: const EdgeInsets.symmetric(vertical: 5),
                        child: TabBar(
                          controller: _tabController,
                          labelStyle: TextStyle(
                            fontFamily: 'Pretendard',
                            fontSize: Responsive.getFont(context, 14),
                            fontWeight: FontWeight.w600,
                          ),
                          overlayColor: WidgetStateColor.transparent,
                          indicatorColor: Colors.black,
                          dividerColor: Color(0xFFDDDDDD),
                          indicatorSize: TabBarIndicatorSize.tab,
                          labelColor: Colors.black,
                          unselectedLabelColor: const Color(0xFF7B7B7B),
                          isScrollable: true,
                          indicatorWeight: 2.0,
                          tabAlignment: TabAlignment.start,
                          padding: const EdgeInsets.symmetric(horizontal: 12),
                          tabs: categories.map((category) {
                            return Tab(text: category.ctName ?? "");
                          }).toList(),
                        ),
                      );
                    })
                  ],
                );
              }),
            ],
          ),
          MoveTopButton(scrollController: scrollController),
        ],
      ),
    );
  }

  void _afterBuild(BuildContext context) {
    _getList(true);
    _getCategory;
  }

  void _getCategory() async{
    Map<String, dynamic> requestData = {'category_type': '2'};
    ref.read(categoryModelProvider.notifier).getCategory(requestData);
  }
  void _getList(bool isNew) async {
    final pref = await SharedPreferencesManager.getInstance();
    final mtIdx = pref.getMtIdx();

    // 회원 여부에 따라 처리 (비회원도 처리 가능)
    // if (mtIdx == null || mtIdx.isEmpty) {
    //   // 비회원 처리 (예: 비회원용 메시지나 기본값 설정)
    //   print('비회원');
    // } else {
    //   print('회원 mtIdx: $mtIdx');
    // }

    // 페이징 처리도 추가 가능
    Map<String, dynamic> requestData = {
      'mt_idx': mtIdx,
      'pg': 1,
    };

    await ref
        .read(storeFavoriteViewModelProvider.notifier)
        .getBookmark(requestData); // 서버에서 데이터 가져오기
  }
}
