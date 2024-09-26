import 'package:BliU/screen/_component/cart_screen.dart';
import 'package:BliU/screen/_component/move_top_button.dart';
import 'package:BliU/screen/_component/search_screen.dart';
import 'package:BliU/screen/product/component/detail/product_info_content.dart';
import 'package:BliU/screen/product/viewmodel/product_detail_view_model.dart';
import 'package:BliU/utils/responsive.dart';
import 'package:BliU/utils/shared_preferences_manager.dart';
import 'package:BliU/utils/utils.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'component/detail/product_ai.dart';
import 'component/detail/product_banner.dart';
import 'component/detail/product_info_before_order.dart';
import 'component/detail/product_info_title.dart';
import 'component/detail/product_inquiry.dart';
import 'component/detail/product_order_bottom_option.dart';
import 'component/detail/product_review_list.dart';

class ProductDetailScreen extends ConsumerStatefulWidget {
  final int? ptIdx;

  const ProductDetailScreen({super.key, required this.ptIdx});

  @override
  _ProductDetailScreenState createState() => _ProductDetailScreenState();
}

class _ProductDetailScreenState extends ConsumerState<ProductDetailScreen> {
  final ScrollController _scrollController = ScrollController();
  late int ptIdx;

  @override
  void initState() {
    super.initState();
    ptIdx = widget.ptIdx ?? 0;
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _afterBuild(context);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Consumer(builder: (context, ref, widget) {
      final model = ref.watch(productDetailModelProvider);

      if (model != null) {
        if (model.productDetailResponseDto?.result != true) {
          Future.delayed(Duration.zero, () {
            Utils.getInstance().showSnackBar(
                context, model.productDetailResponseDto?.message ?? "");
          });
          Navigator.pop(context);
          return const Scaffold();
        }
      }

      final store = model?.productDetailResponseDto?.store;
      final sameList = model?.productDetailResponseDto?.sameList ?? [];
      final product = model?.productDetailResponseDto?.product;
      final info = model?.productDetailResponseDto?.info;
      final reviewInfo = model?.reviewInfoResponseDTO?.reviewInfo;

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
                      MaterialPageRoute(
                          builder: (context) => const CartScreen()),
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
                    child: Text(
                      '2', // TODO 장바구니 수
                      style: TextStyle(
                        fontFamily: 'Pretendard',
                        color: Colors.white,
                        fontSize: Responsive.getFont(context, 12),
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
                    SliverToBoxAdapter(
                      child: Column(
                        children: [
                          ProductBanner(
                            imgArr: product?.imgArr ?? [],
                          ),
                          ProductInfoTitle(
                            storeData: store,
                            productData: product,
                          ),
                        ],
                      ),
                    ),
                  ];
                },
                body: Column(
                  children: [
                    TabBar(
                      overlayColor: WidgetStateColor.transparent,
                      indicatorColor: Colors.black,
                      dividerColor: const Color(0xFFDDDDDD),
                      indicatorSize: TabBarIndicatorSize.tab,
                      // 인디케이터가 각 탭의 길이에 맞게 조정됨
                      labelColor: Colors.black,
                      unselectedLabelColor: const Color(0xFF7B7B7B),
                      tabs: [
                        const Tab(text: '상세정보'),
                        Tab(text: '리뷰(${reviewInfo?.reviewCount ?? 0})'),
                      ],
                    ),
                    Expanded(
                      child: TabBarView(
                        children: [
                          // 첫 번째 탭: 상세정보에 모든 정보 포함
                          Container(
                            margin: const EdgeInsets.only(bottom: 50),
                            child: SingleChildScrollView(
                              child: Column(
                                children: [
                                  ProductInfoContent(
                                    content: product?.ptContent ?? "",
                                  ),
                                  ProductAi(
                                    productList: sameList,
                                  ),
                                  ProductInfoBeforeOrder(
                                    infoData: info,
                                  ),
                                  ProductInquiry(
                                    ptIdx: ptIdx,
                                  ),
                                ],
                              ),
                            ),
                          ),
                          // 두 번째 탭: 리뷰만 표시
                          ProductReview(ptIdx: ptIdx),
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
                    padding: const EdgeInsets.only(
                        top: 9, bottom: 8, left: 11, right: 10),
                    color: Colors.white,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        GestureDetector(
                          child: Container(
                            height: 48,
                            width: 48,
                            margin: const EdgeInsets.only(right: 9),
                            decoration: BoxDecoration(
                                borderRadius:
                                    const BorderRadius.all(Radius.circular(6)),
                                border:
                                    Border.all(color: const Color(0xFFDDDDDD))),
                            child: SvgPicture.asset(
                                'assets/images/product/like_lg_off.svg'),
                          ),
                        ),
                        Expanded(
                          child: GestureDetector(
                            onTap: () {
                              if (product != null) {
                                ProductOrderBottomOption.showBottomSheet(
                                    context, product);
                              }
                            },
                            child: Container(
                              height: 48,
                              decoration: const BoxDecoration(
                                color: Colors.black,
                                borderRadius: BorderRadius.all(
                                  Radius.circular(6),
                                ),
                              ),
                              child: Center(
                                child: Text(
                                  '구매하기',
                                  style: TextStyle(
                                    fontFamily: 'Pretendard',
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
    });
  }

  void _afterBuild(BuildContext context) {
    _getDetail();
  }

  void _getDetail() async {
    final pref = await SharedPreferencesManager.getInstance();

    Map<String, dynamic> requestData = {
      'mt_idx': pref.getMtIdx(),
      'pt_idx': ptIdx,
      'reload': 'N',
    };

    ref.read(productDetailModelProvider.notifier).getDetail(requestData);
  }
}
