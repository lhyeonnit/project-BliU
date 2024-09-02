import 'package:flutter/material.dart';

class HomeBodyBestSales extends StatefulWidget {
  const HomeBodyBestSales({super.key});

  @override
  State<HomeBodyBestSales> createState() => _HomeBodyBestSalesState();
}

class _HomeBodyBestSalesState extends State<HomeBodyBestSales> {


  @override
  Widget build(BuildContext context) {
    return const Scaffold();
      // Column(
    //   crossAxisAlignment: CrossAxisAlignment.start,
    //   children: [
    //     Padding(
    //       padding: const EdgeInsets.symmetric(horizontal: 16),
    //       child: Text(
    //         '판매베스트',
    //         style: TextStyle(
    //           fontSize: Responsive.getFont(context, 20),
    //           fontWeight: FontWeight.bold,
    //         ),
    //       ),
    //     ),
    //
    //     HomeBodyBestSalesCategory(),
    //     Padding(
    //       padding: const EdgeInsets.all(16.0),
    //       child: ElevatedButton(
    //             onPressed: () {},
    //             child: Row(
    //               children: [
    //                 Text('정렬 방식'),
    //                 Icon(Icons.arrow_drop_down, size: 20.0),
    //               ],
    //             ),
    //
    //       ),
    //     ),
    //     Expanded(
    //       child: GridView.builder(
    //         padding: const EdgeInsets.all(8.0),
    //         gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
    //           crossAxisCount: 2, // 두 개의 열
    //           crossAxisSpacing: 8.0,
    //           mainAxisSpacing: 8.0,
    //           childAspectRatio: 0.6, // 아이템의 가로세로 비율
    //         ),
    //         itemCount: 10, // 실제 상품 수로 변경
    //         itemBuilder: (context, index) {
    //           return StoreCategoryItem();
    //         },
    //       ),
    //     ),
    //   ],
    // );
  }
}
