import 'package:BliU/data/category_data.dart';
import 'package:BliU/screen/_component/cart_screen.dart';
import 'package:BliU/screen/_component/search_screen.dart';
import 'package:BliU/utils/responsive.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'component/list/product_filter_bottom.dart';
import 'component/list/product_list_card.dart';
import 'component/list/product_category_bottom.dart';
import 'component/list/product_sort_bottom.dart';

class ProductListScreen extends ConsumerStatefulWidget {
  final CategoryData selectedCategory;
  final List<CategoryData>? subList;

  const ProductListScreen(
      {super.key, required this.selectedCategory, this.subList});

  @override
  _ProductListScreenState createState() => _ProductListScreenState();
}

final List<Map<String, String>> items = [
  {
    'image': 'http://example.com/item1.png',
    'name': '꿈꾸는데이지 안나 토션 레이스 베스트',
    'brand': '꿈꾸는데이지',
    'price': '32,800원',
    'discount': '15%',
    'likes': '13,000',
    'comments': '49'
  },
  {
    'image': 'http://example.com/item2.png',
    'name': '레인보우꿈 안나 토션 레이스 베스트',
    'brand': '레인보우꿈',
    'price': '32,800원',
    'discount': '15%',
    'likes': '13,000',
    'comments': '49'
  },
  {
    'image': 'http://example.com/item3.png',
    'name': '기글옷장 안나 토션 레이스 베스트',
    'brand': '기글옷장',
    'price': '32,800원',
    'discount': '15%',
    'likes': '13,000',
    'comments': '49'
  },
  {
    'image': 'http://example.com/item4.png',
    'name': '스파클나라 안나 토션 레이스 베스트',
    'brand': '스파클나라',
    'price': '32,800원',
    'discount': '15%',
    'likes': '13,000',
    'comments': '49'
  },
];

class FilterOption {
  final String label;

  FilterOption({required this.label});
}

List<FilterOption> ageOptions = [
  FilterOption(label: '베이비(0-24개월)'),
  FilterOption(label: '키즈(3-8세)'),
  FilterOption(label: '주니어(9세 이상)'),
];

List<FilterOption> styleOptions = [
  FilterOption(label: '캐주얼'),
  FilterOption(label: '스포티'),
  FilterOption(label: '포멀/클래식'),
  FilterOption(label: '베이직'),
  FilterOption(label: '프린세스/페어리'),
  FilterOption(label: '힙스터'),
  FilterOption(label: '럭셔리'),
  FilterOption(label: '어반 스트릿'),
  FilterOption(label: '로맨틱'),
];

// TODO 상위 카테고리일시 하위카테고리까지 리스트업
// TODO 하위 카테고리일시 확인 필요

