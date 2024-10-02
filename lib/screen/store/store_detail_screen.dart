import 'package:BliU/data/category_data.dart';
import 'package:BliU/data/product_data.dart';
import 'package:BliU/data/store_data.dart';
import 'package:BliU/screen/_component/move_top_button.dart';
import 'package:BliU/screen/product/product_detail_screen.dart';
import 'package:BliU/screen/store/component/detail/store_info.dart';
import 'package:BliU/screen/store/viewmodel/store_product_view_model.dart';
import 'package:BliU/utils/responsive.dart';
import 'package:BliU/utils/shared_preferences_manager.dart';
import 'package:BliU/utils/utils.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

class StoreDetailScreen extends ConsumerStatefulWidget {
  final int stIdx;
  const StoreDetailScreen({super.key, required this.stIdx});

  @override
  ConsumerState<StoreDetailScreen> createState() => _StoreDetailScreenState();
}

class _StoreDetailScreenState extends ConsumerState<StoreDetailScreen> with TickerProviderStateMixin {
  final ScrollController _scrollController = ScrollController();
  late TabController _tabController;
  int _page = 1;
  bool _hasNextPage = true;
  bool _isFirstLoadRunning = false;
  bool _isLoadMoreRunning = false;
  int _count = 0;
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
  StoreData? storeData;
  List<ProductData> _productList = [];

