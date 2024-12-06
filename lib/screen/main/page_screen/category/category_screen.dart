import 'package:BliU/screen/main/main_screen.dart';
import 'package:BliU/screen/main/view_model/main_view_model.dart';
import 'package:BliU/utils/responsive.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:scrollable_positioned_list/scrollable_positioned_list.dart';

final categoryStateProvider = StateProvider<int>((_) => 0);

class CategoryScreen extends ConsumerStatefulWidget {
  const CategoryScreen({super.key});

  @override
  ConsumerState<CategoryScreen> createState() => CategoryScreenState();
}

class CategoryScreenState extends ConsumerState<CategoryScreen> {

  final ItemScrollController _scrollController = ItemScrollController();
  final ItemPositionsListener _itemPositionsListener = ItemPositionsListener.create();

  @override
  void initState() {
    super.initState();
    _itemPositionsListener.itemPositions.addListener(_itemPositionListener);
  }

  void _itemPositionListener() {
    final last = _itemPositionsListener.itemPositions.value.last;

    final categories = ref.read(mainViewModelProvider).categories2;
    final selectedCategoryIndex = ref.read(categoryStateProvider.notifier).state;
    if (last.index == (categories.length - 1)) {
      if (last.itemTrailingEdge < 1.001) {
        if (selectedCategoryIndex != last.index) {
          ref.read(categoryStateProvider.notifier).state = last.index;
        }
        return;
      }
    }

    ItemPosition position = _itemPositionsListener.itemPositions.value.firstWhere((element) => element.itemLeadingEdge <= 0);
    final itemIndex = position.index;
    if (selectedCategoryIndex != itemIndex) {
      ref.read(categoryStateProvider.notifier).state = itemIndex;
    }
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
          GestureDetector(
            onTap: () {
              ref.read(mainScreenProvider.notifier).selectNavigation(2);
            },
            child: Container(
              margin: const EdgeInsets.only(right: 16),
              child: SvgPicture.asset('assets/images/product/ic_close.svg')
            ),
          ),
        ],
      ),
      body: Consumer(
        builder: (context, ref, widget) {
          final categories = ref.watch(mainViewModelProvider).categories2;
          final selectedCategoryIndex = ref.watch(categoryStateProvider);

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
                    final bool isSelectCategory = selectedCategoryIndex == index;
                    return GestureDetector(
                      onTap: () {
                        _scrollController.scrollTo(index: index, duration: const Duration(milliseconds: 1));
                      },
                      child: Container(
                        padding: const EdgeInsets.only(left: 16),
                        height: 50,
                        color: isSelectCategory ? Colors.white : const Color(0xFFF5F9F9),
                        child: Row(
                          children: [
                            Text(
                              categoryData.ctName ?? "",
                              style: TextStyle(
                                fontFamily: 'Pretendard',
                                fontSize: Responsive.getFont(context, 15),
                                fontWeight: FontWeight.w600,
                                height: 1.2,
                              ),
                            ),
                          ],
                        ),
                      ),
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
                    itemPositionsListener: _itemPositionsListener,
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
                                final map = { 'selectedCategory' : category, 'selectSubCategoryIndex' : null };
                                Navigator.pushNamed(context, '/product_list', arguments: map);
                              },
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  Expanded(
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
                                  SvgPicture.asset(
                                    'assets/images/category/ic_select_product.svg',
                                    width: 26,
                                    height: 26,
                                  ),
                                ],
                              ),
                            ),
                          ),
                          // 하위 카테고리 목록
                          ...subCategories.map((subCategory) =>
                            Container(
                              margin: const EdgeInsets.fromLTRB(20, 10, 16, 10),
                              child: GestureDetector(
                                onTap: () {
                                  // 하위 카테고리 선택 시 처리
                                  final map = { 'selectedCategory' : category, 'selectSubCategoryIndex' : subCategories.indexOf(subCategory) };
                                  Navigator.pushNamed(context, '/product_list', arguments: map);
                                },
                                child: Row(
                                  children: [
                                    Expanded(
                                      child: Text(
                                        subCategory.ctName ?? "",
                                        style: TextStyle(
                                          fontFamily: 'Pretendard',
                                          fontSize: Responsive.getFont(context, 14),
                                          height: 1.2,
                                        ),
                                      ),
                                    ),
                                    SvgPicture.asset(
                                      'assets/images/ic_link.svg',
                                      width: 15,
                                      height: 15,
                                      colorFilter: const ColorFilter.mode(
                                        Colors.black,
                                        BlendMode.srcIn,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            )
                          ),
                          Container(
                            margin: const EdgeInsets.symmetric(vertical: 20, horizontal: 15),
                            child: const Divider(color: Color(0xFFEEEEEE,)),
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
}
