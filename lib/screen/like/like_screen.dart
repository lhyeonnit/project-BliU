import 'package:BliU/data/category_data.dart';
import 'package:BliU/data/product_data.dart';
import 'package:BliU/dto/product_list_response_dto.dart';
import 'package:BliU/screen/_component/move_top_button.dart';
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
  late TabController _tabController;
  final ScrollController _scrollController = ScrollController();
  final List<CategoryData> _categories = [
    CategoryData(ctIdx: 0, cstIdx: 0, img: '', ctName: '전체', catIdx: 0, catName: '', subList: [])
  ];
  List<ProductListResponseDTO?> _productList = [];

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
                  return _buildProductGrid(index);
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
    _getAllList();
  }

  void _getAllList() async {
    // TODO 회원 비회원 처리
    final pref = await SharedPreferencesManager.getInstance();
    final mtIdx = pref.getMtIdx();

    // TODO 페이징 처리 필요
    Map<String, dynamic> requestData = {'category_type': '1'};
    final categoryResponseDTO = await ref.read(likeViewModelProvider.notifier).getCategory(requestData);
    if (categoryResponseDTO != null) {
      if (categoryResponseDTO.result == true) {
        final list = categoryResponseDTO.list ?? [];
        for (var item in list) {
          _categories.add(item);
        }

        for (var cate in _categories) {
          String category = "all";
          if ((cate.ctIdx ?? 0) > 0) {
            category = cate.ctIdx.toString();
          }

          Map<String, dynamic> requestData = {
            'mt_idx': mtIdx,
            'category': category,
            'sub_category': "all",
            'pg': 1,
          };

          final productListResponseDTO = await ref.read(likeViewModelProvider.notifier).getList(requestData);
          if (productListResponseDTO != null) {
            if (productListResponseDTO.result == true) {
              _productList.add(productListResponseDTO);
            } else {
              _productList.add(null);
            }
          } else {
            _productList.add(null);
          }
        }

        setState(() {
          _tabController = TabController(length: _categories.length, vsync: this);
        });
      }
    }
  }

  Widget _buildProductGrid(int productIndex) {
    List<ProductData> pList = [];
    int count = 0;
    try {
      pList = _productList[productIndex]?.list ?? [];
      count = _productList[productIndex]?.count ?? 0;
    } catch (e) {
      print("e = ${e.toString()}");
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          margin: const EdgeInsets.symmetric(horizontal: 16.0),
          padding: const EdgeInsets.symmetric(vertical: 20),
          child: Text(
            '상품 $count', // 상품 수 표시
            style: TextStyle(
              fontFamily: 'Pretendard',
              fontSize: Responsive.getFont(context, 14),
              color: Colors.black,
              height: 1.2,
            ),
          ),
        ),
        Expanded(
          child: GridView.builder(
            padding: const EdgeInsets.only(right: 16.0, left: 16, bottom: 20),
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2,
              childAspectRatio: 0.5,
              crossAxisSpacing: 12,
              mainAxisSpacing: 30,
            ),
            itemCount: pList.length, // 실제 상품 수로 변경
            itemBuilder: (context, index) {
              return ProductListCard(
                productData: pList[index],
              );
            },
          ),
        ),
      ],
    );
  }
}