  @override
  void initState() {
    super.initState();
    _scrollController.addListener(_nextLoad);
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
                      Container(
                        margin: const EdgeInsets.symmetric(horizontal: 16.0),
                        padding: const EdgeInsets.only(bottom: 20),
                        child: Text(
                          '상품 $_count', // 상품 수 표시
                          style: TextStyle(
                            fontFamily: 'Pretendard',
                            fontSize: Responsive.getFont(context, 14),
                            color: Colors.black,
                            height: 1.2,
                          ),
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
                  if (index == _tabController.index) {
                    return _buildProductGrid();
                  } else {
                    return Container();
                  }
                },
              ),
            ),
          ),
          MoveTopButton(scrollController: _scrollController),
        ],
      ),
    );
  }
  Widget _buildProductGrid() {
    return GridView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      padding: const EdgeInsets.only(right: 16.0, left: 16, bottom: 20),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        childAspectRatio: 0.55,
        crossAxisSpacing: 12,
        mainAxisSpacing: 30,
      ),
      itemCount: _productList.length, // 실제 상품 수로 변경
      itemBuilder: (context, index) {
        final productData = _productList[index];

        return GestureDetector(
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => ProductDetailScreen(ptIdx: productData.ptIdx),
              ),
            );
          },
          child: Container(
            decoration: const BoxDecoration(
              color: Colors.white,
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Stack(
                  children: [
                    ClipRRect(
                      borderRadius: const BorderRadius.all(Radius.circular(5)),
                      child: AspectRatio(
                        aspectRatio: 1/1,
                        child: Image.network(
                          productData.ptImg ?? "",
                          fit: BoxFit.cover,
                        ),
                      ),
                    ),
                    Positioned(
                      top: 0,
                      right: 0,
                      child: GestureDetector(
                        onTap: () async {

                          final pref = await SharedPreferencesManager.getInstance();
                          final mtIdx = pref.getMtIdx() ?? "";
                          if (mtIdx.isNotEmpty) {
                            Map<String, dynamic> requestData = {
                              'mt_idx' : mtIdx,
                              'pt_idx' : productData.ptIdx,
                            };

                            final defaultResponseDTO = await ref.read(StoreProductViewModelProvider.notifier).productLike(requestData);
                            if(defaultResponseDTO != null) {
                              if (defaultResponseDTO.result == true) {
                                setState(() {
                                  _productList.removeAt(index);
                                });
                              }
                            }
                          }
                        },
                        child: Image.asset(
                          productData.likeChk == "Y" ? 'assets/images/home/like_btn_fill.png' : 'assets/images/home/like_btn.png',
                          height: Responsive.getHeight(context, 34),
                          width: Responsive.getWidth(context, 34),
                          // 하트 내부를 채울 때만 색상 채우기, 채워지지 않은 상태는 투명 처리
                        ),
                      ),
                    ),
                  ],
                ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      margin: const EdgeInsets.only(top: 12, bottom: 4),
                      child: Text(
                        productData.stName ?? "",
                        style: TextStyle(
                          fontFamily: 'Pretendard',
                          fontSize: Responsive.getFont(context, 12),
                          color: Colors.grey,
                          height: 1.2,
                        ),
                      ),
                    ),
                    Text(
                      productData.ptName ?? "",
                      style: TextStyle(
                        fontFamily: 'Pretendard',
                        fontSize: Responsive.getFont(context, 14),
                        height: 1.2,
                      ),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                    Container(
                      margin: const EdgeInsets.only(top: 12, bottom: 10),
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.baseline,
                        textBaseline: TextBaseline.alphabetic,
                        children: [
                          Text(
                            '${productData.ptDiscountPer ?? 0}%',
                            style: TextStyle(
                              fontFamily: 'Pretendard',
                              fontSize: Responsive.getFont(context, 14),
                              color: const Color(0xFFFF6192),
                              fontWeight: FontWeight.bold,
                              height: 1.2,
                            ),
                          ),
                          Container(
                            margin: const EdgeInsets.symmetric(horizontal: 2),
                            child: Text(
                              "${Utils.getInstance().priceString(productData.ptPrice ?? 0)}원",
                              style: TextStyle(
                                fontFamily: 'Pretendard',
                                fontSize: Responsive.getFont(context, 14),
                                fontWeight: FontWeight.bold,
                                height: 1.2,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        SvgPicture.asset(
                          'assets/images/home/item_like.svg',
                          width: Responsive.getWidth(context, 13),
                          height: Responsive.getHeight(context, 11),
                        ),
                        Container(
                          margin: const EdgeInsets.only(left: 2, bottom: 2),
                          child: Text(
                            '${productData.ptLike ?? ""}',
                            style: TextStyle(
                              fontFamily: 'Pretendard',
                              fontSize: Responsive.getFont(context, 12),
                              color: Colors.grey,
                              height: 1.2,
                            ),
                          ),
                        ),
                        Container(
                          margin: const EdgeInsets.symmetric(horizontal: 10),
                          child: Row(
                            children: [
                              SvgPicture.asset(
                                'assets/images/home/item_comment.svg',
                                width: Responsive.getWidth(context, 13),
                                height: Responsive.getHeight(context, 12),
                              ),
                              Container(
                                margin: const EdgeInsets.only(left: 2, bottom: 2),
                                child: Text(
                                  '${productData.ptReview ?? ""}',
                                  style: TextStyle(
                                    fontFamily: 'Pretendard',
                                    fontSize: Responsive.getFont(context, 12),
                                    color: Colors.grey,
                                    height: 1.2,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ],
            ),
          ),
        );
      },
    );
  }
  void _afterBuild(BuildContext context) {
    _getCategoryList();
    _getList();
  }
  void _getCategoryList() async {
    Map<String, dynamic> requestData = {'category_type': '1'};
    final categoryResponseDTO = await ref.read(StoreProductViewModelProvider.notifier).getCategory(requestData);
    if (categoryResponseDTO != null) {
      if (categoryResponseDTO.result == true) {
        final list = categoryResponseDTO.list ?? [];
        for (var item in list) {
          categories.add(item);
        }

        setState(() {
          _tabController = TabController(length: categories.length, vsync: this);
          _tabController.addListener(_tabChangeCallBack);
        });
      }
    }
  }

  void _tabChangeCallBack() {
    _hasNextPage = true;
    _isLoadMoreRunning = false;

    _getList();
  }
  void _getList() async {
    setState(() {
      _isFirstLoadRunning = true;
    });
    _page = 1;
    final pref = await SharedPreferencesManager.getInstance();
    final mtIdx = pref.getMtIdx();

    String category = "all";
    final categoryData = categories[_tabController.index];
    if ((categoryData.ctIdx ?? 0) > 0) {
      category = categoryData.ctIdx.toString();
    }
    Map<String, dynamic> requestData = {
      'mt_idx': mtIdx,
      'st_idx': widget.stIdx,
      'category': category,
      'pg': _page,
    };

    final storeResponseDTO = await ref.read(StoreProductViewModelProvider.notifier).getStoreList(requestData);
    storeData = storeResponseDTO?.data;

    final productListResponseDTO = await ref.read(StoreProductViewModelProvider.notifier).getProductList(requestData);
    _count = productListResponseDTO?.list.length ?? 0;
    _productList = productListResponseDTO?.list ?? [];

    setState(() {
      _isFirstLoadRunning = false;
    });
  }
  void _nextLoad() async {

    if (_hasNextPage && !_isFirstLoadRunning && !_isLoadMoreRunning && _scrollController.position.extentAfter < 200){
      setState(() {
        _isLoadMoreRunning = true;
      });
      _page += 1;

      final pref = await SharedPreferencesManager.getInstance();
      final mtIdx = pref.getMtIdx();

      String category = "all";
      final categoryData = categories[_tabController.index];
      if ((categoryData.ctIdx ?? 0) > 0) {
        category = categoryData.ctIdx.toString();
      }

      Map<String, dynamic> requestData = {
        'mt_idx': mtIdx,
        'category': category,
        'sub_category': "all",
        'pg': _page,
      };

      final productListResponseDTO = await ref.read(StoreProductViewModelProvider.notifier).getProductList(requestData);
      if (productListResponseDTO != null) {
        _count = productListResponseDTO.list.length;
        if (productListResponseDTO.list.isNotEmpty) {
          setState(() {
            _productList.addAll(productListResponseDTO.list);
          });
        } else {
          setState(() {
            _hasNextPage = false;
          });
        }
      }

      setState(() {
        _isLoadMoreRunning = false;
      });
    }
  }
}
