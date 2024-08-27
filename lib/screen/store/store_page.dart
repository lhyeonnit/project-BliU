import 'package:BliU/screen/store/component/store_age_group_selection.dart';
import 'package:BliU/screen/store/component/store_favorite_page.dart';
import 'package:BliU/screen/store/component/store_ranking_page.dart';
import 'package:BliU/screen/store/component/store_style_group_selection.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

import '../../utils/responsive.dart';
import 'dummy/store_ranking.dart';

class StorePage extends StatefulWidget {
  const StorePage({super.key});

  @override
  _StorePageState createState() => _StorePageState();
}

class _StorePageState extends State<StorePage>
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
        backgroundColor: Colors.white,
        title: Text("스토어"),
        titleTextStyle: TextStyle(
          fontSize: Responsive.getFont(context, 18),
          fontWeight: FontWeight.w600,
          color: Colors.black,
        ),
        bottom: PreferredSize(
          preferredSize: Size.fromHeight(60 + 1.0), // TabBar 높이 + 구분선 두께
          child: Column(
            children: [
              // 구분선
              Container(
                color: Color(0xFFF4F4F4), // 하단 구분선 색상
                height: 1.0, // 구분선의 두께 설정
                child: Container(
                  height: 1.0, // 그림자 부분의 높이
                  decoration: BoxDecoration(
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
              // TabBar
              Container(
                height: 60,
                child: TabBar(
                  controller: _tabController,
                  labelStyle: TextStyle(
                    fontSize: Responsive.getFont(context, 14),
                    fontWeight: FontWeight.w600,
                  ),
                  tabs: [
                    Tab(text: '랭킹'),
                    Tab(text: '즐겨찾기'),
                  ],
                  indicatorColor: Colors.black,
                  indicatorSize: TabBarIndicatorSize.tab, // 인디케이터가 각 탭의 길이에 맞게 조정됨
                  labelColor: Colors.black,
                  unselectedLabelColor: Color(0xFF7B7B7B),
                ),
              ),
            ],
          ),
        ),
      ),
      body: TabBarView(
        controller: _tabController,
        children: [
          StoreRakingPage(),
          StoreFavoritePage(),
        ],
      ),
    );
  }
}
