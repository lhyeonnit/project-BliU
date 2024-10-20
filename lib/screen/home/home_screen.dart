import 'package:BliU/data/category_data.dart';
import 'package:BliU/data/product_data.dart';
import 'package:BliU/screen/_component/cart_screen.dart';
import 'package:BliU/screen/_component/move_top_button.dart';
import 'package:BliU/screen/_component/search_screen.dart';
import 'package:BliU/screen/_component/smart_lens_screen.dart';
import 'package:BliU/screen/home/component/home_body_ai.dart';
import 'package:BliU/screen/home/component/home_body_category.dart';
import 'package:BliU/screen/home/component/home_body_exhibition.dart';
import 'package:BliU/screen/home/component/home_footer.dart';
import 'package:BliU/screen/home/component/home_header.dart';
import 'package:BliU/screen/home/viewmodel/home_view_model.dart';
import 'package:BliU/screen/product/component/list/product_list_card.dart';
import 'package:BliU/screen/store/component/store_age_group_selection.dart';
import 'package:BliU/utils/responsive.dart';
import 'package:BliU/utils/shared_preferences_manager.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_svg/flutter_svg.dart';

class HomeScreen extends ConsumerStatefulWidget {
  const HomeScreen({super.key});

  @override
  ConsumerState<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends ConsumerState<HomeScreen> {
  final ScrollController _scrollController = ScrollController();
  String _cartCount = "0";
  List<CategoryData> _categories = [];
  List<CategoryData> _ageCategories = [];
  bool _isScrolled = false;

  CategoryData? _selectedAgeGroup;
  int _selectedCategoryIndex = 0;
  final List<CategoryData> _productCategories = [
    CategoryData(ctIdx: 0, cstIdx: 0, img: '', ctName: '전체', catIdx: 0, catName: '', subList: [])
  ];
  List<ProductData> _productList = [];

  int _page = 1;
  bool _hasNextPage = true;
  bool _isFirstLoadRunning = false;
  bool _isLoadMoreRunning = false;

  @override
  void initState() {
    super.initState();
    _scrollController.addListener(() {
      if (_scrollController.offset > 50 && !_isScrolled) {
        setState(() {
          _isScrolled = true;
        });
      } else if (_scrollController.offset <= 50 && _isScrolled) {
        setState(() {
          _isScrolled = false;
        });
      }

      if (_scrollController.position.maxScrollExtent - _scrollController.offset < 100) {
        _nextLoad();
      }

    });
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _afterBuild(context);
    });
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  void _afterBuild(BuildContext context) {
    _getCategoryList();
    _getCartCount();
    _getList();
  }

  void _getCategoryList() async {
    Map<String, dynamic> requestData = {'category_type': '2'};
    final categoryResponseDTO = await ref.read(homeViewModelProvider.notifier).getCategory(requestData);
    final ageCategoryResponseDTO = await ref.read(homeViewModelProvider.notifier).getAgeCategory();
    setState(() {
      _categories = categoryResponseDTO?.list ?? [];
      _ageCategories = ageCategoryResponseDTO?.list ?? [];
      _productCategories.addAll(_categories);
    });
  }

  void _getCartCount() async {
    final pref = await SharedPreferencesManager.getInstance();
    final mtIdx = pref.getMtIdx() ?? "";
    int type = 1;
    if (mtIdx.isEmpty) {
      type = 2;
    }

    Map<String, dynamic> requestData = {
      'type': type,
      'mt_idx': mtIdx,
      'temp_mt_id': pref.getToken(),
    };

    _cartCount = await ref.read(homeViewModelProvider.notifier).getCartCount(requestData) ?? "0";
    setState(() {});
  }

