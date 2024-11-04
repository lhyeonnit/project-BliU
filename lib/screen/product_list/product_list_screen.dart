import 'dart:convert';

import 'package:BliU/data/category_data.dart';
import 'package:BliU/data/product_data.dart';
import 'package:BliU/data/style_category_data.dart';
import 'package:BliU/screen/_component/move_top_button.dart';
import 'package:BliU/screen/_component/non_data_screen.dart';
import 'package:BliU/screen/_component/top_cart_button.dart';
import 'package:BliU/screen/modal_dialog/product_category_bottom.dart';
import 'package:BliU/screen/modal_dialog/product_filter_bottom.dart';
import 'package:BliU/screen/modal_dialog/product_sort_bottom.dart';
import 'package:BliU/screen/product_list/item/product_list_card.dart';
import 'package:BliU/screen/product_list/view_model/product_list_view_model.dart';
import 'package:BliU/screen/search/search_screen.dart';
import 'package:BliU/utils/responsive.dart';
import 'package:BliU/utils/shared_preferences_manager.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_svg/flutter_svg.dart';

class ProductListScreen extends ConsumerStatefulWidget {
  final CategoryData selectedCategory;
  final int? selectSubCategoryIndex;

  const ProductListScreen({super.key, required this.selectedCategory, this.selectSubCategoryIndex});

  @override
  ConsumerState<ProductListScreen> createState() => ProductListScreenState();
}

class ProductListScreenState extends ConsumerState<ProductListScreen> with TickerProviderStateMixin {
  final ScrollController _scrollController = ScrollController();
  late TabController _tabController;
  late CategoryData _selectedCategory;
  late List<CategoryData> _categories;

  List<CategoryData> _ageCategories = [];
  List<StyleCategoryData> _styleCategories = [];

  bool _isTodayStart = true;
  String _sortOption = '최신순';
  String _sortOptionSelected = '';

  CategoryData? selectedAgeGroup;
  List<StyleCategoryData> selectedStyles = [];
  RangeValues selectedRangeValues = const RangeValues(0, 100000);

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
    _selectedCategory = widget.selectedCategory;
    _categories = _selectedCategory.subList ?? [];
    _tabController = TabController(length: _categories.length, vsync: this);
    _tabController.addListener(_tabChangeCallBack);

