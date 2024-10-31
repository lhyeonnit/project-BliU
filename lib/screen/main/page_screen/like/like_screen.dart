import 'package:BliU/data/category_data.dart';
import 'package:BliU/data/product_data.dart';
import 'package:BliU/screen/_component/move_top_button.dart';
import 'package:BliU/screen/_component/non_data_screen.dart';
import 'package:BliU/screen/main/page_screen/like/view_model/like_view_model.dart';
import 'package:BliU/screen/product_detail/product_detail_screen.dart';
import 'package:BliU/utils/responsive.dart';
import 'package:BliU/utils/shared_preferences_manager.dart';
import 'package:BliU/utils/utils.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:focus_detector_v2/focus_detector_v2.dart';

class LikeScreen extends ConsumerStatefulWidget {
  const LikeScreen({super.key});

  @override
  ConsumerState<LikeScreen> createState() => LikeScreenState();
}

class LikeScreenState extends ConsumerState<LikeScreen> with TickerProviderStateMixin {
  final ScrollController _scrollController = ScrollController();
  late TabController _tabController;
  final List<CategoryData> _categories = [
    CategoryData(ctIdx: 0, cstIdx: 0, img: '', ctName: '전체', catIdx: 0, catName: '', subList: [])
  ];

  int _count = 0;
  List<ProductData> _productList = [];

  bool _listEmpty = false;

  double _maxScrollHeight = 0;// NestedScrollView 사용시 최대 높이를 저장하기 위한 변수

  int _page = 1;
  bool _hasNextPage = true;
  bool _isFirstLoadRunning = false;
  bool _isLoadMoreRunning = false;

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
    _tabController.removeListener(_tabChangeCallBack);
    _tabController.dispose();
    super.dispose();
  }

  void _afterBuild(BuildContext context) {
    _getCategoryList();
    _getList();
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
    _maxScrollHeight = 0;

    final pref = await SharedPreferencesManager.getInstance();
    final mtIdx = pref.getMtIdx();

    String category = "all";
    final categoryData = _categories[_tabController.index];
    if ((categoryData.ctIdx ?? 0) > 0) {
      category = categoryData.ctIdx.toString();
    }

    Map<String, dynamic> requestData = {
      'mt_idx': mtIdx,
      'category': category,
      'sub_category': "all",
      'pg': _page,
    };

    // setState(() {
    //   _count = 0;
    //   _productList = [];
    // });

    final productListResponseDTO = await ref.read(likeViewModelProvider.notifier).getList(requestData);
    _count = productListResponseDTO?.count ?? 0;
    _productList = productListResponseDTO?.list ?? [];

    setState(() {
      if (_productList.isNotEmpty) {
        _listEmpty = false;
      } else {
        _listEmpty = true;
      }
      _isFirstLoadRunning = false;
    });
  }

  void _nextLoad() async {

    if (_hasNextPage && !_isFirstLoadRunning && !_isLoadMoreRunning){
      setState(() {
        _isLoadMoreRunning = true;
      });
      _page += 1;

      final pref = await SharedPreferencesManager.getInstance();
      final mtIdx = pref.getMtIdx();

      String category = "all";
      final categoryData = _categories[_tabController.index];
      if ((categoryData.ctIdx ?? 0) > 0) {
        category = categoryData.ctIdx.toString();
      }

      Map<String, dynamic> requestData = {
        'mt_idx': mtIdx,
        'category': category,
        'sub_category': "all",
        'pg': _page,
      };

      final productListResponseDTO = await ref.read(likeViewModelProvider.notifier).getList(requestData);
      if (productListResponseDTO != null) {
        _count = productListResponseDTO.count;
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

  void _viewWillAppear(BuildContext context) {
    _getList();
  }

  @override
  Widget build(BuildContext context) {
    return FocusDetector(
      onFocusGained: () {
        _viewWillAppear(context);
      },
      child: Scaffold(
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
              color: const Color(0x0D000000), // 하단 구분선 색상
              height: 1.0, // 구분선의 두께 설정
              child: Container(
                height: 1.0, // 그림자 부분의 높이
                decoration: const BoxDecoration(
                  boxShadow: [
                    BoxShadow(
                      color: Color(0x0D000000),
                      blurRadius: 6.0,
                      spreadRadius: 0.1,
                      offset: Offset(0, 3),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
        body: Stack(
          children: [
            NotificationListener(
              onNotification: (scrollNotification){
                if (scrollNotification is ScrollEndNotification) {
                  var metrics = scrollNotification.metrics;
                  if (metrics.axisDirection != AxisDirection.down) return false;
                  if (_maxScrollHeight < metrics.maxScrollExtent) {
                    _maxScrollHeight = metrics.maxScrollExtent;
                  }
                  if (_maxScrollHeight - metrics.pixels < 50) {
                    _nextLoad();
                  }
                }
                return false;
              },
              child: NestedScrollView(
                controller: _scrollController,
                physics: _productList.isEmpty ? const NeverScrollableScrollPhysics() : const BouncingScrollPhysics(),
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
                          Container(
                            margin: const EdgeInsets.symmetric(horizontal: 16.0),
                            padding: const EdgeInsets.symmetric(vertical: 20),
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
                body: Visibility(
                  visible: !_listEmpty,
                  child: TabBarView(
                    controller: _tabController,
                    physics: const NeverScrollableScrollPhysics(),
                    children: List.generate(
                      _categories.length,
                          (index) {
                        if (index == _tabController.index) {
                          return _buildProductGrid();
                        } else {
                          return Container();
                        }
                      },
                    ),
                  ),
                ),
              ),
            ),
            Visibility(
              visible: !_listEmpty,
              child: MoveTopButton(scrollController: _scrollController),
            ),
            Visibility(
              visible: _listEmpty,
              child: const NonDataScreen(text: '좋아요하신 상품이 없습니다.',),
            ),
          ],
        ),
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
        childAspectRatio: 0.5,
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
                          errorBuilder: (BuildContext context, Object exception, StackTrace? stackTrace) {
                            return const SizedBox();
                          }
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

                            final defaultResponseDTO = await ref.read(likeViewModelProvider.notifier).productLike(requestData);
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
}
