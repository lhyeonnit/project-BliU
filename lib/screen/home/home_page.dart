import 'package:BliU/screen/_component/cart_screen.dart';
import 'package:BliU/screen/_component/move_top_button.dart';
import 'package:BliU/screen/_component/search_screen.dart';
import 'package:BliU/screen/home/component/home_body_ai.dart';
import 'package:BliU/screen/home/component/home_body_best_sales.dart';
import 'package:BliU/screen/home/component/home_body_category.dart';
import 'package:BliU/screen/home/component/home_body_exhibition.dart';
import 'package:BliU/screen/home/component/home_footer.dart';
import 'package:BliU/screen/home/component/home_header.dart';
import 'package:BliU/utils/responsive.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  ScrollController _scrollController = ScrollController();
  bool _isScrolled = false;

  @override
  void initState() {
    super.initState();
    _scrollController.addListener(() {
      if (_scrollController.offset > 50 && !_isScrolled) {
        setState(() {
          _isScrolled = true;
        });
      } else if (_scrollController.offset <= 50 && _isScrolled) {
        setState(() {
          _isScrolled = false;
        });
      }
    });
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Stack(
        children: [
          Column(
            children: [
              Expanded(
                child: CustomScrollView(
                  controller: _scrollController,
                  slivers: [
                    SliverAppBar(
                      pinned: true,
                      automaticallyImplyLeading: false, // 기본 뒤로가기 버튼을 숨김
                      backgroundColor:
                      _isScrolled ? Colors.white : Colors.transparent,
                      expandedHeight: 625,
                      title: Padding(
                        padding: EdgeInsets.only(
                            left: Responsive.getWidth(context, 16)), // 왼쪽 여백 추가
                        child: SvgPicture.asset(
                          'assets/images/home/bottom_home.svg', // SVG 파일 경로
                          color: _isScrolled ? Colors.black : Colors.white,
                          // 색상 조건부 변경
                          height: Responsive.getHeight(context, 40),
                        ),
                      ),
                      flexibleSpace: FlexibleSpaceBar(
                        background: HomeHeader(),
                      ),
                      actions: [
                        Padding(
                          padding: EdgeInsets.only(
                              right: Responsive.getWidth(context, 16)), // 왼쪽 여백 추가
                          child: Row(
                            children: [
                              IconButton(
                                icon: SvgPicture.asset(
                                  "assets/images/home/ic_top_sch_w.svg",
                                  color: _isScrolled ? Colors.black : Colors.white,
                                  height: Responsive.getHeight(context, 30),
                                  width: Responsive.getWidth(context, 30),
                                ),
                                onPressed: () {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) => SearchScreen(),
                                    ),
                                  );
                                },
                              ),
                              IconButton(
                                icon: SvgPicture.asset(
                                  _isScrolled
                                      ? "assets/images/product/ic_smart.svg"
                                      : "assets/images/home/ic_smart_w.svg",
                                  height: Responsive.getHeight(context, 30),
                                  width: Responsive.getWidth(context, 30),
                                ),
                                onPressed: () {},
                              ),
                              Stack(
                                children: [
                                  IconButton(
                                    icon: SvgPicture.asset(
                                      "assets/images/product/ic_cart.svg",
                                      color:
                                      _isScrolled ? Colors.black : Colors.white,
                                      height: Responsive.getHeight(context, 30),
                                      width: Responsive.getWidth(context, 30),
                                    ),
                                    onPressed: () {
                                      Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                          builder: (context) => CartScreen(),
                                        ),
                                      );
                                    },
                                  ),
                                  Positioned(
                                    right: 4,
                                    top: 20,
                                    child: Container(
                                      padding: EdgeInsets.all(4),
                                      decoration: BoxDecoration(
                                        color: Colors.pinkAccent,
                                        shape: BoxShape.circle,
                                      ),
                                      child: Text(
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
                        ),
                      ],
                    ),
                    SliverList(
                      delegate: SliverChildListDelegate(
                        [
                          HomeBodyCategory(),
                          HomeBodyAi(),
                          Padding(
                            padding: const EdgeInsets.symmetric(vertical: 30.0),
                            child: SizedBox(
                              height: 451, // 고정된 높이
                              child: HomeBodyExhibition(),
                            ),
                          ),
                          HomeBodyBestSales(),
                          HomeFooter(),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          MoveTopButton(scrollController: _scrollController),
        ],
      ),
    );
  }
}
