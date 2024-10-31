import 'package:BliU/data/bookmark_data.dart';
import 'package:BliU/data/category_data.dart';
import 'package:BliU/data/product_data.dart';
import 'package:BliU/screen/_component/message_dialog.dart';
import 'package:BliU/screen/_component/move_top_button.dart';
import 'package:BliU/screen/_component/non_data_screen.dart';
import 'package:BliU/screen/product/component/list/product_list_card.dart';
import 'package:BliU/screen/product/component/list/product_sort_bottom.dart';
import 'package:BliU/screen/modal_dialog/store_age_group_selection.dart';
import 'package:BliU/screen/store_detail/store_detail_screen.dart';
import 'package:BliU/screen/main/page_screen/store/view_model/store_favorite_view_model.dart';
import 'package:BliU/utils/responsive.dart';
import 'package:BliU/utils/shared_preferences_manager.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_svg/svg.dart';
import 'package:focus_detector_v2/focus_detector_v2.dart';

class StoreFavoritePage extends ConsumerStatefulWidget {
  const StoreFavoritePage({super.key});

  @override
  ConsumerState<StoreFavoritePage> createState() => StoreFavoritePageState();
}

class StoreFavoritePageState extends ConsumerState<StoreFavoritePage> with TickerProviderStateMixin {
  final TextEditingController _searchController = TextEditingController();
  late TabController _tabController;

  final PageController _pageController = PageController();
  final ScrollController _scrollController = ScrollController();
  String sortOption = '인기순';
  String sortOptionSelected = '';

  late List<CategoryData> ageCategories;
  CategoryData? selectedAgeGroup;
  int _bookMarkCount = 0;
  int _bookMarkVisibleCount = 0;
  final List<List<BookmarkData>> _bookMarkList = [];
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

  int _count = 0;
  List<ProductData> _productList = [];

  double _maxScrollHeight = 0;// NestedScrollView 사용시 최대 높이를 저장하기 위한 변수

  int _page = 1;
  bool _hasNextPage = true;
  bool _isFirstLoadRunning = false;
  bool _isLoadMoreRunning = false;

