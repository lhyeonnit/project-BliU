import 'package:BliU/screen/store/component/detail/store_category_item.dart';
import 'package:BliU/utils/responsive.dart';
import 'package:flutter/material.dart';
import 'home_body_best_sales_category.dart';

class HomeBodyBestSales extends StatefulWidget {
  const HomeBodyBestSales({super.key});

  @override
  State<HomeBodyBestSales> createState() => _HomeBodyBestSalesState();
}

class _HomeBodyBestSalesState extends State<HomeBodyBestSales> {
  String sortOrder = '최신순';

  void _onSortOrderChanged() {
    setState(() {
      sortOrder = sortOrder == '최신순' ? '인기순' : '최신순';
    });
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: Text(
            '판매베스트',
            style: TextStyle(
              fontSize: Responsive.getFont(context, 20),
              fontWeight: FontWeight.bold,
            ),
          ),
        ),

        HomeBodyBestSalesCategory(),
        Padding(
          padding: const EdgeInsets.all(16.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              ElevatedButton(
                onPressed: _onSortOrderChanged,
                child: Row(
                  children: [
                    Icon(Icons.sort, size: 20.0),
                    SizedBox(width: 4.0),
                    Text(sortOrder),
                  ],
                ),
              ),
              ElevatedButton(
                onPressed: () {},
                child: Row(
                  children: [
                    Text('정렬 방식'),
                    Icon(Icons.arrow_drop_down, size: 20.0),
                  ],
                ),
              ),
            ],
          ),
        ),
        Expanded(
          child: GridView.builder(
            padding: const EdgeInsets.all(8.0),
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2, // 두 개의 열
              crossAxisSpacing: 8.0,
              mainAxisSpacing: 8.0,
              childAspectRatio: 0.6, // 아이템의 가로세로 비율
            ),
            itemCount: 10, // 실제 상품 수로 변경
            itemBuilder: (context, index) {
              return StoreCategoryItem();
            },
          ),
        ),
      ],
    );
  }
}
