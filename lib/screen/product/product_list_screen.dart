
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

import '../_component/cart_screen.dart';
import '../_component/search_screen.dart';
import 'component/list/product_filter_bottom.dart';
import 'component/list/product_list_card.dart';
import 'component/list/product_category_bottom.dart';
import 'component/list/product_sort_bottom.dart';


class ProductListScreen extends StatefulWidget {
  const ProductListScreen({super.key});

  @override
  _ProductListScreenState createState() => _ProductListScreenState();
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

class _ProductListScreenState extends State<ProductListScreen>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;
  String _selectedCategory = '아우터';
  String sortOption = '최신순';
  String sortOptionSelected = '';

  List<String> selectedAgeOption = [];
  List<String> selectedStyleOption = [];

  @override
  void initState() {
    super.initState();
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
            Navigator.pop(context); // Close the bottom sheet
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
              Text(
                _selectedCategory,
                style: const TextStyle(color: Colors.black),
              ),
              const Icon(Icons.expand_more, color: Colors.black),
            ],
          ),
        ),
        centerTitle: true,
        actions: [
          IconButton(
            icon: SvgPicture.asset("assets/images/product/ic_top_sch.svg"),
            color: Colors.black,
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const SearchScreen()),
              );
            },
          ),
          Stack(
            children: [
              IconButton(
                icon: SvgPicture.asset("assets/images/product/ic_cart.svg"),
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => const CartScreen()),
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
                      color: Colors.white,
                      fontSize: 12,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ],
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(50.0), // TabBar 높이 조정
          child: Column(
            children: [
              Container(
                decoration: BoxDecoration(
                  boxShadow: [
                    BoxShadow(
                      color: Colors.grey.withOpacity(0.1), // 그림자 색상 조정
                      spreadRadius: 1, // 그림자가 확산되는 반경
                      blurRadius: 5, // 그림자 블러 처리
                      offset: const Offset(0, 3), // 그림자가 생기는 위치
                    ),
                  ],
                ),
                child: Divider(
                  height: 1,
                  thickness: 1,
                  color: Colors.grey[300], // 구분선 색상 조정
                ),
              ),
              TabBar(
                controller: _tabController,
                labelColor: Colors.black,
                unselectedLabelColor: Colors.grey,
                indicatorColor: Colors.black,
                tabAlignment: TabAlignment.start,
                tabs: const [
                  Tab(text: '전체'),
                  Tab(text: '자켓'),
                  Tab(text: '가디건/베스트'),
                  Tab(text: '코트'),
                  Tab(text: '후드집업'),
                ],
              ),
            ],
          ),
        ),
      ),
      body: Column(children: [
        // Filter buttons and product count
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              GestureDetector(
                onTap: _openSortBottomSheet, // 정렬 옵션 선택 창 열기
                child: Row(
                  children: [
                    const Icon(Icons.swap_vert, size: 20),
                    const SizedBox(width: 4),
                    Text(
                      sortOptionSelected.isNotEmpty
                          ? sortOptionSelected
                          : '최신순', // 선택된 정렬 옵션 표시
                      style: const TextStyle(fontSize: 16),
                    ),
                  ],
                ),
              ),
              Row(
                children: [
                  _buildFilterButton(context, '연령'),
                  const SizedBox(width: 8), // 간격 추가
                  _buildFilterButton(context, '스타일'),
                  const SizedBox(width: 8), // 간격 추가
                  _buildFilterButton(context, '가격'),
                ],
              ),
            ],
          ),
        ),
        Expanded(
          child: TabBarView(
            controller: _tabController,
            children: [
              _buildProductGrid(10), // 전체 상품 수로 설정
              _buildProductGrid(10), // 자켓 상품 수로 설정
              _buildProductGrid(10), // 가디건/베스트 상품 수로 설정
              _buildProductGrid(10), // 코트 상품 수로 설정
              _buildProductGrid(10), // 후드집업 상품 수로 설정
            ],
          ),
        ),
      ]),
    );
  }

  Widget _buildFilterButton(BuildContext context, String label) {
    return OutlinedButton(
      style: OutlinedButton.styleFrom(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20.0),
        ),
        side: const BorderSide(
          color: Colors.grey,
        ),
        padding: const EdgeInsets.symmetric(vertical: 10.0, horizontal: 15.0),
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
            Navigator.pop(context); // 필터 적용 후 모달을 닫습니다.
          },
        );
      },
      child: Row(
        children: [
          Text(
            label,
            style: const TextStyle(color: Colors.black),
          ),
          const Icon(
            Icons.arrow_drop_down,
            color: Colors.black,
          ),
        ],
      ),
    );
  }


  Widget _buildProductGrid(int productCount) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16.0),
          // Padding for consistency
          child: Text(
            '상품 $productCount', // 상품 수 표시
            style: const TextStyle(fontSize: 14, color: Colors.black),
          ),
        ),
        Expanded(
          child: GridView.builder(
            padding: const EdgeInsets.all(8.0),
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2, // 두 개의 열
              crossAxisSpacing: 8.0,
              mainAxisSpacing: 8.0,
              childAspectRatio: 0.6, // 아이템의 가로세로 비율
            ),
            itemCount: productCount, // 실제 상품 수로 변경
            itemBuilder: (context, index) {
              return const ProductListCard();
            },
          ),
        ),
      ],
    );
  }
}
