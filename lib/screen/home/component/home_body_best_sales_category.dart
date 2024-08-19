import 'package:flutter/material.dart';

class HomeBodyBestSalesCategory extends StatefulWidget {
  @override
  _HomeBodyBestSalesCategoryState createState() => _HomeBodyBestSalesCategoryState();
}

class _HomeBodyBestSalesCategoryState extends State<HomeBodyBestSalesCategory> {
  final List<String> categories = [
    '전체', '아우터', '상의', '하의', '원피스', '슈즈', '세트/한벌옷', '언더웨어/홈웨어', '악세서리', '베이비 잡화'
  ];

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: categories.length,
      child: Column(
        children: [
          Container(
            height: 50.0,
            child: TabBar(
              tabAlignment: TabAlignment.start,
              isScrollable: true,
              labelColor: Colors.black,
              unselectedLabelColor: Colors.grey,
              indicatorColor: Colors.black,
              indicatorWeight: 2.0,
              tabs: categories.map((category) {
                return Tab(text: category);
              }).toList(),
            ),
          ),
          // 여기에 추가적인 컨텐츠를 추가할 수 있습니다.
          // 예: 선택된 카테고리에 따른 내용을 보여주는 위젯
        ],
      ),
    );
  }
}
