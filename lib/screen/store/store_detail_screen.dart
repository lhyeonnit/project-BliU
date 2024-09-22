import 'package:BliU/screen/_component/move_top_button.dart';
import 'package:BliU/screen/store/component/detail/store_category.dart';
import 'package:BliU/screen/store/component/detail/store_category_item.dart';
import 'package:BliU/screen/store/component/detail/store_group_selection.dart';
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
    final tabController = useTabController(initialLength: categories.length);
    final ScrollController _scrollController = ScrollController();

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
      body: Stack(
        children: [
          NestedScrollView(
            controller: _scrollController,
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
                          dividerColor: Color(0xFFDDDDDD),
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
                      Container(
                        margin: EdgeInsets.symmetric(vertical: 20),
                        padding: const EdgeInsets.only(left: 16.0),
                        child: Text(
                          '상품 1', // 상품 개수 텍스트
                          style: TextStyle(
                              fontSize: Responsive.getFont(context, 14),
                              color: Colors.black),
                        ),
                      ),
                    ],
                  ), // 상단 고정된 컨텐츠
                )
              ];
            },
            body: TabBarView(
              controller: tabController,
              children: List.generate(
                categories.length,
                (index) {
                  // 상품 리스트
                  return StoreCategoryItem();
                },
              ),
            ),
          ),
          MoveTopButton(scrollController: _scrollController),
        ],
      ),
    );
  }
}