  void _getList() async {
    setState(() {
      _isFirstLoadRunning = true;
    });
    _page = 1;
    _hasNextPage = true;

    final requestData = await _makeRequestData();

    final productListResponseDTO = await ref.read(homeViewModelProvider.notifier).getList(requestData);
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

      final productListResponseDTO = await ref.read(homeViewModelProvider.notifier).getList(requestData);
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

  Future<Map<String, dynamic>> _makeRequestData() async {
    final pref = await SharedPreferencesManager.getInstance();
    final mtIdx = pref.getMtIdx();

    final category = _productCategories[_selectedCategoryIndex];

    String categoryStr = "all";
    if (_selectedCategoryIndex > 0) {
      categoryStr = category.ctIdx.toString();
    }

    String ageStr = "all";
    if (_selectedAgeGroup != null) {
      ageStr = (_selectedAgeGroup?.catIdx ?? 0).toString();
    }

    Map<String, dynamic> requestData = {
      'mt_idx' : mtIdx ?? "",
      'category' : categoryStr,
      'age' : ageStr,
      'pg': _page
    };

    return requestData;
  }

  void _showAgeGroupSelection() {
    showModalBottomSheet(
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(12.0)),
      ),
      context: context,
      backgroundColor: Colors.white,
      builder: (BuildContext context) {
        return StoreAgeGroupSelection(
          ageCategories: _ageCategories,
          selectedAgeGroup: _selectedAgeGroup,
          onSelectionChanged: (CategoryData? newSelection) {
            setState(() {
              _selectedAgeGroup = newSelection;
            });
            _getList();
          },
        );
      },
    );
  }

  String getSelectedAgeGroupText() {
    if (_selectedAgeGroup == null) {
      return '연령';
    } else {
      return _selectedAgeGroup?.catName ?? "";
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Stack(
        children: [
          Column(
            children: [
              Expanded(
                child: CustomScrollView(
                  controller: _scrollController,
                  slivers: [
                    SliverAppBar(
                      scrolledUnderElevation: 0,
                      pinned: true,
                      automaticallyImplyLeading: false,
                      // 기본 뒤로가기 버튼을 숨김
                      backgroundColor: _isScrolled ? Colors.white : Colors.transparent,
                      expandedHeight: Responsive.getHeight(context, 625),
                      title: SvgPicture.asset(
                        'assets/images/home/bottom_home.svg', // SVG 파일 경로
                        colorFilter: ColorFilter.mode(
                          _isScrolled ? Colors.black : Colors.white,
                          BlendMode.srcIn,
                        ),
                        // 색상 조건부 변경
                        height: Responsive.getHeight(context, 40),
                      ),
                      flexibleSpace: const FlexibleSpaceBar(
                        background: HomeHeader(),
                      ),
                      actions: [
                        Container(
                          padding: EdgeInsets.only(right: Responsive.getWidth(context, 8)),
                          // 왼쪽 여백 추가
                          child: Row(
                            children: [
                              IconButton(
                                icon: SvgPicture.asset(
                                  "assets/images/home/ic_top_sch_w.svg",
                                  colorFilter: ColorFilter.mode(
                                    _isScrolled ? Colors.black : Colors.white,
                                    BlendMode.srcIn,
                                  ),
                                  height: Responsive.getHeight(context, 30),
                                  width: Responsive.getWidth(context, 30),
                                ),
                                onPressed: () {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) => const SearchScreen(),
                                    ),
                                  );
                                },
                              ),
                              IconButton(
                                icon: SvgPicture.asset(
                                  _isScrolled ? "assets/images/product/ic_smart.svg" : "assets/images/home/ic_smart_w.svg",
                                  height: Responsive.getHeight(context, 30),
                                  width: Responsive.getWidth(context, 30),
                                ),
                                onPressed: () {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) => const SmartLensScreen(),
                                    ),
                                  );
                                },
                              ),
                              Stack(
                                children: [
                                  IconButton(
                                    icon: SvgPicture.asset(
                                      "assets/images/product/ic_cart.svg",
                                      colorFilter: ColorFilter.mode(
                                        _isScrolled ? Colors.black : Colors.white,
                                        BlendMode.srcIn,
                                      ),
                                      height: Responsive.getHeight(context, 30),
                                      width: Responsive.getWidth(context, 30),
                                    ),
                                    onPressed: () {
                                      Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                          builder: (context) => const CartScreen(),
                                        ),
                                      );
                                    },
                                  ),
                                  Positioned(
                                    right: 5,
                                    top: 23,
                                    child: Visibility(
                                      visible: _cartCount == "0" ? false : true,
                                      child: Container(
                                        padding: const EdgeInsets.all(4),
                                        decoration: const BoxDecoration(
                                          color: Color(0xFFFF6191),
                                          shape: BoxShape.circle,
                                        ),
                                        child: Text(
                                          _cartCount,
                                          style: TextStyle(
                                            fontFamily: 'Pretendard',
                                            color: Colors.white,
                                            fontSize: Responsive.getFont(context, 9),
                                            height: 1.2,
                                          ),
                                        ),
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                    SliverList(
                      delegate: SliverChildListDelegate(
                        [
                          HomeBodyCategory(categories: _categories,),
                          const HomeBodyAi(),
                          const Padding(
                            padding: EdgeInsets.symmetric(vertical: 30.0),
                            child: SizedBox(
                              height: 451, // 고정된 높이
                              child: HomeBodyExhibition(),
                            ),
                          ),
                          //HomeBodyBestSales(categories: _categories, ageCategories: _ageCategories,),
                          Container(
                            padding: const EdgeInsets.only(left: 16.0),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  '판매베스트',
                                  style: TextStyle(
                                    fontFamily: 'Pretendard',
                                    fontSize: Responsive.getFont(context, 20),
                                    fontWeight: FontWeight.bold,
                                    height: 1.2,
                                  ),
                                ),
                                Container(
                                  margin: const EdgeInsets.only(top: 20),
                                  child: SingleChildScrollView(
                                    scrollDirection: Axis.horizontal,
                                    child: Row(
                                      children: List<Widget>.generate(_productCategories.length, (index) {
                                        return Container(
                                          padding: const EdgeInsets.only(right: 4.0),
                                          child: GestureDetector(
                                            onTap: () {
                                              setState(() {
                                                _selectedCategoryIndex = index;
                                              });
                                              _getList();
                                            },
                                            child: categoryTab(index),
                                          ),
                                        );
                                      }),
                                    ),
                                  ),
                                ),
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.end,
                                  children: [
                                    Container(
                                      margin: const EdgeInsets.only(top: 20.0),
                                      padding: const EdgeInsets.only(right: 16.0),
                                      child: GestureDetector(
                                        onTap: _showAgeGroupSelection,
                                        child: Container(
                                          padding: const EdgeInsets.fromLTRB(20, 11, 20, 11),
                                          decoration: BoxDecoration(
                                            color: Colors.white,
                                            shape: BoxShape.rectangle,
                                            borderRadius: BorderRadius.circular(22),
                                            border: Border.all(
                                              color: const Color(0xFFDDDDDD), // 테두리 색상
                                            ),
                                          ),
                                          child: Row(
                                            children: [
                                              Container(
                                                margin: const EdgeInsets.only(right: 5),
                                                child: Text(
                                                  getSelectedAgeGroupText(),
                                                  style: TextStyle(
                                                    fontFamily: 'Pretendard',
                                                    fontSize: Responsive.getFont(context, 14),
                                                    color: Colors.black,
                                                    height: 1.2,
                                                  ),
                                                ),
                                              ),
                                              SvgPicture.asset(
                                                "assets/images/product/filter_select.svg",
                                                width: 14,
                                                height: 14,
                                                fit: BoxFit.contain,
                                                alignment: Alignment.topCenter,
                                              )
                                            ],
                                          ),
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                                Container(
                                  margin: const EdgeInsets.only(right: 16, bottom: 29),
                                  child: GridView.builder(
                                    shrinkWrap: true,
                                    physics: const NeverScrollableScrollPhysics(),
                                    gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                                      crossAxisCount: 2,
                                      crossAxisSpacing: 12.0,
                                      mainAxisSpacing: 30.0,
                                      childAspectRatio: 0.5,
                                    ),
                                    itemCount: _productList.length,
                                    itemBuilder: (context, index) {
                                      final productData = _productList[index];
                                      return ProductListCard(productData: productData);
                                    },
                                  ),
                                ),
                              ],
                            ),
                          ),
                          const HomeFooter(),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          MoveTopButton(scrollController: _scrollController),
        ],
      ),
    );
  }

  Widget categoryTab(int index) {
    var borderColor = const Color(0xFFDDDDDD);
    var textColor = Colors.black;

    if (_selectedCategoryIndex == index) {
      borderColor = const Color(0xFFFF6192);
      textColor = const Color(0xFFFF6192);
    }

    return Container(
      padding: const EdgeInsets.fromLTRB(20, 11, 20, 11),
      decoration: BoxDecoration(
        color: Colors.white,
        shape: BoxShape.rectangle,
        borderRadius: BorderRadius.circular(200),
        border: Border.all(
          color: borderColor, // 테두리 색상
          width: 1.0,
        ),
      ),
      child: Text(
        _productCategories[index].ctName ?? "",
        style: TextStyle(
          fontFamily: 'Pretendard',
          fontSize: Responsive.getFont(context, 14),
          color: textColor,
          height: 1.2,
        ),
      ),
    );
  }
}
