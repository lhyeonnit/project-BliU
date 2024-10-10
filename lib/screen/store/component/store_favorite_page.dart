import 'package:BliU/data/bookmark_data.dart';
import 'package:BliU/data/category_data.dart';
import 'package:BliU/data/product_data.dart';
import 'package:BliU/screen/_component/move_top_button.dart';
import 'package:BliU/screen/product/component/list/product_list_card.dart';
import 'package:BliU/screen/product/component/list/product_sort_bottom.dart';
import 'package:BliU/screen/store/component/store_age_group_selection.dart';
import 'package:BliU/screen/store/store_detail_screen.dart';
import 'package:BliU/utils/responsive.dart';
import 'package:BliU/utils/shared_preferences_manager.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_svg/svg.dart';

import '../viewmodel/store_favorite_view_model.dart';

class StoreFavoritePage extends ConsumerStatefulWidget {
  const StoreFavoritePage({super.key});

  @override
  ConsumerState<StoreFavoritePage> createState() => _StoreFavoritePageState();
}

class _StoreFavoritePageState extends ConsumerState<StoreFavoritePage>
    with TickerProviderStateMixin {
  final TextEditingController _searchController = TextEditingController();
  late TabController _tabController;
  bool _isSearching = false;
  int _page = 1;
  bool _hasNextPage = true;
  bool _isFirstLoadRunning = false;
  bool _isLoadMoreRunning = false;
  int _count = 0;
  final int itemsPerPage = 5;
  final PageController pageController = PageController();
  final ScrollController _scrollController = ScrollController();
  String sortOption = '인기순';
  String sortOptionSelected = '';

  late List<CategoryData> ageCategories;
  CategoryData? selectedAgeGroup;
  List<BookmarkData> bookmarkList = [];
  final List<CategoryData> categories = [
    CategoryData(
        ctIdx: 0,
        cstIdx: 0,
        img: '',
        ctName: '전체',
        subList: [],
        catIdx: null,
        catName: null)
  ];
  List<ProductData> _productList = [];

  @override
  void initState() {
    super.initState();
    _scrollController.addListener(_nextLoad);
    _tabController = TabController(length: categories.length, vsync: this);
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _afterBuild(context);
    });
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  void _openSortBottomSheet() {
    showModalBottomSheet(
      context: context,
      builder: (context) {
        return ProductSortBottom(
          sortOption: sortOption,
          onSortOptionSelected: (selectedOption) {
            setState(() {
              sortOptionSelected = selectedOption;
              sortOption = selectedOption; // 선택된 정렬 옵션으로 업데이트
            });
          },
        );
      },
    );
  }

  void _showAgeGroupSelection() {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.white,
      builder: (BuildContext context) {
        return StoreAgeGroupSelection(
          ageCategories: ageCategories,
          selectedAgeGroup: selectedAgeGroup,
          onSelectionChanged: (CategoryData? newSelection) {
            setState(() {
              selectedAgeGroup = newSelection;
              _getList();
            });
          },
        );
      },
    );
  }

  String getSelectedAgeGroupText() {
    if (selectedAgeGroup == null) {
      return '연령';
    } else {
      return selectedAgeGroup?.catName ?? "";
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      backgroundColor: Colors.white,
      body: Stack(
        children: [
          NestedScrollView(
            controller: _scrollController,
            headerSliverBuilder: (context, innerBoxIsScrolled) {
              return [
                SliverToBoxAdapter(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Container(
                        margin: const EdgeInsets.symmetric(horizontal: 16),
                        padding: const EdgeInsets.only(top: 20, bottom: 17),
                        child: Text('즐겨찾기 ${bookmarkList.length}',
                          style: TextStyle(
                            fontFamily: 'Pretendard',
                            fontSize: Responsive.getFont(context, 14),
                            height: 1.2,
                          ),
                        ),
                      ),
                      Container(
                        margin: const EdgeInsets.symmetric(horizontal: 16),
                        height: bookmarkList.length <= 5
                            ? (bookmarkList.length * 60.0)
                            : 305,
                        // 아이템 수에 따라 높이 조정
                        width: Responsive.getWidth(context, 378),
                        child: PageView.builder(
                          controller: pageController,
                          itemCount: (bookmarkList.length / itemsPerPage).ceil(),
                          onPageChanged: (int page) {
                            _searchController.clear(); // 페이지 변경 시 검색 필드 초기화
                          },
                          itemBuilder: (context, pageIndex) {
                            final startIndex = pageIndex * itemsPerPage;
                            final endIndex = startIndex + itemsPerPage;
                            final bookmarkDataList = bookmarkList.sublist(
                              startIndex,
                              endIndex > bookmarkList.length ? bookmarkList.length : endIndex,
                            );

                            return ListView.builder(
                              shrinkWrap: true,
                              physics: const NeverScrollableScrollPhysics(),
                              itemCount: bookmarkDataList.length,
                              itemBuilder: (context, index) {
                                final store = bookmarkDataList[index];

                                return GestureDetector(
                                  onTap: () {
                                    // 상점 상세 화면으로 이동 (필요 시 구현)
                                    Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                        builder: (context) => StoreDetailScreen(
                                          stIdx: store.stIdx ?? 0,
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
                                            borderRadius: BorderRadius.circular(20),
                                            child:Image.network(
                                              store.stProfile ?? "",
                                              fit: BoxFit.contain,
                                              errorBuilder: (BuildContext context, Object exception, StackTrace? stackTrace) {
                                                return Image.asset('assets/images/home/exhi.png');
                                              },
                                            ),
                                          ),
                                        ),
                                        Expanded(
                                          child: Column(
                                            crossAxisAlignment: CrossAxisAlignment.start,
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
                                                            height: 1.2),
                                                        maxLines: 1,
                                                        overflow: TextOverflow.ellipsis),
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
                                              padding: const EdgeInsets.symmetric(vertical: 8),
                                              child: GestureDetector(
                                                onTap: () async {
                                                  final pref = await SharedPreferencesManager.getInstance();
                                                  final mtIdx = pref.getMtIdx(); // 사용자 mtIdx 가져오기
                                                  Map<String, dynamic> requestData = {
                                                    'mt_idx': mtIdx,
                                                    'st_idx': store.stIdx,
                                                  };
                                                  await ref.read(storeFavoriteViewModelProvider.notifier).toggleLike(requestData);
                                                },
                                                child: store.stLike == 1 ? SvgPicture.asset(
                                                  'assets/images/store/book_mark.svg',
                                                  colorFilter: const ColorFilter.mode(
                                                    Color(0xFFFF6192),
                                                    BlendMode.srcIn,
                                                  ),
                                                  fit: BoxFit.contain,
                                                ) : SvgPicture.asset(
                                                  'assets/images/store/book_mark.svg',
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
                      if (bookmarkList.length > 5) // 5개 이상일 때만 페이지네이션 표시
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: List.generate(
                              (bookmarkList.length / itemsPerPage).ceil(), (index) {
                               final currentPage = pageController.hasClients && pageController.page != null
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
                                style: TextStyle(
                                    height: 1.2,
                                    fontSize: Responsive.getFont(context, 14),
                                    fontFamily: 'Pretendard',
                                    decorationThickness: 0,
                                ),
                                controller: _searchController,
                                decoration: InputDecoration(
                                  contentPadding: const EdgeInsets.only(left: 16, bottom: 8),
                                  hintText: '즐겨찾기한 스토어 상품 검색',
                                  hintStyle: TextStyle(
                                    fontFamily: 'Pretendard',
                                    height: 1.2,
                                    fontSize: Responsive.getFont(context, 14),
                                    color: const Color(0xFF595959),
                                  ),
                                  border: InputBorder.none,
                                  suffixIcon: Visibility(
                                    visible: _searchController.text.isNotEmpty,
                                    child: GestureDetector(
                                      onTap: () {
                                        _searchController.clear();
                                        setState(() {
                                          _isSearching = false;
                                        });
                                      },
                                      child: SvgPicture.asset(
                                        'assets/images/ic_word_del.svg',
                                        fit: BoxFit.contain,
                                      ),
                                    ),
                                  ),
                                  suffixIconConstraints: BoxConstraints.tight(const Size(24, 24)),
                                ),
                                onChanged: (value) {
                                  if (value.isNotEmpty) {
                                    setState(() {
                                      _isSearching = true;
                                    });
                                  }
                                },
                                onSubmitted: (value) {
                                  if (value.isNotEmpty) {
                                    _getList();
                                  }
                                },
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
                                  colorFilter: const ColorFilter.mode(
                                    Colors.black,
                                    BlendMode.srcIn,
                                  ),
                                  fit: BoxFit.contain,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
                SliverToBoxAdapter(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Container(
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
                          dividerColor: const Color(0xFFDDDDDD),
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
                      ),
                      Container(
                        margin: const EdgeInsets.symmetric(horizontal: 16.0),
                        padding: const EdgeInsets.only(top: 15, bottom: 10),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            GestureDetector(
                              onTap: _openSortBottomSheet, // 정렬 옵션 선택 창 열기
                              child: Row(
                                children: [
                                  SvgPicture.asset('assets/images/product/ic_filter02.svg'),
                                  Container(
                                    margin: const EdgeInsets.only(left: 5),
                                    child: Text(
                                      sortOptionSelected.isNotEmpty ? sortOptionSelected : '인기순', // 선택된 정렬 옵션 표시
                                      style: TextStyle(
                                        fontFamily: 'Pretendard',
                                        fontSize: Responsive.getFont(context, 14),
                                        height: 1.2,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            GestureDetector(
                              onTap: _showAgeGroupSelection,
                              child: Container(
                                padding: const EdgeInsets.only(left: 20, right: 17, top: 11, bottom: 11),
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(22),
                                  border: Border.all(color: const Color(0xFFDDDDDD)),
                                ),
                                child: Row(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    Container(
                                      margin: const EdgeInsets.only(right: 5),
                                      child: Text(
                                        getSelectedAgeGroupText(), // 선택된 연령대 표시
                                        overflow: TextOverflow.ellipsis,
                                        maxLines: 1,
                                        style: TextStyle(
                                          fontFamily: 'Pretendard',
                                          fontSize: Responsive.getFont(context, 14),
                                          color: Colors.black,
                                          height: 1.2,
                                        ),
                                      ),
                                    ),
                                    SvgPicture.asset('assets/images/product/filter_select.svg'),
                                  ],
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                      Container(
                        margin: const EdgeInsets.symmetric(horizontal: 16.0),
                        padding: const EdgeInsets.only(bottom: 20),
                        child: Text(
                          '상품 $_count', // 상품 수 표시
                          style: TextStyle(
                            fontFamily: 'Pretendard',
                            fontSize: Responsive.getFont(context, 14),
                            color: Colors.black,
                            height: 1.2,
                          ),
                        ),
                      ),
                    ],
                  ), // 상단 고정된 컨텐츠
                )
              ];
            },
            body: TabBarView(
              controller: _tabController,
              children: List.generate(
                categories.length, (index) {
                if (index == _tabController.index) {
                  return _buildProductGrid();
                } else {
                  return Container();
                }
                },
              ),
            ),
          ),
          MoveTopButton(scrollController: _scrollController),
        ],
      ),
    );
  }
  Widget _buildProductGrid() {
    return GridView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      padding: const EdgeInsets.only(right: 16.0, left: 16, bottom: 20),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        childAspectRatio: 0.55,
        crossAxisSpacing: 12,
        mainAxisSpacing: 30,
      ),
      itemCount: _productList.length, // 실제 상품 수로 변경
      itemBuilder: (context, index) {
        final productData = _productList[index];

        return ProductListCard(productData: productData);
      },
    );
  }
  void _afterBuild(BuildContext context) {
    _getList();
    _getCategoryList();
  }
  void _getCategoryList() async {
    Map<String, dynamic> requestData = {'category_type': '1'};
    final categoryResponseDTO = await ref.read(storeFavoriteViewModelProvider.notifier).getCategory(requestData);
    if (categoryResponseDTO != null) {
      if (categoryResponseDTO.result == true) {
        final list = categoryResponseDTO.list ?? [];
        for (var item in list) {
          categories.add(item);
        }

        setState(() {
          _tabController = TabController(length: categories.length, vsync: this);
          _tabController.addListener(_tabChangeCallBack);
        });
      }
    }
  }
  void _tabChangeCallBack() {
    _hasNextPage = true;
    _isLoadMoreRunning = false;

    _getList();
  }
  void _getList() async {
    setState(() {
      _isFirstLoadRunning = true;
    });
    _page = 1;
    final pref = await SharedPreferencesManager.getInstance();
    final mtIdx = pref.getMtIdx();
    String category = "all";
    final categoryData = categories[_tabController.index];
    if ((categoryData.ctIdx ?? 0) > 0) {
      category = categoryData.ctIdx.toString();
    }
    Map<String, dynamic> requestBookmarkData = {
      'mt_idx': mtIdx,
      'pg': _page,
    };
    final bookmarkResponseDTO = await ref.read(storeFavoriteViewModelProvider.notifier).getBookmark(requestBookmarkData);
    bookmarkList = bookmarkResponseDTO?.list ?? [];

    final ageCategoryResponseDTO = await ref.read(storeFavoriteViewModelProvider.notifier).getAgeCategory();
    if (ageCategoryResponseDTO != null) {
      if (ageCategoryResponseDTO.result == true) {
        ageCategories = ageCategoryResponseDTO.list ?? [];
      }
    }

    String ageStr = "all";
    if (selectedAgeGroup != null) {
      ageStr = (selectedAgeGroup?.catIdx ?? 0).toString();
    }
    String searchTxt = _searchController.text.toLowerCase();

    Map<String, dynamic> requestProductData = {
      'mt_idx': mtIdx,
      'st_idx': 1,
      'category': category,
      'pg': 1,
      'search_txt': searchTxt,
      'age': ageStr,
      'sort': 2,
    };

    final productListResponseDTO = await ref.read(storeFavoriteViewModelProvider.notifier).getProductList(requestProductData);
    _count = productListResponseDTO?.count ?? 0;
    _productList = productListResponseDTO?.list ?? [];
    setState(() {
      _isFirstLoadRunning = false;
    });
  }

  void _nextLoad() async {

    if (_hasNextPage && !_isFirstLoadRunning && !_isLoadMoreRunning && _scrollController.position.extentAfter < 200){
      setState(() {
        _isLoadMoreRunning = true;
      });
      _page += 1;

      final pref = await SharedPreferencesManager.getInstance();
      final mtIdx = pref.getMtIdx();

      String category = "all";
      final categoryData = categories[_tabController.index];
      if ((categoryData.ctIdx ?? 0) > 0) {
        category = categoryData.ctIdx.toString();
      }

      Map<String, dynamic> requestData = {
        'mt_idx': mtIdx,
        'category': category,
        'sub_category': "all",
        'pg': _page,
      };

      final productListResponseDTO = await ref.read(storeFavoriteViewModelProvider.notifier).getProductList(requestData);
      if (productListResponseDTO != null) {
        _count = productListResponseDTO.list.length;
        if (productListResponseDTO.list.isNotEmpty) {
          setState(() {
            _productList.addAll(productListResponseDTO.list);
          });
        } else {
          setState(() {
            _hasNextPage = false;
          });
        }
      }

      setState(() {
        _isLoadMoreRunning = false;
      });
    }
  }
}
