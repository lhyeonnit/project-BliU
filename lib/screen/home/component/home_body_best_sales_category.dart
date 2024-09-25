import 'package:flutter/material.dart';

class HomeBodyBestSalesCategory extends StatefulWidget {
  const HomeBodyBestSalesCategory({super.key});

  @override
  _HomeBodyBestSalesCategoryState createState() =>
      _HomeBodyBestSalesCategoryState();
}

class _HomeBodyBestSalesCategoryState
    extends State<HomeBodyBestSalesCategory> with SingleTickerProviderStateMixin {
  final List<String> categories = [
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

  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: categories.length, vsync: this);
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SizedBox(
          height: 38.0,
          child: TabBar(
            controller: _tabController,
            isScrollable: true,
            labelColor: const Color(0xFFFF6192), // 선택된 탭 텍스트 색상
            unselectedLabelColor: Colors.black, // 선택되지 않은 탭 텍스트 색상
            indicatorColor: const Color(0xFFFF6192), // 선택된 탭 아래의 선 색상
            indicatorWeight: 2.0,
            tabs: categories.map((category) {
              return Tab(
                child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(20),
                    border: Border.all(
                      color: _tabController.index == categories.indexOf(category)
                          ? const Color(0xFFFF6192)
                          : const Color(0xFFDDDDDD),
                      width: 1.0,
                    ),
                    color: _tabController.index == categories.indexOf(category)
                        ? Colors.white
                        : Colors.white,
                  ),
                  child: Text(
                    category,
                    style: TextStyle(
                      fontSize: 14,
                      color: _tabController.index == categories.indexOf(category)
                          ? const Color(0xFFFF6192)
                          : Colors.black,
                    ),
                  ),
                ),
              );
            }).toList(),
          ),
        ),
        // 여기에 TabView 등 카테고리 별로 보여줄 컨텐츠를 추가할 수 있습니다.
      ],
    );
  }
}
