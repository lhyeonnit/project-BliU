import 'package:BliU/screen/_component/cart_screen.dart';
import 'package:BliU/screen/_component/search_screen.dart';
import 'package:BliU/screen/home/component/home_body_ai.dart';
import 'package:BliU/screen/home/component/home_body_best_sales.dart';
import 'package:BliU/screen/home/component/home_body_category.dart';
import 'package:BliU/screen/home/component/home_body_exhibition.dart';
import 'package:BliU/screen/home/component/home_footer.dart';
import 'package:BliU/screen/home/component/home_header.dart';
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
      body: Column(
        children: [
          Expanded(
            child: CustomScrollView(
              controller: _scrollController,
              slivers: [
                SliverAppBar(
                  pinned: true,
                  backgroundColor:
                      _isScrolled ? Colors.white : Colors.transparent,
                  leading: IconButton(
                    icon: SvgPicture.asset(
                      "assets/images/login/ic_back.svg",
                      color: _isScrolled ? Colors.black : Colors.white,
                    ),
                    onPressed: () {
                      Navigator.pop(context); // 뒤로가기 동작
                    },
                  ),
                  expandedHeight: 625.0,
                  title: SvgPicture.asset(
                    'assets/images/home/bottom_home.svg', // SVG 파일 경로
                    color: _isScrolled ? Colors.black : Colors.white,
                    // 색상 조건부 변경
                    height: 40, // SVG 이미지의 높이 설정
                  ),
                  flexibleSpace: FlexibleSpaceBar(
                    background: HomeHeader(),
                  ),
                  actions: [
                    IconButton(
                      icon: SvgPicture.asset(
                        "assets/images/home/ic_top_sch_w.svg",
                        color: _isScrolled ? Colors.black : Colors.white,
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
                        "assets/images/home/ic_smart_w.svg",
                        color: _isScrolled ? Colors.black : Colors.white,
                      ),
                      onPressed: () {},
                    ),
                    IconButton(
                      icon: SvgPicture.asset(
                        "assets/images/home/ic_cart_w.svg",
                        color: _isScrolled ? Colors.black : Colors.white,
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
                  ],
                ),
                SliverList(
                  delegate: SliverChildListDelegate(
                    [
                      HomeBodyCategory(),
                      HomeBodyAi(),
                      HomeBodyExhibition(),
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
    );
  }
}
