import 'package:BliU/data/category_data.dart';
import 'package:BliU/data/store_data.dart';
import 'package:BliU/dto/category_response_dto.dart';
import 'package:BliU/dto/product_list_response_dto.dart';
import 'package:BliU/dto/store_response_dto.dart';
import 'package:BliU/screen/_component/move_top_button.dart';
import 'package:BliU/screen/category/viewmodel/category_view_model.dart';
import 'package:BliU/screen/product/viewmodel/product_list_view_model.dart';
import 'package:BliU/screen/store/component/detail/store_category_item.dart';
import 'package:BliU/screen/store/component/detail/store_info.dart';
import 'package:BliU/utils/responsive.dart';
import 'package:BliU/utils/shared_preferences_manager.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:scrollable_positioned_list/scrollable_positioned_list.dart';

import 'viewmodel/store_product_view_model.dart';

class StoreDetailScreen extends ConsumerStatefulWidget {
  const StoreDetailScreen({super.key});

  @override
  _StoreDetailScreenState createState() => _StoreDetailScreenState();
}

class _StoreDetailScreenState extends ConsumerState<StoreDetailScreen>
    with TickerProviderStateMixin {
  final ScrollController _scrollController = ScrollController();
  late TabController _tabController;
  final List<CategoryData> categories = [
    CategoryData(
        ctIdx: 0,
        cstIdx: 0,
        img: '',
        ctName: '전체',
        subList: [],
        catIdx: null,
        catName: null)
  ];
  List<ProductListResponseDTO?> productList = [];
  StoreData? storeData;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: categories.length, vsync: this);
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
        scrolledUnderElevation: 0,
        backgroundColor: Colors.white,
        leading: IconButton(
          icon: SvgPicture.asset("assets/images/store/ic_back.svg"),
          onPressed: () {
            Navigator.pop(context); // 뒤로가기 동작
          },
        ),
      ),
      body: Stack(
        children: [
          NestedScrollView(
            controller: _scrollController,
            headerSliverBuilder: (context, innerBoxIsScrolled) {
              return [
                SliverToBoxAdapter(
                  child: StoreInfoPage(storeData: storeData),
                ),
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
                          dividerColor: Color(0xFFDDDDDD),
                          indicatorSize: TabBarIndicatorSize.tab,
                          labelColor: Colors.black,
                          unselectedLabelColor: const Color(0xFF7B7B7B),
                          isScrollable: true,
                          indicatorWeight: 2.0,
                          tabAlignment: TabAlignment.start,
                          padding: const EdgeInsets.symmetric(horizontal: 12),
                          tabs: categories.map((category) {
                            return Tab(text: category.ctName ?? "");
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
                categories.length, (index) {
                  final productData = productList[index]?.list ?? [];
                  final count = productData.length;
                  // 상품 리스트
                  return StoreCategoryItem(
                      productData: productData, count: count);
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
    Map<String, dynamic> requestData = {'category_type': '2'};
    final categoryResponseDTO = await ref.read(StoreProductViewModelProvider.notifier).getCategory(requestData);
    if (categoryResponseDTO != null) {
      if (categoryResponseDTO.result == true) {
        final list = categoryResponseDTO.list ?? [];
        for (var item in list) {
          categories.add(item);
        }

        for (var cate in categories) {
          String category = "all";
          if ((cate.ctIdx ?? 0) > 0) {
            category = cate.ctIdx.toString();
          }

          Map<String, dynamic> requestData = {
            'mt_idx': mtIdx,
            'st_idx': 1,
            'category': category,
            'pg': 1,
          };
          final storeResponseDTO = await ref.read(StoreProductViewModelProvider.notifier).getStoreList(requestData);
          setState(() {
            storeData = storeResponseDTO?.data;
          });
          final productListResponseDTO = await ref.read(StoreProductViewModelProvider.notifier).getProductList(requestData);
          if (productListResponseDTO != null) {
            if (productListResponseDTO.result == true) {
              productList.add(productListResponseDTO);
            } else {
              productList.add(null);
            }
          } else {
            productList.add(null);
          }
        }

        setState(() {
          _tabController =
              TabController(length: categories.length, vsync: this);
        });
      }
    }
  }
}