    if (widget.selectSubCategoryIndex != null) {
      _tabController.animateTo(widget.selectSubCategoryIndex ?? 0);
    }
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _afterBuild(context);
    });
  }

  @override
  void dispose() {
    _tabController.removeListener(_tabChangeCallBack);
    _tabController.dispose();
    super.dispose();
  }

  void _afterBuild(BuildContext context) {
    _getList();
    _getFilterCategory();
  }

  void _tabChangeCallBack() {
    print("_tabChangeCallBack");
    _hasNextPage = true;
    _isLoadMoreRunning = false;

    _getList();
  }

  void _getList() async {
    setState(() {
      _isFirstLoadRunning = true;
    });
    _page = 1;
    _maxScrollHeight = 0;

    final requestData = await _makeRequestData();

    setState(() {
      _count = 0;
      _productList = [];
    });

    final productListResponseDTO = await ref.read(productListViewModelProvider.notifier).getList(requestData);
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

      final requestData = await _makeRequestData();

      final productListResponseDTO = await ref.read(productListViewModelProvider.notifier).getList(requestData);
      if (productListResponseDTO != null) {
        _count = productListResponseDTO.count;
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

  Future<Map<String, dynamic>> _makeRequestData() async {
    final pref = await SharedPreferencesManager.getInstance();
    final mtIdx = pref.getMtIdx() ?? "";

    String subCategory = "all";
    final categoryData = _categories[_tabController.index];
    if ((categoryData.ctIdx ?? 0) > 0) {
      subCategory = categoryData.ctIdx.toString();
    }

    int sort = 1;
    // 1 최신순 2 인기순 3: 추천수, 4: 가격 낮은수, 5: 가격 높은수
    switch (_sortOptionSelected) {
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

    String age = '${selectedAgeGroup?.catIdx ?? ""}';

    String styles = '';
    List<int> stylesList = [];
    // 없을시 빈값으로 전달해주세요 1 캐주얼, 2 스포티 3: 포멀/클래식, 4:베이직 5:프린세스/페어리 6: 힙스터 7:럭셔리 8: 어반 스트릿 9: 로맨틱 -> ex) [1, 2]
    for (var style in selectedStyles) {
      stylesList.add(style.fsIdx ?? 0);
    }
    if(stylesList.isNotEmpty) {
      styles = json.encode(stylesList);
    }

    int minPrice = selectedRangeValues.start.toInt();
    int maxPrice = selectedRangeValues.end.toInt();

    Map<String, dynamic> requestData = {
      'mt_idx': mtIdx,
      'category': _selectedCategory.ctIdx,
      'sub_category': subCategory,
      'sort': sort,
      'age': age,
      'styles': styles,
      'min_price': minPrice,
      'max_price': maxPrice,
      'pg': _page,
      'delivery_now' : _isTodayStart ? "Y" : "",
    };

    return requestData;
  }

  void _getFilterCategory() async {
    final categoryResponseDTO = await ref.read(productListViewModelProvider.notifier).getAgeCategory();
    _ageCategories = categoryResponseDTO?.list ?? [];

    final styleCategoryResponseDTO = await ref.read(productListViewModelProvider.notifier).getStyleCategory();
    _styleCategories = styleCategoryResponseDTO?.list ?? [];
  }

  String getSelectedAgeGroupText() {
    return selectedAgeGroup?.catName ?? '연령';
  }

  String getSelectedStyleText() {
    if (selectedStyles.isEmpty) {
      return '스타일';
    } else {
      String styleStr = '스타일 ${selectedStyles.length}';
      return styleStr;
    }
  }

  String getSelectedRangeValues() {
    // 초기 값인지 확인하여 '가격'이라는 기본값 반환
    if (selectedRangeValues == const RangeValues(0, 100000)) {
      return '가격';
    } else {
      return '${selectedRangeValues.start.toInt()}원 ~ ${selectedRangeValues.end.toInt()}원';
    }
  }

  void _openSortBottomSheet() {
    showModalBottomSheet(
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(12.0)),
      ),
      context: context,
      builder: (context) {
        return SafeArea(
          child: ProductSortBottom(
            sortOption: _sortOption,
            onSortOptionSelected: (selectedOption) {
              setState(() {
                _sortOptionSelected = selectedOption;
                _sortOption = selectedOption; // 선택된 정렬 옵션으로 업데이트
                _getList();
              });
            },
          ),
        );
      },
    );
  }

  void _openCategoryBottomSheet() {
    showModalBottomSheet(
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(12.0)),
      ),
      context: context,
      builder: (context) {
        return SafeArea(
          child: ProductCategoryBottom(
            selectedCategory: _selectedCategory,
            onCategorySelected: (category) {
              setState(() {
                _selectedCategory = category;
                _categories = _selectedCategory.subList ?? [];
                _tabController.removeListener(_tabChangeCallBack);
                _tabController = TabController(length: _categories.length, vsync: this);
                _tabController.addListener(_tabChangeCallBack);
                _getList();
              });
            },
          ),
        );
      },
    );
  }

  void _openFilterBottomSheet(bool isMoveBottom) {
    showModalBottomSheet(
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(12.0)),
      ),
      context: context,
      isScrollControlled: true,
      constraints: const BoxConstraints(maxHeight: 700, minHeight: 400),
      backgroundColor: Colors.white,
      builder: (BuildContext context) {
        return SafeArea(
          child: ProductFilterBottom(
            isMoveBottom: isMoveBottom,
            ageCategories: _ageCategories,
            styleCategories: _styleCategories,
            selectedStyleOption: selectedStyles,
            selectedAgeOption: selectedAgeGroup,
            selectedRangeValuesOption: selectedRangeValues,
            onValueSelected: (Map<String, dynamic> selectedValue) {
              setState(() {
                selectedAgeGroup = selectedValue['age'];
                selectedStyles = selectedValue['style'];
                selectedRangeValues = selectedValue['range'];
                _getList();
              });
            },
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        scrolledUnderElevation: 0,
        backgroundColor: Colors.white,
        leading: IconButton(
          icon: SvgPicture.asset("assets/images/product/ic_back.svg"),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
        titleSpacing: -1.0,
        title: InkWell(
          onTap: _openCategoryBottomSheet, // Open the bottom sheet on tap
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                margin: const EdgeInsets.only(right: 8),
                child: Text(
                  _selectedCategory.ctName ?? "",
                  style: TextStyle(
                    fontFamily: 'Pretendard',
                    fontWeight: FontWeight.bold,
                    fontSize: Responsive.getFont(context, 18),
                    height: 1.2,
                  ),
                ),
              ),
              SvgPicture.asset(
                'assets/images/product/ic_select.svg',
                colorFilter: const ColorFilter.mode(
                  Colors.black,
                  BlendMode.srcIn,
                ),
              ),
            ],
          ),
        ),
        centerTitle: true,
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(1.0), // 하단 구분선의 높이 설정
          child: Container(
            color: const Color(0x0D000000), // 하단 구분선 색상
            height: 1.0, // 구분선의 두께 설정
            child: Container(
              height: 1.0, // 그림자 부분의 높이
              decoration: const BoxDecoration(
                boxShadow: [
                  BoxShadow(
                    color: Color(0x0D000000),
                    blurRadius: 6.0,
                    spreadRadius: 0.1,
                    offset: Offset(0, 3),
                  ),
                ],
              ),
            ),
          ),
        ),
        actions: [
          IconButton(
            icon: SvgPicture.asset("assets/images/product/ic_top_sch.svg",
              height: Responsive.getHeight(context, 30),
              width: Responsive.getWidth(context, 30),
            ),
            color: Colors.black,
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const SearchScreen()),
              );
            },
          ),
          const TopCartButton(),
        ],
      ),
      body: SafeArea(
        child: Stack(
          children: [
            NotificationListener(
              onNotification: (scrollNotification){
                if (scrollNotification is ScrollEndNotification) {
                  var metrics = scrollNotification.metrics;
                  if (metrics.axisDirection != AxisDirection.down) return false;
                  if (_maxScrollHeight < metrics.maxScrollExtent) {
                    _maxScrollHeight = metrics.maxScrollExtent;
                  }
                  if (_maxScrollHeight - metrics.pixels < 50) {
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
                              tabs: (_categories).map((subCategory) {
                                return Tab(text: subCategory.ctName);
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
                                  onTap: () {
                                    setState(() {
                                      _isTodayStart = !_isTodayStart;
                                      _getList();
                                    });
                                  },
                                  child: Row(
                                    children: [
                                      Container(
                                        margin: const EdgeInsets.only(right: 10),
                                        padding: const EdgeInsets.all(6),
                                        height: 22,
                                        width: 22,
                                        decoration: BoxDecoration(
                                          borderRadius: const BorderRadius.all(Radius.circular(6)),
                                          border: Border.all(
                                            color: _isTodayStart ? const Color(0xFFFF6191) : const Color(0xFFCCCCCC),
                                          ),
                                          color: _isTodayStart ? const Color(0xFFFF6191) : Colors.white,
                                        ),
                                        child: SvgPicture.asset(
                                          'assets/images/check01_off.svg', // 체크박스 아이콘
                                          colorFilter: ColorFilter.mode(
                                            _isTodayStart ? Colors.white : const Color(0xFFCCCCCC),
                                            BlendMode.srcIn,
                                          ),
                                          height: 10,
                                          width: 10,
                                          fit: BoxFit.contain,
                                        ),
                                      ),
                                      Image.asset(
                                        'assets/images/product/today_start.png',
                                        width: 70,
                                        height: 18,
                                        fit: BoxFit.cover,
                                      )
                                    ],
                                  ),
                                ),
                                const SizedBox(width: 20),
                                Expanded(
                                  flex: 1,
                                  child: SingleChildScrollView(
                                    scrollDirection: Axis.horizontal,
                                    child: Row(
                                      children: [
                                        Visibility(
                                          visible: _selectedCategory.ctName == "악세서리" ? false : true,
                                          child: _buildFilterButton(getSelectedAgeGroupText(), false),
                                        ),
                                        Container(
                                          margin: const EdgeInsets.symmetric(horizontal: 4),
                                          child: _buildFilterButton(getSelectedStyleText(), false),
                                        ),
                                        _buildFilterButton(getSelectedRangeValues(), true),
                                      ],
                                    ),
                                  ),
                                )
                              ],
                            ),
                          )
                        ],
                      ), // 상단 고정된 컨텐츠
                    )
                  ];
                },
                body: TabBarView(
                  controller: _tabController,
                  physics: const NeverScrollableScrollPhysics(),
                  children: List.generate(
                    _categories.length,
                        (index) {
                      // 상품 리스트
                      if (index == _tabController.index) {
                        return _buildProductGrid();
                      } else {
                        return Container();
                      }
                    },
                  ),
                ),
              ),
            ),
            Visibility(
              visible: _productList.isNotEmpty,
              child: MoveTopButton(scrollController: _scrollController)
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildFilterButton(String label, bool isMoveBottom) {
    return OutlinedButton(
      style: OutlinedButton.styleFrom(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(19.0),
        ),
        side: const BorderSide(
          color: Color(0xFFDDDDDD),
        ),
        padding: const EdgeInsets.only(top: 11.0, bottom: 11, left: 20.0, right: 17),
      ),
      onPressed: () {
        _openFilterBottomSheet(isMoveBottom);
      },
      child: Row(
        children: [
          Container(
            margin: const EdgeInsets.only(right: 5),
            child: Text(
              label,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: TextStyle(
                fontFamily: 'Pretendard',
                color: Colors.black,
                fontSize: Responsive.getFont(context, 14),
                height: 1.2,
              ),
            ),
          ),
          SvgPicture.asset('assets/images/product/filter_select.svg'),
        ],
      ),
    );
  }

  Widget _buildProductGrid() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          margin: const EdgeInsets.symmetric(horizontal: 16.0),
          padding: const EdgeInsets.only(bottom: 20),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                '상품 $_count', // 상품 수 표시
                style: const TextStyle(
                  fontFamily: 'Pretendard',
                  fontSize: 14,
                  color: Colors.black,
                  height: 1.2,
                ),
              ),
              GestureDetector(
                onTap: _openSortBottomSheet, // 정렬 옵션 선택 창 열기
                child: Row(
                  children: [
                    SvgPicture.asset('assets/images/product/ic_filter02.svg'),
                    Container(
                      margin: const EdgeInsets.only(left: 5),
                      child: Text(
                        _sortOptionSelected.isNotEmpty ? _sortOptionSelected : '최신순', // 선택된 정렬 옵션 표시
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
            ],
          ),
        ),
        Expanded(
          child: Stack(
            children: [
              Visibility(
                visible: _productList.isEmpty,
                child: const NonDataScreen(text: '등록된 상품이 없습니다.',),
              ),
              Visibility(
                visible: _productList.isNotEmpty,
                child: GridView.builder(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  padding: const EdgeInsets.symmetric(horizontal: 16.0),
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2,
                    childAspectRatio: 0.5,
                    crossAxisSpacing: 12,
                    mainAxisSpacing: 30,
                  ),
                  itemCount: _productList.length, // 실제 상품 수로 변경
                  itemBuilder: (context, index) {
                    return ProductListCard(
                      productData: _productList[index],
                    );
                  },
                ),
              )
            ],
          )
        ),
      ],
    );
  }
}
