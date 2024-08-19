import 'package:flutter/material.dart';
import 'store_category_item.dart';

class StoreCategory extends StatefulWidget {
  @override
  _StoreCategoryState createState() => _StoreCategoryState();
}

class _StoreCategoryState extends State<StoreCategory> with SingleTickerProviderStateMixin {
  final List<String> categories = [
    '전체', '아우터', '상의', '하의', '원피스', '슈즈', '세트/한벌옷', '언더웨어/홈웨어', '악세서리', '베이비 잡화'
  ];
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
    return Column(
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
            controller: _tabController,
            tabs: categories.map((category) {
              return Tab(text: category);
            }).toList(),
          ),
        ),
        // TabBarView 및 상품 그리드
        Expanded(
          child: TabBarView(
            controller: _tabController,
            children: List.generate(categories.length, (index) {
              return _buildProductGrid(10); // 각 탭마다 상품을 10개씩 표시하도록 설정
            }),
          ),
        ),
      ],
    );
  }

  Widget _buildProductGrid(int productCount) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.only(left: 10.0,top: 8),
            child: Text(
              '상품 $productCount', // 상품 수 표시
              style: TextStyle(fontSize: 16, color: Colors.black),
            ),
          ),
          const SizedBox(height: 8.0), // 간격 추가
          Expanded(
            child: GridView.builder(
              padding: const EdgeInsets.all(8.0),
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2, // 두 개의 열
                crossAxisSpacing: 8.0,
                mainAxisSpacing: 8.0,
                childAspectRatio: 0.6, // 아이템의 가로세로 비율
              ),
              itemCount: productCount, // 실제 상품 수로 변경
              itemBuilder: (context, index) {
                return StoreCategoryItem();
              },
            ),
          ),
        ],
      ),
    );
  }
}
