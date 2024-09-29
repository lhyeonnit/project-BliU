import 'package:BliU/data/category_data.dart';
import 'package:BliU/data/product_data.dart';
import 'package:BliU/dto/product_list_response_dto.dart';
import 'package:BliU/screen/_component/cart_screen.dart';
import 'package:BliU/screen/_component/search_screen.dart';
import 'package:BliU/screen/product/viewmodel/product_list_view_model.dart';
import 'package:BliU/utils/responsive.dart';
import 'package:BliU/utils/shared_preferences_manager.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'component/list/product_filter_bottom.dart';
import 'component/list/product_list_card.dart';
import 'component/list/product_category_bottom.dart';
import 'component/list/product_sort_bottom.dart';

class ProductListScreen extends ConsumerStatefulWidget {
  final CategoryData selectedCategory;
  final int? selectSubCategoryIndex;

  const ProductListScreen(
      {super.key, required this.selectedCategory, this.selectSubCategoryIndex});

  @override
  _ProductListScreenState createState() => _ProductListScreenState();
}

class _ProductListScreenState extends ConsumerState<ProductListScreen>
    with TickerProviderStateMixin {
  late TabController _tabController;
  late CategoryData _selectedCategory;
  late List<CategoryData> _subList;
  String sortOption = '인기순';
  String sortOptionSelected = '';
  List<ProductListResponseDTO?> productList = [];

  @override
  void initState() {
    super.initState();
    _selectedCategory = widget.selectedCategory;
    _subList = _selectedCategory.subList ?? [];
    _tabController = TabController(length: _subList.length, vsync: this);
    if (widget.selectSubCategoryIndex != null) {
      _tabController.animateTo(widget.selectSubCategoryIndex ?? 0);
    }
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _afterBuild(context);
    });
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  String selectedAgeGroup = '';
  List<String> selectedStyles = [];
  RangeValues selectedRangeValues = const RangeValues(0, 100000);

  String getSelectedAgeGroupText() {
    if (selectedAgeGroup.isEmpty) {
      return '연령';
    } else {
      return selectedAgeGroup;
    }
  }

  String getSelectedStyleText() {
    if (selectedStyles.isEmpty) {
      return '스타일';
    } else {
      return selectedStyles.join(', ');
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

  void _openCategoryBottomSheet() {
    showModalBottomSheet(
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(12.0)),
      ),
      context: context,
      builder: (context) {
        return ProductCategoryBottom(
          onCategorySelected: (category) {
            setState(() {
              _selectedCategory = category;
              _subList = _selectedCategory.subList ?? [];
              _tabController =
                  TabController(length: _subList.length, vsync: this);
              _getAllList();
            });
          },
        );
      },
    );
  }

  void _openFilterBottomSheet() {
    showModalBottomSheet(
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(12.0)),
      ),
      context: context,
      isScrollControlled: true,
      constraints: const BoxConstraints(maxHeight: 700, minHeight: 400),
      backgroundColor: Colors.white,
      builder: (BuildContext context) {
        return ProductFilterBottom(
          selectedStyleOption: selectedStyles,
          selectedAgeOption: selectedAgeGroup,
          selectedRangeValuesOption: selectedRangeValues!,
          onAgeOptionSelected: (String newSelectedAge) {
            setState(() {
              selectedAgeGroup = newSelectedAge;
            });
          },
          onStyleOptionSelected: (List<String> newSelectedStyle) {
            setState(() {
              selectedStyles = newSelectedStyle;
            });
          },
          onRangeValuesSelected: (RangeValues newSelectedRangeValues) {
            setState(() {
              selectedRangeValues = newSelectedRangeValues;
            });
          },
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
              SvgPicture.asset('assets/images/product/ic_select.svg',
                  color: Colors.black),
            ],
          ),
        ),
        centerTitle: true,
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(1.0), // 하단 구분선의 높이 설정
          child: Container(
            color: const Color(0xFFF4F4F4), // 하단 구분선 색상
            height: 1.0, // 구분선의 두께 설정
            child: Container(
              height: 1.0, // 그림자 부분의 높이
              decoration: const BoxDecoration(
                boxShadow: [
                  BoxShadow(
                    color: Color(0xFFF4F4F4),
                    blurRadius: 6.0,
                    spreadRadius: 1.0,
                  ),
                ],
              ),
            ),
          ),
        ),
        actions: [
          GestureDetector(
            child: SvgPicture.asset("assets/images/product/ic_top_sch.svg"),
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const SearchScreen()),
              );
            },
          ),
          Container(
            margin: const EdgeInsets.only(right: 6),
            child: Stack(
              children: [
                IconButton(
                  icon: SvgPicture.asset(
                    "assets/images/product/ic_cart.svg",
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
                  right: 4,
                  top: 20,
                  child: Container(
                    padding: const EdgeInsets.all(4),
                    decoration: const BoxDecoration(
                      color: Colors.pinkAccent,
                      shape: BoxShape.circle,
                    ),
                    child: const Text(
                      '2',
                      style: TextStyle(
                        fontFamily: 'Pretendard',
                        color: Colors.white,
                        fontSize: 12,
                        height: 1.2,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
      body: NestedScrollView(
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
                      tabs: (_subList ?? []).map((subCategory) {
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
                          onTap: _openSortBottomSheet, // 정렬 옵션 선택 창 열기
                          child: Row(
                            children: [
                              SvgPicture.asset(
                                  'assets/images/product/ic_filter02.svg'),
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
                        Row(
                          children: [
                            _buildFilterButton(getSelectedAgeGroupText()),
                            Container(
                              margin: const EdgeInsets.symmetric(horizontal: 4),
                              child: _buildFilterButton(getSelectedStyleText())
                            ),
                            _buildFilterButton(getSelectedRangeValues()),
                          ],
                        ),
                      ],
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
            _subList.length,
            (index) {
              // 상품 리스트
              return _buildProductGrid(index);
            },
          ),
        ),
      ),
    );
  }

  void _afterBuild(BuildContext context) {
    _getAllList();
  }

  void _getAllList() async {
    // TODO 회원 비회원 처리
    final pref = await SharedPreferencesManager.getInstance();
    final mtIdx = pref.getMtIdx();

    // TODO 정렬 및 검색 결과 파라매터 넣어야 함
    for (int i = 0; i < _subList.length; i++) {
      Map<String, dynamic> requestData = {
        'mt_idx': mtIdx,
        'category': _selectedCategory.ctIdx,
        'sub_category': _subList[i].ctIdx,
        'sort': 1,
        'age': 1,
        'styles': '',
        'min_price': 0,
        'max_price': 99999,
        'pg': 1,
      };

      final productListResponseDTO = await ref
          .read(productListViewModelProvider.notifier)
          .getList(requestData);
      if (productListResponseDTO != null) {
        if (productListResponseDTO.result == true) {
          productList.add(productListResponseDTO);
        } else {
          productList.add(null);
        }
      } else {
        productList.add(null);
      }
    }
    setState(() {});
  }

  Widget _buildFilterButton(String label) {
    return OutlinedButton(
      style: OutlinedButton.styleFrom(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(22.0),
        ),
        side: const BorderSide(
          color: Color(0xFFDDDDDD),
        ),
        padding:
            const EdgeInsets.only(top: 11.0, bottom: 11, left: 15.0, right: 12),
      ),
      onPressed: _openFilterBottomSheet,
      child: Row(
        children: [
          Container(
            width: 28,
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

  Widget _buildProductGrid(int productIndex) {
    List<ProductData> pList = [];
    int count = 0;
    try {
      pList = productList[productIndex]?.list ?? [];
      count = productList[productIndex]?.count ?? 0;
    } catch (e) {
      print("e = ${e.toString()}");
    }
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          margin: const EdgeInsets.symmetric(horizontal: 16.0),
          padding: const EdgeInsets.only(bottom: 20),
          child: Text(
            '상품 $count', // 상품 수 표시
            style: const TextStyle(
              fontFamily: 'Pretendard',
              fontSize: 14,
              color: Colors.black,
              height: 1.2,
            ),
          ),
        ),
        Expanded(
          child: GridView.builder(
            padding: const EdgeInsets.symmetric(horizontal: 16.0),
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2,
              childAspectRatio: 0.55,
              crossAxisSpacing: 12,
              mainAxisSpacing: 30,
            ),
            itemCount: pList.length, // 실제 상품 수로 변경
            itemBuilder: (context, index) {
              return ProductListCard(
                productData: pList[index],
              );
            },
          ),
        ),
      ],
    );
  }
}

class FilterOption {
  final String label;

  FilterOption({required this.label});
}

List<FilterOption> ageOptions = [
  FilterOption(label: '베이비(0-24개월)'),
  FilterOption(label: '키즈(3-8세)'),
  FilterOption(label: '주니어(9세 이상)'),
];
