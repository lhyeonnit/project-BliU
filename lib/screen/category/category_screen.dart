import 'package:BliU/screen/category/viewmodel/category_view_model.dart';
import 'package:BliU/screen/main_screen.dart';
import 'package:BliU/screen/product/product_list_screen.dart';
import 'package:BliU/utils/responsive.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:scrollable_positioned_list/scrollable_positioned_list.dart';

class CategoryScreen extends ConsumerStatefulWidget {
  const CategoryScreen({super.key});

  @override
  ConsumerState<CategoryScreen> createState() => _CategoryScreenState();
}

class _CategoryScreenState extends ConsumerState<CategoryScreen> {
  final ItemScrollController _scrollController = ItemScrollController();
  int _selectedCategoryIndex = 0; // 선택된 카테고리의 인덱스

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _afterBuild(context);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        automaticallyImplyLeading: false,
        // 기본 뒤로가기 버튼을 숨김
        scrolledUnderElevation: 0,
        backgroundColor: Colors.white,
        title: const Text('카테고리'),
        titleTextStyle: TextStyle(
          fontFamily: 'Pretendard',
          fontSize: Responsive.getFont(context, 18),
          fontWeight: FontWeight.w600,
          color: Colors.black,
          height: 1.2,
        ),
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
            onTap: () {
              ref.read(mainScreenProvider.notifier).selectNavigation(2);
            },
            child: Container(
                margin: const EdgeInsets.only(right: 16),
                child: SvgPicture.asset('assets/images/product/ic_close.svg')),
          ),
        ],
      ),
      body: Consumer(
        builder: (context, ref, widget) {
          final model = ref.watch(categoryModelProvider);
          final categories = model?.categoryResponseDTO?.list ?? [];

          return Row(
            children: [
              // 왼쪽 상위 카테고리 목록
              Container(
                width: 130,
                color: const Color(0xFFF5F9F9),
                child: ListView.builder(
                  itemCount: categories.length,
                  itemBuilder: (context, index) {
                    final categoryData = categories[index];
                    final bool isSelectCategory = _selectedCategoryIndex == index;
                    return ListTile(
                      selectedColor: Colors.black,
                      tileColor: isSelectCategory ? Colors.white : const Color(0xFFF5F9F9),
                      selected: isSelectCategory,
                      title: Text(
                        categoryData.ctName ?? "",
                        style: TextStyle(
                          fontFamily: 'Pretendard',
                          fontSize: Responsive.getFont(context, 15),
                          fontWeight: FontWeight.w600,
                          height: 1.2,
                        ),
                      ),
                      onTap: () {
                        setState(() {
                          _selectedCategoryIndex = index;
                        });
                        _scrollController.scrollTo(index: index, duration: const Duration(milliseconds: 500));
                      },
                    );
                  },
                ),
              ),
              // 오른쪽 모든 상위 + 하위 카테고리 목록을 나열
              Expanded(
                child: Container(
                  margin: const EdgeInsets.only(top: 21),
                  child: ScrollablePositionedList.builder(
                    itemScrollController: _scrollController,
                    itemCount: categories.length,
                    itemBuilder: (context, index) {
                      final category = categories[index];
                      final subCategories = category.subList ?? [];
                      return Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          // 상위 카테고리 제목과 이미지
                          Padding(
                            padding: const EdgeInsets.only(left: 20, right: 15, bottom: 10),
                            child: GestureDetector(
                              onTap: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => ProductListScreen(
                                      selectedCategory: category,
                                    ),
                                  ),
                                );
                              },
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  Expanded(
                                    flex: 8,
                                    child: Row(
                                      children: [
                                        Container(
                                          width: 40,
                                          height: 40,
                                          decoration: BoxDecoration(
                                            shape: BoxShape.circle,
                                            border: Border.all(
                                              color: const Color(0xFFEFEFEF),
                                            )
                                          ),
                                          child: SvgPicture.network(
                                            category.img ?? "",
                                          ),
                                        ),
                                        Container(
                                          margin: const EdgeInsets.symmetric(horizontal: 10),
                                          child: Text(
                                            category.ctName ?? "",
                                            style: TextStyle(
                                              fontFamily: 'Pretendard',
                                              fontSize: Responsive.getFont(context, 18),
                                              fontWeight: FontWeight.bold,
                                              height: 1.2,
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                  Expanded(
                                    flex: 2,
                                    child: SvgPicture.asset(
                                      'assets/images/category/그룹 37778.svg'
                                    )
                                  ),
                                ],
                              ),
                            ),
                          ),
                          // 하위 카테고리 목록
                          ...subCategories.map((subCategory) => ListTile(
                                minTileHeight: 0.1,
                                title: Text(
                                  subCategory.ctName ?? "",
                                  style: TextStyle(
                                    fontFamily: 'Pretendard',
                                    fontSize: Responsive.getFont(context, 14),
                                    height: 1.2,
                                  ),
                                ),
                                trailing: SvgPicture.asset('assets/images/ic_link.svg'),
                                onTap: () {
                                  // 하위 카테고리 선택 시 처리
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) => ProductListScreen(
                                        selectedCategory: category,
                                        selectSubCategoryIndex: subCategories.indexOf(subCategory),
                                      ),
                                    ),
                                  );
                                },
                              )),
                          Container(
                            margin: const EdgeInsets.symmetric(
                                vertical: 30, horizontal: 15),
                            child: const Divider(
                                color: Color(
                              0xFFEEEEEE,
                            )),
                          ),
                          // 상위 카테고리 구분을 위한 구분선
                        ],
                      );
                    },
                  ),
                ),
              ),
            ],
          );
        },
      ),
    );
  }

  void _afterBuild(BuildContext context) {
    Map<String, dynamic> requestData = {'category_type': '2'};
    ref.read(categoryModelProvider.notifier).getCategory(requestData);
  }
}
