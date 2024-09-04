import 'package:BliU/screen/product/component/detail/product_info_content.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

import '../_component/cart_screen.dart';
import '../_component/search_screen.dart';
import 'component/detail/product_ai.dart';
import 'component/detail/product_banner.dart';
import 'component/detail/product_info_before_order.dart';
import 'component/detail/product_info_title.dart';
import 'component/detail/product_inquiry.dart';
import 'component/detail/product_review_list.dart';

class ProductDetailScreen extends StatefulWidget {
  const ProductDetailScreen({super.key});

  @override
  State<ProductDetailScreen> createState() => _ProductDetailScreenState();
}

class _ProductDetailScreenState extends State<ProductDetailScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        scrolledUnderElevation: 0,
        backgroundColor: Colors.white,
        leading: IconButton(
          icon: SvgPicture.asset("assets/images/product/ic_back.svg"),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
        actions: [
          IconButton(
            icon: SvgPicture.asset("assets/images/product/ic_top_sch.svg"),
            color: Colors.black,
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const SearchScreen()),
              );
            },
          ),
          Stack(
            children: [
              IconButton(
                icon: SvgPicture.asset("assets/images/product/ic_cart.svg"),
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => const CartScreen()),
                  );
                },
              ),
              Positioned(
                right: 4,
                top: 20,
                child: Container(
                  padding: const EdgeInsets.all(4),
                  decoration: const BoxDecoration(
                    color: Colors.pinkAccent,
                    shape: BoxShape.circle,
                  ),
                  child: const Text(
                    '2',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 12,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
      body: DefaultTabController(
        length: 2, // 두 개의 탭
        child: NestedScrollView(
          headerSliverBuilder: (BuildContext context, bool innerBoxIsScrolled) {
            return <Widget>[
              const SliverToBoxAdapter(
                child: Column(
                  children: [
                    ProductBanner(),
                    ProductInfoTitle(),
                  ],
                ),
              ),
            ];
          },
          body: const Column(
            children: [
              TabBar(
                labelColor: Colors.black,
                tabs: [
                  Tab(text: '상세정보'),
                  Tab(text: '리뷰(10)'),
                ],
              ),
              Expanded(
                child: TabBarView(
                  children: [
                    // 첫 번째 탭: 상세정보에 모든 정보 포함
                    SingleChildScrollView(
                      child: Column(
                        children: [
                          ProductInfoContent(),
                          ProductAi(),
                          ProductInfoBeforeOrder(),
                          ProductInquiry(),
                        ],
                      ),
                    ),
                    // 두 번째 탭: 리뷰만 표시
                     ProductReview(),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
