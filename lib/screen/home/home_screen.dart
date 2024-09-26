import 'package:BliU/data/category_data.dart';
import 'package:BliU/screen/_component/cart_screen.dart';
import 'package:BliU/screen/_component/move_top_button.dart';
import 'package:BliU/screen/_component/search_screen.dart';
import 'package:BliU/screen/_component/smart_lens_screen.dart';
import 'package:BliU/screen/home/component/home_body_ai.dart';
import 'package:BliU/screen/home/component/home_body_best_sales.dart';
import 'package:BliU/screen/home/component/home_body_category.dart';
import 'package:BliU/screen/home/component/home_body_exhibition.dart';
import 'package:BliU/screen/home/component/home_footer.dart';
import 'package:BliU/screen/home/component/home_header.dart';
import 'package:BliU/screen/home/viewmodel/home_view_model.dart';
import 'package:BliU/utils/responsive.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_svg/flutter_svg.dart';

class HomeScreen extends ConsumerStatefulWidget {
  const HomeScreen({super.key});

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends ConsumerState<HomeScreen> {
  final ScrollController _scrollController = ScrollController();
  List<CategoryData> categories = [];
  List<CategoryData> ageCategories = [];
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
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _afterBuild(context);
    });
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  void _afterBuild(BuildContext context) {
    _getCategoryList();
  }

  void _getCategoryList() async {
    Map<String, dynamic> requestData = {'category_type': '1'};
    final categoryResponseDTO = await ref.read(homeViewModelProvider.notifier).getCategory(requestData);
    final ageCategoryResponseDTO = await ref.read(homeViewModelProvider.notifier).getAgeCategory();
    if (categoryResponseDTO != null) {
      if (categoryResponseDTO.result == true) {
        categories = categoryResponseDTO.list ?? [];
      }
    }

    if (ageCategoryResponseDTO != null) {
      if (ageCategoryResponseDTO.result == true) {
        ageCategories = ageCategoryResponseDTO.list ?? [];
      }
    }
    setState(() {});
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
                      scrolledUnderElevation: 0,
                      pinned: true,
                      automaticallyImplyLeading: false,
                      // 기본 뒤로가기 버튼을 숨김
                      backgroundColor:
                          _isScrolled ? Colors.white : Colors.transparent,
                      expandedHeight: 625,
                      title: SvgPicture.asset(
                        'assets/images/home/bottom_home.svg', // SVG 파일 경로
                        color: _isScrolled ? Colors.black : Colors.white,
                        // 색상 조건부 변경
                        height: Responsive.getHeight(context, 40),
                      ),
                      flexibleSpace: const FlexibleSpaceBar(
                        background: HomeHeader(),
                      ),
                      actions: [
                        Container(
                          padding: EdgeInsets.only(
                              right: Responsive.getWidth(context, 8)),
                          // 왼쪽 여백 추가
                          child: Row(
                            children: [
                              IconButton(
                                icon: SvgPicture.asset(
                                  "assets/images/home/ic_top_sch_w.svg",
                                  color:
                                      _isScrolled ? Colors.black : Colors.white,
                                  height: Responsive.getHeight(context, 30),
                                  width: Responsive.getWidth(context, 30),
                                ),
                                onPressed: () {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) =>
                                          const SearchScreen(),
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
                                onPressed: () {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) =>
                                          const SmartLensScreen(),
                                    ),
                                  );
                                },
                              ),
                              Stack(
                                children: [
                                  IconButton(
                                    icon: SvgPicture.asset(
                                      "assets/images/product/ic_cart.svg",
                                      color: _isScrolled
                                          ? Colors.black
                                          : Colors.white,
                                      height: Responsive.getHeight(context, 30),
                                      width: Responsive.getWidth(context, 30),
                                    ),
                                    onPressed: () {
                                      Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                          builder: (context) =>
                                              const CartScreen(),
                                        ),
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
                                          fontFamily: 'Pretendard',
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
                          HomeBodyCategory(categories: categories,),
                          const HomeBodyAi(),
                          const Padding(
                            padding: EdgeInsets.symmetric(vertical: 30.0),
                            child: SizedBox(
                              height: 451, // 고정된 높이
                              child: HomeBodyExhibition(),
                            ),
                          ),
                          HomeBodyBestSales(categories: categories, ageCategories: ageCategories,),
                          const HomeFooter(),
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
