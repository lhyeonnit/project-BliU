import 'package:BliU/screen/product/component/detail/product_info_content.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

import '../../utils/responsive.dart';
import '../_component/cart_screen.dart';
import '../_component/move_top_button.dart';
import '../_component/search_screen.dart';
import 'component/detail/product_ai.dart';
import 'component/detail/product_banner.dart';
import 'component/detail/product_info_before_order.dart';
import 'component/detail/product_info_title.dart';
import 'component/detail/product_inquiry.dart';
import 'component/detail/product_order_bottom_option.dart';
import 'component/detail/product_review_list.dart';

class ProductDetailScreen extends StatefulWidget {
  const ProductDetailScreen({super.key});

  @override
  State<ProductDetailScreen> createState() => _ProductDetailScreenState();
}

class _ProductDetailScreenState extends State<ProductDetailScreen> {
  final ScrollController _scrollController = ScrollController();

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
      body: Stack(
        children: [
          DefaultTabController(
            length: 2, // 두 개의 탭
            child: NestedScrollView(
              controller: _scrollController,
              headerSliverBuilder:
                  (BuildContext context, bool innerBoxIsScrolled) {
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
              body: Column(
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
          Positioned(
            bottom: 0,
            left: 0,
            right: 0,
            child: Column(
              children: [
                MoveTopButton(scrollController: _scrollController),
                Container(
                  padding:
                      EdgeInsets.only(top: 9, bottom: 8, left: 10, right: 10),
                  color: Colors.white,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Expanded(
                        flex: 2,
                        child: GestureDetector(
                          child: Container(
                            margin: EdgeInsets.only(right: 9),
                            decoration: BoxDecoration(
                                borderRadius:
                                    BorderRadius.all(Radius.circular(6)),
                                border: Border.all(color: Color(0xFFDDDDDD))),
                            child: SvgPicture.asset(
                                'assets/images/product/like_lg_off.svg'),
                          ),
                        ),
                      ),
                      Expanded(
                        flex: 8,
                        child: GestureDetector(
                          onTap: () {
                            ProductOrderBottomOption.showBottomSheet(context);
                          },
                          child: Container(
                            width: double.infinity,
                            height: Responsive.getHeight(context, 48),
                            decoration: BoxDecoration(
                              color: Colors.black,
                              borderRadius: BorderRadius.all(
                                Radius.circular(6),
                              ),
                            ),
                            child: Center(
                              child: Text(
                                '구매하기',
                                style: TextStyle(
                                  fontSize: Responsive.getFont(context, 14),
                                  color: Colors.white,
                                ),
                              ),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
