import 'package:BliU/data/category_data.dart';
import 'package:BliU/data/product_data.dart';
import 'package:BliU/dto/product_list_response_dto.dart';
import 'package:BliU/screen/_component/move_top_button.dart';
import 'package:BliU/screen/like/component/like_product_tab_bar_view.dart';
import 'package:BliU/screen/like/viewmodel/like_view_model.dart';
import 'package:BliU/screen/product/component/list/product_list_card.dart';
import 'package:BliU/utils/responsive.dart';
import 'package:BliU/utils/shared_preferences_manager.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class LikeScreen extends ConsumerStatefulWidget {
  const LikeScreen({super.key});

  @override
  ConsumerState<LikeScreen> createState() => _LikeScreenState();
}

class _LikeScreenState extends ConsumerState<LikeScreen> with TickerProviderStateMixin {
  final ScrollController _scrollController = ScrollController();

  late TabController _tabController;
  final List<CategoryData> _categories = [
    CategoryData(ctIdx: 0, cstIdx: 0, img: '', ctName: '전체', catIdx: 0, catName: '', subList: [])
  ];

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: _categories.length, vsync: this);
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _afterBuild(context);
    });
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        automaticallyImplyLeading: false,
        // 기본 뒤로가기 버튼을 숨김
        scrolledUnderElevation: 0,
        title: const Text('좋아요'),
        titleTextStyle: TextStyle(
          fontFamily: 'Pretendard',
          fontSize: Responsive.getFont(context, 18),
          fontWeight: FontWeight.w600,
          color: Colors.black,
          height: 1.2,
        ),
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(1.0), // 하단 구분선의 높이 설정
          child: Container(
            color: const Color(0xFFF4F4F4), // 하단 구분선 색상
            height: 1.0, // 구분선의 두께 설정
            child: Container(
              height: 1.0, // 그림자 부분의 높이
              decoration: const BoxDecoration(
                boxShadow: [
                  BoxShadow(
                    color: Color(0xFFF4F4F4),
                    blurRadius: 6.0,
                    spreadRadius: 1.0,
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
      body: Stack(
        children: [
          NestedScrollView(
            controller: _scrollController,
            headerSliverBuilder: (context, innerBoxIsScrolled) {
              return [
                SliverToBoxAdapter(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Container(
                        height: 60.0,
                        padding: const EdgeInsets.symmetric(vertical: 5),
                        child: TabBar(
                          controller: _tabController,
                          labelStyle: TextStyle(
                            fontFamily: 'Pretendard',
                            fontSize: Responsive.getFont(context, 14),
                            fontWeight: FontWeight.w600,
                          ),
                          overlayColor: WidgetStateColor.transparent,
                          indicatorColor: Colors.black,
                          indicatorSize: TabBarIndicatorSize.tab,
                          dividerColor: const Color(0xFFDDDDDD),
                          labelColor: Colors.black,
                          unselectedLabelColor: const Color(0xFF7B7B7B),
                          isScrollable: true,
                          indicatorWeight: 2.0,
                          tabAlignment: TabAlignment.start,
                          padding: const EdgeInsets.symmetric(horizontal: 12),
                          tabs: _categories.map((category) {
                            return Tab(text: category.ctName);
                          }).toList(),
                        ),
                      ),
                    ],
                  ), // 상단 고정된 컨텐츠
                )
              ];
            },
            body: TabBarView(
              controller: _tabController,
              children: List.generate(
                _categories.length,
                (index) {
                  // 상품 리스트
                  final categoryData = _categories[index];
                  //return _buildProductGrid(index);
                  return LikeProductTabBarView(categoryData: categoryData);
                },
              ),
            ),
          ),
          MoveTopButton(scrollController: _scrollController),
        ],
      ),
    );
  }

  void _afterBuild(BuildContext context) {
    _getCategoryList();
  }

  void _getCategoryList() async {
    Map<String, dynamic> requestData = {'category_type': '1'};
    final categoryResponseDTO = await ref.read(likeViewModelProvider.notifier).getCategory(requestData);
    if (categoryResponseDTO != null) {
      if (categoryResponseDTO.result == true) {
        final list = categoryResponseDTO.list ?? [];
        for (var item in list) {
          _categories.add(item);
        }

        setState(() {
          _tabController = TabController(length: _categories.length, vsync: this);
        });
      }
    }
  }
}