class _ProductListScreenState extends ConsumerState<ProductListScreen>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;
  CategoryData? _selectedCategory;
  List<CategoryData>? _subList;
  String sortOption = '최신순';
  String sortOptionSelected = '';

  List<String> selectedAgeOption = [];
  List<String> selectedStyleOption = [];

  @override
  void initState() {
    super.initState();
    _selectedCategory = widget.selectedCategory;
    _subList = widget.subList;
    _tabController = TabController(length: 5, vsync: this);
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

  void _openCategoryBottomSheet() {
    showModalBottomSheet(
      context: context,
      builder: (context) {
        return ProductCategoryBottom(
          onCategorySelected: (category) {
            setState(() {
              _selectedCategory = category;
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
        title: InkWell(
          onTap: _openCategoryBottomSheet, // Open the bottom sheet on tap
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                margin: EdgeInsets.only(right: 8),
                child: Text(
                  _selectedCategory?.ctName ?? "",
                  style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: Responsive.getFont(context, 18)),
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
            margin: EdgeInsets.symmetric(horizontal: 16),
            child: Stack(
              children: [
                GestureDetector(
                  child: SvgPicture.asset("assets/images/product/ic_cart.svg"),
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => const CartScreen()),
                    );
                  },
                ),
                Positioned(
                  right: 0,
                  top: 12,
                  child: Container(
                    padding: const EdgeInsets.all(4),
                    decoration: const BoxDecoration(
                      color: Colors.pinkAccent,
                      shape: BoxShape.circle,
                    ),
                    child: const Text(
                      '2',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 12,
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
                        fontSize: Responsive.getFont(context, 14),
                        fontWeight: FontWeight.w600,
                      ),
                      overlayColor: WidgetStateColor.transparent,
                      indicatorColor: Colors.black,
                      indicatorSize: TabBarIndicatorSize.tab,
                      labelColor: Colors.black,
                      unselectedLabelColor: const Color(0xFF7B7B7B),
                      isScrollable: true,
                      indicatorWeight: 2.0,
                      tabAlignment: TabAlignment.start,
                      padding: const EdgeInsets.symmetric(horizontal: 12),
                      tabs: widget.subList!.map((subCategory) {
                        return Tab(text: subCategory.ctName);
                      }).toList(),
                    ),
                  ),
                  Container(
                    margin: const EdgeInsets.symmetric(
                        horizontal: 16.0),
                    padding: EdgeInsets.only(top: 15, bottom: 10),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        GestureDetector(
                          onTap: _openSortBottomSheet, // 정렬 옵션 선택 창 열기
                          child: Row(
                            children: [
                              SvgPicture.asset('assets/images/product/ic_filter02.svg'),
                              Container(
                                margin: EdgeInsets.only(left: 5),
                                child: Text(
                                  sortOptionSelected.isNotEmpty
                                      ? sortOptionSelected
                                      : '최신순', // 선택된 정렬 옵션 표시
                                  style: TextStyle(fontSize: Responsive.getFont(context, 14)),
                                ),
                              ),
                            ],
                          ),
                        ),
                        Row(
                          children: [
                            _buildFilterButton(context, '연령'),
                            Container(
                                margin: EdgeInsets.symmetric(horizontal: 4),
                                child: _buildFilterButton(context, '스타일')),
                            _buildFilterButton(context, '가격'),
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
            widget.subList!.length,
            (index) {
              // 상품 리스트
              return _buildProductGrid();
            },
          ),
        ),
      ),
    );
  }

  Widget _buildFilterButton(BuildContext context, String label) {
    return OutlinedButton(
      style: OutlinedButton.styleFrom(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(19.0),
        ),
        side: BorderSide(
          color: Color(0xFFDDDDDD),
        ),
        padding: EdgeInsets.only(top: 11.0, bottom: 11,left: 20.0, right: 17),
      ),
      onPressed: () {
        ProductFilterBottom.show(
          context,
          ageOptions: ageOptions.map((option) => option.label).toList(),
          styleOptions: styleOptions.map((option) => option.label).toList(),
          selectedAgeOption: selectedAgeOption,
          selectedStyleOption: selectedStyleOption,
          onAgeOptionSelected: (String selectedAge) {
            setState(() {
              if (selectedAgeOption.contains(selectedAge)) {
                selectedAgeOption.remove(selectedAge); // 이미 선택된 경우 제거
              } else {
                selectedAgeOption.add(selectedAge); // 새로 선택된 경우 추가
              }
            });
          },
          onStyleOptionSelected: (String selectedStyle) {
            setState(() {
              if (selectedStyleOption.contains(selectedStyle)) {
                selectedStyleOption.remove(selectedStyle); // 이미 선택된 경우 제거
              } else {
                selectedStyleOption.add(selectedStyle); // 새로 선택된 경우 추가
              }
            });
          },
          onResetFilters: () {
            setState(() {
              selectedAgeOption.clear(); // 선택된 연령 필터 초기화
              selectedStyleOption.clear(); // 선택된 스타일 필터 초기화
            });
          },
          onApplyFilters: () {
            setState(() {
              // 선택된 필터 옵션을 적용하고, 필요에 따라 데이터를 다시 로드하거나 UI를 업데이트합니다.
            });
          },
        );
      },
      child: Row(
        children: [
          Container(
            margin: EdgeInsets.only(right: 5),
            child: Text(
              label,
              style: TextStyle(color: Colors.black, fontSize: Responsive.getFont(context, 14)),
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
          padding: EdgeInsets.only(bottom: 20),
          child: Text(
            '상품 ${items.length}', // 상품 수 표시
            style: const TextStyle(fontSize: 14, color: Colors.black),
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
            itemCount: items.length, // 실제 상품 수로 변경
            itemBuilder: (context, index) {
              return ProductListCard(
                item: items[index],
                index: index,
              );
            },
          ),
        ),
      ],
    );
  }
}
