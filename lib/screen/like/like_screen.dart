import 'package:BliU/screen/_component/move_top_button.dart';
import 'package:BliU/screen/product/component/list/product_list_card.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../utils/responsive.dart';

class LikeScreen extends ConsumerStatefulWidget {
  const LikeScreen({super.key});

  @override
  _LikeScreenState createState() => _LikeScreenState();
}

final ScrollController _scrollController = ScrollController();

final List<String> categories = [
  '전체',
  '아우터',
  '상의',
  '하의',
  '슈즈',
  '세트/한벌옷',
  '언더웨어/홈웨어',
];

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

class _LikeScreenState extends ConsumerState<LikeScreen>
    with SingleTickerProviderStateMixin {
  String selectedCategory = '전체';
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: categories.length, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        automaticallyImplyLeading: false,
        // 기본 뒤로가기 버튼을 숨김
        scrolledUnderElevation: 0,
        title: const Text('좋아요'),
        titleTextStyle: TextStyle(
          fontSize: Responsive.getFont(context, 18),
          fontWeight: FontWeight.w600,
          color: Colors.black,
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
      ),
      body: Stack(
        children: [
          NestedScrollView(
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
                            fontSize: Responsive.getFont(context, 14),
                            fontWeight: FontWeight.w600,
                          ),
                          overlayColor: WidgetStateColor.transparent,
                          indicatorColor: Colors.black,
                          indicatorSize: TabBarIndicatorSize.tab,
                          dividerColor: Color(0xFFDDDDDD),
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
                    ],
                  ), // 상단 고정된 컨텐츠
                )
              ];
            },
            body: TabBarView(
              controller: _tabController,
              children: List.generate(
                categories.length,
                (index) {
                  // 상품 리스트
                  return _buildProductGrid();
                },
              ),
            ),
          ),
          MoveTopButton(scrollController: _scrollController),
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
          padding: EdgeInsets.symmetric(vertical: 20),
          child: Text(
            '상품 ${items.length}', // 상품 수 표시
            style: const TextStyle(fontSize: 14, color: Colors.black),
          ),
        ),
        // Expanded(
        //   child: GridView.builder(
        //     padding: const EdgeInsets.only(right: 16.0, left: 16, bottom: 20),
        //     gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        //       crossAxisCount: 2,
        //       childAspectRatio: 0.5,
        //       crossAxisSpacing: 12,
        //       mainAxisSpacing: 30,
        //     ),
        //     itemCount: items.length, // 실제 상품 수로 변경
        //     itemBuilder: (context, index) {
        //       return ProductListCard(
        //         item: items[index],
        //         index: index,
        //       );
        //     },
        //   ),
        // ),
      ],
    );
  }
}
