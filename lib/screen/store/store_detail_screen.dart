import 'package:BliU/screen/store/component/detail/store_category.dart';
import 'package:BliU/screen/store/component/detail/store_category_item.dart';
import 'package:BliU/screen/store/component/detail/store_info.dart';
import 'package:BliU/utils/responsive.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

class StoreDetailScreen extends HookConsumerWidget {
  const StoreDetailScreen({super.key});

  final List<String> categories = const [
    '전체',
    '아우터',
    '상의',
    '하의',
    '원피스',
    '슈즈',
    '세트/한벌옷',
    '언더웨어/홈웨어',
    '악세서리',
    '베이비 잡화'
  ];

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final tabController = useTabController(
        initialLength: categories.length);

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        scrolledUnderElevation: 0,
        backgroundColor: Colors.white,
        leading: IconButton(
          icon: SvgPicture.asset("assets/images/store/ic_back.svg"),
          onPressed: () {
            Navigator.pop(context); // 뒤로가기 동작
          },
        ),
      ),
      body: NestedScrollView(
        headerSliverBuilder: (context, innerBoxIsScrolled) {
          return [
            const SliverToBoxAdapter(
              child: StoreInfoPage(), // 상단 고정된 컨텐츠
            ),
            SliverToBoxAdapter(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    height: 60.0,
                    padding: const EdgeInsets.symmetric(vertical: 5),
                    child: TabBar(
                      controller: tabController,
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
                      tabs: categories.map((category) {
                        return Tab(text: category);
                      }).toList(),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 10),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Expanded(
                          child: GestureDetector(
                            onTap: () {}, // 정렬 순서 변경 로직
                            child: Row(
                              children: [
                                SvgPicture.asset(
                                  'assets/images/home/ic_filter02.svg',
                                  height: 18,
                                  width: 18,
                                ),
                                const SizedBox(width: 5.0),
                                Text(
                                  '최신순', // 정렬 순서 텍스트
                                  style: TextStyle(
                                      fontSize: Responsive.getFont(context, 14)),
                                ),
                              ],
                            ),
                          ),
                        ),
                        Flexible(
                          child: OutlinedButton(
                            onPressed: () {}, // 연령대 필터 선택
                            style: OutlinedButton.styleFrom(
                              backgroundColor: Colors.white,
                              side: const BorderSide(color: Color(0xFFDDDDDD)),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(19),
                              ),
                            ),
                            child: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Flexible(
                                  child: Text(
                                    '연령', // 선택된 연령대 표시
                                    overflow: TextOverflow.ellipsis,
                                    maxLines: 1,
                                    style: TextStyle(
                                        fontSize: Responsive.getFont(context, 14),
                                        color: Colors.black),
                                  ),
                                ),
                                const SizedBox(width: 5.0),
                                SvgPicture.asset(
                                    'assets/images/product/filter_select.svg'),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(left: 16.0),
                    child: Text(
                      '상품 1', // 상품 개수 텍스트
                      style: TextStyle(
                          fontSize: Responsive.getFont(context, 14), color: Colors.black),
                    ),
                  ),
                  const SizedBox(height: 20,),
                ],
              ), // 상단 고정된 컨텐츠
            )
          ];
        },
        body: TabBarView(
          controller: tabController,
          children: List.generate(
            categories.length, (index) {
              // 상품 리스트
              return StoreCategoryItem();
            },
          ),
        ),
      ),
    );
  }
}
