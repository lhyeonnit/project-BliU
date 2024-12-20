import 'package:BliU/screen/main/page_screen/store/child_widget/store_favorite_child_widget.dart';
import 'package:BliU/screen/main/page_screen/store/child_widget/store_ranking_child_widget.dart';
import 'package:BliU/utils/responsive.dart';
import 'package:flutter/material.dart';

class StoreScreen extends StatefulWidget {
  const StoreScreen({super.key});

  @override
  State<StoreScreen> createState() => StoreScreenState();
}

class StoreScreenState extends State<StoreScreen>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
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
        scrolledUnderElevation: 0,
        backgroundColor: Colors.white,
        automaticallyImplyLeading: false,
        // 기본 뒤로가기 버튼을 숨김
        title: const Text("스토어"),
        titleTextStyle: TextStyle(
          fontFamily: 'Pretendard',
          fontSize: Responsive.getFont(context, 18),
          fontWeight: FontWeight.w600,
          color: Colors.black,
          height: 1.2,
        ),
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(60 + 1.0), // TabBar 높이 + 구분선 두께
          child: Column(
            children: [
              // 구분선
              Container(
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
              // TabBar
              SizedBox(
                height: 60,
                child: TabBar(
                  controller: _tabController,
                  labelStyle: TextStyle(
                    fontFamily: 'Pretendard',
                    fontSize: Responsive.getFont(context, 14),
                    fontWeight: FontWeight.w600,
                  ),
                  tabs: const [
                    Tab(text: '랭킹'),
                    Tab(text: '즐겨찾기'),
                  ],
                  overlayColor: WidgetStateColor.transparent,
                  dividerColor: const Color(0xFFDDDDDD),
                  indicatorColor: Colors.black,
                  indicatorSize: TabBarIndicatorSize.tab,
                  // 인디케이터가 각 탭의 길이에 맞게 조정됨
                  labelColor: Colors.black,
                  unselectedLabelColor: const Color(0xFF7B7B7B),
                ),
              ),
            ],
          ),
        ),
      ),
      body: SafeArea(
        child: TabBarView(
          controller: _tabController,
          children: const [
            StoreRankingChildWidget(),
            StoreFavoriteChildWidget(),
          ],
        ),
      ),
    );
  }
}