  @override
  void initState() {
    super.initState();
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

  void _afterBuild(BuildContext context) {
    _getCategoryList();
    _getList();
    _getBookMark(1);
  }

  void _getCategoryList() async {
    final ageCategoryResponseDTO = await ref.read(storeFavoriteViewModelProvider.notifier).getAgeCategory();
    ageCategories = ageCategoryResponseDTO?.list ?? [];

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

  void _getBookMark(int page) async {
    final pref = await SharedPreferencesManager.getInstance();
    final mtIdx = pref.getMtIdx();

    Map<String, dynamic> requestBookmarkData = {
      'mt_idx': mtIdx,
      'pg': page,
    };
    final bookmarkResponseDTO = await ref.read(storeFavoriteViewModelProvider.notifier).getBookmark(requestBookmarkData);
    setState(() {
      _bookMarkCount = bookmarkResponseDTO?.count ?? 0;
      final list = bookmarkResponseDTO?.list ?? [];
      _bookMarkVisibleCount = list.length;

      if (_bookMarkList.length >= page) {
        _bookMarkList[page - 1] = list;
      } else {
        _bookMarkList.add([]);
        _bookMarkList[page - 1] = list;
      }
    });
  }

  Future<Map<String, dynamic>> _makeRequestData() async {
    final pref = await SharedPreferencesManager.getInstance();
    final mtIdx = pref.getMtIdx();

    String category = "all";
    final categoryData = categories[_tabController.index];
    if ((categoryData.ctIdx ?? 0) > 0) {
      category = categoryData.ctIdx.toString();
    }

    String ageStr = "all";
    if (selectedAgeGroup != null) {
      ageStr = (selectedAgeGroup?.catIdx ?? 0).toString();
    }

    int sort = 1;
    // 1 최신순 2 인기순 3: 추천수, 4: 가격 낮은수, 5: 가격 높은수
    switch (sortOptionSelected) {
      case "최신순":
        sort = 1;
        break;
      case "인기순":
        sort = 2;
        break;
      case "추천순":
        sort = 3;
        break;
      case "가격 낮은 순":
        sort = 4;
        break;
      case "가격 높은 순":
        sort = 5;
        break;
    }

    String searchTxt = _searchController.text.toLowerCase();

    Map<String, dynamic> requestProductData = {
      'mt_idx': mtIdx,
      'pg': _page,
      'search_txt': searchTxt,
      'category': category,
      'age': ageStr,
      'sort': sort,
    };

    return requestProductData;
  }

  void _getList() async {
    setState(() {
      _isFirstLoadRunning = true;
    });
    _page = 1;
    _hasNextPage = true;

    final requestProductData = await _makeRequestData();

    setState(() {
      _count = 0;
      _productList = [];
    });

    final productListResponseDTO = await ref.read(storeFavoriteViewModelProvider.notifier).getProductList(requestProductData);
    _count = productListResponseDTO?.count ?? 0;
    _productList = productListResponseDTO?.list ?? [];

    setState(() {
      _isFirstLoadRunning = false;
    });
  }

  void _nextLoad() async {

    if (_hasNextPage && !_isFirstLoadRunning && !_isLoadMoreRunning){
      setState(() {
        _isLoadMoreRunning = true;
      });
      _page += 1;

      final requestProductData = await _makeRequestData();

      final productListResponseDTO = await ref.read(storeFavoriteViewModelProvider.notifier).getProductList(requestProductData);
      if (productListResponseDTO != null) {
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

  void _openSortBottomSheet() {
    showModalBottomSheet(
      context: context,
      builder: (context) {
        return SafeArea(
          child: ProductSortBottom(
            sortOption: sortOption,
            onSortOptionSelected: (selectedOption) {
              setState(() {
                sortOptionSelected = selectedOption;
                sortOption = selectedOption; // 선택된 정렬 옵션으로 업데이트
                _getList();
              });
            },
          ),
        );
      },
    );
  }

  void _showAgeGroupSelection() {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.white,
      builder: (BuildContext context) {
        return SafeArea(
          child: StoreAgeGroupSelection(
            ageCategories: ageCategories,
            selectedAgeGroup: selectedAgeGroup,
            onSelectionChanged: (CategoryData? newSelection) {
              setState(() {
                selectedAgeGroup = newSelection;
                _getList();
              });
            },
          ),
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

  void _viewWillAppear(BuildContext context) {
    try {
      _pageController.jumpTo(0);
      _getList();
      _getBookMark(1);
    } catch (e) {
      if (kDebugMode) {
        print(e);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return FocusDetector(
      onFocusGained: () {
        _viewWillAppear(context);
      },
      child: Scaffold(
        resizeToAvoidBottomInset: false,
        backgroundColor: Colors.white,
        body: SafeArea(
          child: Stack(
            children: [
              Visibility(
                visible: _bookMarkCount > 0,
                child: NotificationListener(
                  onNotification: (scrollNotification) {
                    if (scrollNotification is ScrollEndNotification) {
                      var metrics = scrollNotification.metrics;
                      if (metrics.axisDirection != AxisDirection.down) return false;
                      if (_maxScrollHeight < metrics.maxScrollExtent) {
                        _maxScrollHeight = metrics.maxScrollExtent;
                      }

                      if (_maxScrollHeight - metrics.pixels < 200) {
                        _nextLoad();
                      }
                    }
                    return false;
                  },
                  child: NestedScrollView(
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
                                child: Text('즐겨찾기 $_bookMarkCount',
                                  style: TextStyle(
                                    fontFamily: 'Pretendard',
                                    fontSize: Responsive.getFont(context, 14),
                                    height: 1.2,
                                  ),
                                ),
                              ),
                              Container(
                                margin: const EdgeInsets.symmetric(horizontal: 16),
                                height: _bookMarkVisibleCount <= 5 ? (_bookMarkVisibleCount * 60.0) : 305,
                                width: Responsive.getWidth(context, 378),
                                child: PageView.builder(
                                  controller: _pageController,
                                  itemCount: (_bookMarkCount / 5).ceil(),
                                  onPageChanged: (int page) {
                                    _getBookMark(page + 1);
                                  },
                                  itemBuilder: (context, pageIndex) {
                                    List<BookmarkData> storeList = [];
                                    try {
                                      storeList = _bookMarkList[pageIndex];
                                    } catch(e) {
                                      if (kDebugMode) {
                                        print(e);
                                      }
                                    }

                                    return ListView.builder(
                                      shrinkWrap: true,
                                      physics: const NeverScrollableScrollPhysics(),
                                      itemCount: storeList.length,
                                      itemBuilder: (context, index) {
                                        final store = storeList[index];

                                        return GestureDetector(
                                          onTap: () {
                                            // 상점 상세 화면으로 이동 (필요 시 구현)
                                            Navigator.push(
                                              context,
                                              MaterialPageRoute(
                                                builder: (context) => StoreDetailScreen(stIdx: store.stIdx ?? 0),
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
                                                    border: Border.all(color: const Color(0xFFDDDDDD), width: 1.0),
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
                                                  flex: 14,
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
                                                Expanded(
                                                  flex: 2,
                                                  child: GestureDetector(
                                                    onTap: () async {
                                                      final pref = await SharedPreferencesManager.getInstance();
                                                      final mtIdx = pref.getMtIdx() ?? ""; // 사용자 mtIdx 가져오기

                                                      if (mtIdx.isEmpty) {
                                                        if(!context.mounted) return;
                                                        showDialog(
                                                            context: context,
                                                            builder: (context) {
                                                              return const MessageDialog(title: "알림", message: "로그인이 필요합니다.",);
                                                            }
                                                        );
                                                        return;
                                                      }

                                                      Map<String, dynamic> requestData = {
                                                        'mt_idx': mtIdx,
                                                        'st_idx': store.stIdx,
                                                      };
                                                      await ref.read(storeFavoriteViewModelProvider.notifier).toggleLike(requestData);
                                                      _getBookMark(pageIndex + 1);
                                                      _getList();
                                                    },
                                                    child: SizedBox(
                                                      width: double.infinity,
                                                      child: Column(
                                                        children: [
                                                          Container(
                                                            height: 30,
                                                            width: 30,
                                                            padding: const EdgeInsets.symmetric(vertical: 8),
                                                            child: SvgPicture.asset(
                                                              'assets/images/store/book_mark.svg',
                                                              colorFilter: const ColorFilter.mode(
                                                                Color(0xFFFF6192),
                                                                BlendMode.srcIn,
                                                              ),
                                                              fit: BoxFit.contain,
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
                                                    ),
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
                              Visibility(
                                visible: _bookMarkCount > 5 ? true : false,
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: List.generate((_bookMarkCount / 5).ceil(), (index) {
                                    final currentPage = _pageController.hasClients && _pageController.page != null ? _pageController.page!.round() : 0;
                                    return Container(
                                      margin: const EdgeInsets.only(right: 6, top: 25),
                                      width: 6.0,
                                      height: 6.0,
                                      decoration: BoxDecoration(
                                        color: currentPage == index ? Colors.black : const Color(0xFFDDDDDD),
                                        shape: BoxShape.circle,
                                      ),
                                    );
                                  }),
                                ),
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
                                        onTapOutside: (event) => FocusManager.instance.primaryFocus?.unfocus(),
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
                                                setState(() {});
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
                                          setState(() {});
                                        },
                                        onSubmitted: (value) {
                                          _getList();
                                        },
                                      ),
                                    ),
                                    Padding(
                                      padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 10),
                                      child: GestureDetector(
                                        onTap: () {
                                          _getList();
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
                                    Visibility(
                                      visible: categories[_tabController.index].ctName == "악세서리" ? false : true,
                                      maintainSize: true,
                                      maintainAnimation: true,
                                      maintainState: true,
                                      child: GestureDetector(
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
                              Visibility(
                                visible: _productList.isEmpty,
                                child: const NonDataScreen(text: '등록된 상품이 없습니다.',),
                              ),
                            ],
                          ), // 상단 고정된 컨텐츠
                        )
                      ];
                    },
                    body: TabBarView(
                      controller: _tabController,
                      physics: const NeverScrollableScrollPhysics(),
                      children: List.generate(
                          categories.length, (index) {
                        if (index == _tabController.index) {
                          return _buildProductGrid();
                        } else {
                          return Container();
                        }
                      }),
                    ),
                  ),
                ),
              ),
              if (_bookMarkCount > 0) MoveTopButton(scrollController: _scrollController),
              Visibility(
                visible: _bookMarkCount == 0,
                child:Center(
                  child: Column(
                    children: [
                      Container(
                        margin: const EdgeInsets.only(top: 130, bottom: 15),
                        child: SvgPicture.asset('assets/images/product/no_data_img.svg',
                          width: 90,
                          height: 90,
                        ),
                      ),
                      Text(
                        '추가된 북마크가 없습니다.',
                        style: TextStyle(
                          fontFamily: 'Pretendard',
                          fontSize: Responsive.getFont(context, 14),
                          fontWeight: FontWeight.w300,
                          color: const Color(0xFF7B7B7B),
                          height: 1.2,

                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
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
}
