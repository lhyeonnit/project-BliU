import 'package:BliU/data/product_data.dart';
import 'package:BliU/screen/_component/move_top_button.dart';
import 'package:BliU/screen/_component/non_data_screen.dart';
import 'package:BliU/screen/main/page_screen/like/view_model/like_view_model.dart';
import 'package:BliU/screen/main/view_model/main_view_model.dart';
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

  double _maxScrollHeight = 0;// NestedScrollView 사용시 최대 높이를 저장하기 위한 변수

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 1, vsync: this);
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _afterBuild(context);
    });
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  void _afterBuild(BuildContext context) {
    _getList();
  }

  void _getList() {
    _maxScrollHeight = 0;
    ref.read(likeViewModelProvider.notifier).listLoad(_tabController.index);
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
        body: Consumer(
          builder: (context, ref, widget) {
            ref.listen(
              mainViewModelProvider,
              ((previous, next) {
                final productCategories = next.productCategories;
                _tabController = TabController(length: productCategories.length, vsync: this)
                  ..addListener(() {
                    if (!_tabController.indexIsChanging) {
                      _getList();
                    }
                  });
              }),
            );

            final likeModel = ref.watch(likeViewModelProvider);
            final mainModel = ref.watch(mainViewModelProvider);
            final productCategories = mainModel.productCategories;

            final productList = likeModel.productList;
            final count = likeModel.count;
            final listEmpty = likeModel.listEmpty;

            return Stack(
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
                        ref.read(likeViewModelProvider.notifier).listNextLoad(_tabController.index);
                      }
                    }
                    return false;
                  },
                  child: NestedScrollView(
                    controller: _scrollController,
                    physics: productList.isEmpty ? const NeverScrollableScrollPhysics() : const BouncingScrollPhysics(),
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
                                  tabs: productCategories.map((category) {
                                    return Tab(text: category.ctName);
                                  }).toList(),
                                ),
                              ),
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
                            ],
                          ), // 상단 고정된 컨텐츠
                        )
                      ];
                    },
                    body: Visibility(
                      visible: !listEmpty,
                      child: TabBarView(
                        controller: _tabController,
                        physics: const NeverScrollableScrollPhysics(),
                        children: List.generate(
                          productCategories.length,
                              (index) {
                            if (index == _tabController.index) {
                              return _buildProductGrid(productList);
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
                  visible: !listEmpty,
                  child: MoveTopButton(scrollController: _scrollController),
                ),
                Visibility(
                  visible: listEmpty,
                  child: const NonDataScreen(text: '좋아요하신 상품이 없습니다.',),
                ),
              ],
            );
          },
        ),
      ),
    );
  }

  Widget _buildProductGrid(List<ProductData> productList) {
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
      itemCount: productList.length, // 실제 상품 수로 변경
      itemBuilder: (context, index) {
        final productData = productList[index];

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

                            ref.read(likeViewModelProvider.notifier).productLike(requestData, index);
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
