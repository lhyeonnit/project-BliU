import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:BliU/utils/responsive.dart';

// TabController Provider
final tabControllerProvider = Provider<TabController>((ref) {
  return TabController(length: 10, vsync: ref.watch(vsyncProvider)); // 카테고리 수만큼 길이 설정
});

// vsync Provider
final vsyncProvider = Provider<TickerProvider>((ref) {
  throw UnimplementedError(); // 실제 애플리케이션에서는 유효한 TickerProvider로 대체 필요
});

class StoreCategory extends ConsumerWidget {
  final List<String> categories = [
    '전체', '아우터', '상의', '하의', '원피스', '슈즈', '세트/한벌옷', '언더웨어/홈웨어', '악세서리', '베이비 잡화'
  ];

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final tabController = ref.watch(tabControllerProvider); // TabController 가져오기

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          height: 60.0,
          padding: EdgeInsets.symmetric(vertical: 5),
          child: TabBar(
            controller: tabController,
            labelStyle: TextStyle(
              fontSize: Responsive.getFont(context, 14),
              fontWeight: FontWeight.w600,
            ),
            indicatorColor: Colors.black,
            indicatorSize: TabBarIndicatorSize.tab,
            labelColor: Colors.black,
            unselectedLabelColor: Color(0xFF7B7B7B),
            isScrollable: true,
            indicatorWeight: 2.0,
            tabAlignment: TabAlignment.start,
            padding: EdgeInsets.symmetric(horizontal: 12),
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
                      SizedBox(width: 5.0),
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
                    side: BorderSide(color: Color(0xFFDDDDDD)),
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
            '상품 ${categories.length}', // 상품 개수 텍스트
            style: TextStyle(
                fontSize: Responsive.getFont(context, 14),
                color: Colors.black),
          ),
        ),
        Expanded(
          child: TabBarView(
            controller: tabController,
            children: List.generate(categories.length, (index) {
              return Center(child: Text('탭 콘텐츠 $index'));
            }),
          ),
        ),
      ],
    );
  }
}
