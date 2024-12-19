import 'package:BliU/const/constant.dart';
import 'package:BliU/data/info_data.dart';
import 'package:BliU/data/product_data.dart';
import 'package:BliU/data/qna_data.dart';
import 'package:BliU/data/review_data.dart';
import 'package:BliU/data/store_data.dart';
import 'package:BliU/screen/_component/move_top_button.dart';
import 'package:BliU/screen/_component/top_cart_button.dart';
import 'package:BliU/screen/modal_dialog/message_dialog.dart';
import 'package:BliU/screen/modal_dialog/product_order_bottom_option.dart';
import 'package:BliU/screen/product_detail/view_model/product_detail_view_model.dart';
import 'package:BliU/screen/product_list/item/product_list_item.dart';
import 'package:BliU/utils/my_app_bar.dart';
import 'package:BliU/utils/responsive.dart';
import 'package:BliU/utils/shared_preferences_manager.dart';
import 'package:BliU/utils/utils.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_inappwebview/flutter_inappwebview.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:share_plus/share_plus.dart';

class ProductDetailScreen extends ConsumerStatefulWidget {
  const ProductDetailScreen({super.key});

  @override
  ConsumerState<ProductDetailScreen> createState() => ProductDetailScreenState();
}

class ProductDetailScreenState extends ConsumerState<ProductDetailScreen> {
  final ScrollController _scrollController = ScrollController();
  late int _ptIdx;

  StoreData? _storeData;
  ProductData? _productData;
  List<ProductData> _sameList = [];
  InfoData? _infoData;
  String _couponEnable = 'N';

  List<QnaData> _productQnaList = [];
  int _productQnaCount = 0;
  int _productQnaCurrentPage = 1;
  int _productQnaTotalPages = 1;

  List<ReviewData> _productReviewList = [];
  String _productReviewStarAvg = "0.0";
  int _productReviewCount = 0;
  int _productReviewCurrentPage = 1;
  int _productReviewTotalPages = 1;

  final PageController _bannerPageController = PageController();
  int _bannerCurrentPage = 0;
  bool _isDeliveryInfoVisible = false;
  bool _isExpanded = false;

  double _detailWebViewHeight = 300;
  double _deliveryWebViewHeight = 300;

  late InAppWebViewController? _detailWeViewController;

  final _infoThemeData = ThemeData(
    /// Prevents to splash effect when clicking.
    splashColor: Colors.transparent,

    /// Prevents the mouse cursor to highlight the tile when hovering on web.
    hoverColor: Colors.transparent,

    /// Hides the highlight color when the tile is pressed.
    highlightColor: Colors.transparent,

    /// Makes the top and bottom dividers invisible when expanded.
    dividerColor: Colors.transparent,

    /// Make background transparent.
    expansionTileTheme: const ExpansionTileThemeData(
      backgroundColor: Colors.transparent,
      collapsedBackgroundColor: Colors.transparent,
    ),
  );

  @override
  void initState() {
    super.initState();
    _ptIdx = 0;
    try {
      _ptIdx = int.parse(Get.parameters["pt_idx"].toString());
    } catch(e) {
      //
    }

    WidgetsBinding.instance.addPostFrameCallback((_) {
      _afterBuild(context);
    });
  }

  void _afterBuild(BuildContext context) {
    _getDetail();
    _getProductQnaList();
    _getProductReviewList();
  }

  void _getDetail() async {
    final pref = await SharedPreferencesManager.getInstance();

    Map<String, dynamic> requestData = {
      'mt_idx': pref.getMtIdx(),
      'pt_idx': _ptIdx,
      'reload': 'N',
    };

    final productDetailResponseDto = await ref.read(productDetailViewModelProvider.notifier).getDetail(requestData);
    if (productDetailResponseDto.result == true) {
      setState(() {
        _storeData = productDetailResponseDto.store;
        _productData = productDetailResponseDto.product;
        _sameList = productDetailResponseDto.sameList ?? [];
        _infoData = productDetailResponseDto.info;
        _couponEnable = productDetailResponseDto.couponEnable ?? 'N';

        String content = _contentAddHtml(_productData?.ptContent ?? "");
        _detailWeViewController?.loadData(data: content);
      });
    } else {
      if (!mounted) return;
      Navigator.pop(context);
    }
  }

  void _getProductReviewList() async {
    final pref = await SharedPreferencesManager.getInstance();
    final mtIdx = pref.getMtIdx() ?? "";

    Map<String, dynamic> requestData = {
      'mt_idx' : mtIdx,
      'pt_idx' : _ptIdx,
      'pg': _productReviewCurrentPage,
    };

    final reviewInfoResponseDTO = await ref.read(productDetailViewModelProvider.notifier).getProductReviewList(requestData);
    if (reviewInfoResponseDTO != null) {
      if (reviewInfoResponseDTO.result == true) {
        setState(() {
          _productReviewList = reviewInfoResponseDTO.list ?? [];
          _productReviewStarAvg = reviewInfoResponseDTO.reviewInfo?.startAvg ?? "0.0";
          _productReviewCount = reviewInfoResponseDTO.reviewInfo?.reviewCount ?? 0;
        });
      }
    }
  }

  void _getProductQnaList() async {
    final pref = await SharedPreferencesManager.getInstance();
    Map<String, dynamic> requestData = {
      'mt_idx': pref.getMtIdx(),
      'pt_idx': _ptIdx,
      'pg': _productQnaCurrentPage,
    };
    final qnaListResponseDTO = await ref.read(productDetailViewModelProvider.notifier).getProductQnaList(requestData);
    if (qnaListResponseDTO != null) {
      if (qnaListResponseDTO.result == true) {
        setState(() {
          _productQnaList = qnaListResponseDTO.list ?? [];
          _productQnaCount = qnaListResponseDTO.count ?? 0;
        });
      }
    }
  }

  void _productLike() async {
    final pref = await SharedPreferencesManager.getInstance();
    final mtIdx = pref.getMtIdx() ?? "";

    if (mtIdx.isEmpty) {
      if (!mounted) return;
      showDialog(
        context: context,
        builder: (context) {
          return const MessageDialog(
            title: "알림",
            message: "로그인이 필요합니다.",
          );
        }
      );
      return;
    }

    if (mtIdx.isNotEmpty) {
      Map<String, dynamic> requestData = {
        'mt_idx': mtIdx,
        'pt_idx': _productData?.ptIdx,
      };

      final defaultResponseDTO = await ref.read(productDetailViewModelProvider.notifier).productLike(requestData);
      if (defaultResponseDTO != null) {
        if (defaultResponseDTO.result == true) {
          setState(() {
            if (_productData?.likeChk == "Y") {
              _productData?.likeChk = "N";
            } else {
              _productData?.likeChk = "Y";
            }
          });
        }
      }
    }
  }

  void _toggleDeliveryInfo() {
    setState(() {
      _isDeliveryInfoVisible = !_isDeliveryInfoVisible;
    });
  }

  void _toggleExpansion() {
    // 현재 스크롤 위치를 기억
    final currentPosition = _scrollController.position.pixels;

    setState(() {
      _isExpanded = !_isExpanded;
    });

    // setState 후 스크롤 위치를 유지
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!_isExpanded) {
        // 접힐 때 원래 스크롤 위치로 돌아감
        _scrollController.jumpTo(currentPosition);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return PopScope(
      canPop: false,
      onPopInvokedWithResult: (bool didPop, Object? result) async {
        if (didPop) {
          return;
        }
        Navigator.pop(context, _productData?.likeChk);
      },
      child: Scaffold(
        backgroundColor: Colors.white,
        appBar: MyAppBar(
          appBar: AppBar(
            scrolledUnderElevation: 0,
            backgroundColor: Colors.white,
            leading: IconButton(
              icon: SvgPicture.asset("assets/images/product/ic_back.svg"),
              onPressed: () {
                Navigator.pop(context, _productData?.likeChk);
              },
            ),
            titleSpacing: -1.0,
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
            actions: [
              IconButton(
                icon: SvgPicture.asset("assets/images/product/ic_top_sch.svg",
                  height: Responsive.getHeight(context, 30),
                  width: Responsive.getWidth(context, 30),
                ),
                color: Colors.black,
                onPressed: () {
                  Navigator.pushNamed(context, '/search');
                },
              ),
              const TopCartButton(),
            ],
          ),
        ),
        body: SafeArea(
          child: Utils.getInstance().isWebView(
            Stack(
              children: [
                DefaultTabController(
                  length: 2, // 두 개의 탭
                  child: NestedScrollView(
                    controller: _scrollController,
                    headerSliverBuilder: (BuildContext context, bool innerBoxIsScrolled) {
                      return <Widget>[
                        SliverToBoxAdapter(
                          child: Column(
                            children: [
                              _productBanner(_productData?.imgArr ?? []),
                              _productInfoTitle(_storeData, _productData),
                              Container(
                                margin: const EdgeInsets.symmetric(vertical: 20),
                                height: 10,
                                decoration: const BoxDecoration(
                                  color: Color(0xFFF5F9F9),
                                ),
                              ),
                              TabBar(
                                overlayColor: WidgetStateColor.transparent,
                                indicatorColor: Colors.black,
                                dividerColor: const Color(0xFFDDDDDD),
                                indicatorSize: TabBarIndicatorSize.tab,
                                // 인디케이터가 각 탭의 길이에 맞게 조정됨
                                labelColor: Colors.black,
                                unselectedLabelColor: const Color(0xFF7B7B7B),
                                isScrollable: true,
                                // here
                                tabAlignment: TabAlignment.start,
                                // ** Use TabAlignment.start
                                tabs: [
                                  const Tab(text: '상세정보'),
                                  Tab(text: '리뷰($_productReviewCount)'),
                                ],
                              ),
                            ],
                          ),
                        ),
                      ];
                    },
                    body: Column(
                      children: [
                        Expanded(
                          child: TabBarView(
                            children: [
                              // 첫 번째 탭: 상세정보에 모든 정보 포함
                              SingleChildScrollView(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    _productInfoContent(_productData?.ptContent ?? ""),
                                    _productAi(_sameList),
                                    _productInfoBeforeOrder(_infoData, _productData),
                                    _productInquiry(),
                                  ],
                                ),
                              ),
                              // 두 번째 탭: 리뷰만 표시
                              _productReview(),
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
                        padding: const EdgeInsets.only(top: 9, bottom: 8, left: 11, right: 10),
                        color: Colors.white,
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            GestureDetector(
                              onTap: () {
                                _productLike();
                              },
                              child: Container(
                                height: 48,
                                width: 48,
                                margin: const EdgeInsets.only(right: 9),
                                decoration: BoxDecoration(
                                  borderRadius: const BorderRadius.all(Radius.circular(6)),
                                  border: Border.all(color: const Color(0xFFDDDDDD)),
                                ),
                                child: SvgPicture.asset(
                                  _productData?.likeChk == "Y"
                                      ? 'assets/images/product/like_lg_on.svg'
                                      : 'assets/images/product/like_lg_off.svg',
                                ),
                              ),
                            ),
                            Expanded(
                              child: GestureDetector(
                                onTap: () {
                                  if (_productData != null) {
                                    if (_productData?.sellStatus == "Y") {
                                      ProductOrderBottomOption.showBottomSheet(context, _productData!);
                                    }
                                  }
                                },
                                child: Container(
                                  height: 48,
                                  decoration: BoxDecoration(
                                    color: _productData?.sellStatus == "Y" ? Colors.black : const Color(0xFFDDDDDD),
                                    borderRadius: const BorderRadius.all(
                                      Radius.circular(6),
                                    ),
                                  ),
                                  child: Center(
                                    child: Text(
                                      _productData?.sellStatusTxt ?? "",
                                      style: TextStyle(
                                        fontFamily: 'Pretendard',
                                        fontSize: Responsive.getFont(context, 14),
                                        color: Colors.white,
                                        height: 1.2,
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
          ),
        ),
      ),
    );
  }

  String _contentAddHtml(String content) {
    content = content.trim();
    return content = """
    <html>
    <head>
    <meta name="viewport" content="width=device-width, initial-scale=1.0" />
    </head>
    <body>
    <style>
			html { font-size:10px; }
			.ql-align-right {
        text-align: right;
      }
      .ql-align-center {
        text-align: center;
      }
      .ql-align-left {
        text-align: left;
      }
      .ql-size-small {
        font-size: 0.75em;
      }
      .ql-size-large {
        font-size: 1.5em;
      }
      .ql-size-huge {
        font-size: 2.5em;
      }
      img { max-width:100%; display:inline-block; height: auto; }
		</style>
    $content
    </body>
    </html>
    """;
  }

  Widget _productBanner(List<String> imgArr) {
    return AspectRatio(
      aspectRatio: 1,
      // width: screenWidth, // 가로 길이를 화면 전체로 설정
      // height: screenWidth, // 세로 길이도 가로 길이와 동일하게 설정
      child: Stack(
        children: [
          PageView.builder(
            controller: _bannerPageController,
            itemCount: imgArr.length,
            onPageChanged: (int page) {
              setState(() {
                _bannerCurrentPage = page;
              });
            },
            itemBuilder: (context, index) {
              return ClipRRect(
                child: CachedNetworkImage(
                  imageUrl: imgArr[index],
                  width: double.infinity,
                  height: double.infinity,
                  fit: BoxFit.cover, // 이미지가 컨테이너를 꽉 채우도록 설정
                  placeholder: (context, url) {
                    return const Center(
                      child: CircularProgressIndicator(),
                    );
                  },
                  errorWidget: (context, url, error) {
                    return SvgPicture.asset(
                      'assets/images/no_imge.svg',
                      width: double.infinity,
                      height: double.infinity,
                      fit: BoxFit.fitWidth,
                    );
                  },
                ),
              );
            },
          ),
          Positioned(
            bottom: 15,
            right: 16,
            child: Container(
              padding: const EdgeInsets.symmetric(vertical: 4, horizontal: 15),
              decoration: const BoxDecoration(
                color: Color(0x45000000),
                borderRadius: BorderRadius.all(Radius.circular(22)),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    '${_bannerCurrentPage + 1}',
                    style: TextStyle(
                      fontFamily: 'Pretendard',
                      fontSize: Responsive.getFont(context, 13),
                      color: Colors.white,
                      height: 1.2,
                    ),
                  ),
                  Text(
                    '/${imgArr.length}',
                    style: TextStyle(
                      fontFamily: 'Pretendard',
                      fontSize: Responsive.getFont(context, 13),
                      color: const Color(0x80FFFFFF),
                      height: 1.2,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _productInfoTitle(StoreData? storeData, ProductData? productData) {
    // 배송비 정보
    final deliveryBasicPrice = productData?.deliveryInfo?.deliveryDetail?.deliveryBasicPrice ?? 0;
    String deliveryBasicPriceStr1 = '';
    String deliveryBasicPriceStr2 = '';
    if (deliveryBasicPrice == 0) {
      deliveryBasicPriceStr1 = "무료배송";
      deliveryBasicPriceStr2 = "무료";
    } else {
      deliveryBasicPriceStr1 = "${Utils.getInstance().priceString(deliveryBasicPrice)}원";
      deliveryBasicPriceStr2 = "기본 배송비 ${Utils.getInstance().priceString(deliveryBasicPrice)}원";
    }

    final deliveryMinPrice = productData?.deliveryInfo?.deliveryDetail?.deliveryMinPrice ?? 0;
    final deliveryMinPriceStr = Utils.getInstance().priceString(deliveryMinPrice);

    // final deliveryPrice = productData?.deliveryInfo?.deliveryPrice ?? 0;
    // String deliveryPriceStr1 = '';
    // String deliveryPriceStr2 = '';
    // if (deliveryPrice == 0) {
    //   deliveryPriceStr1 = '무료배송';
    //   deliveryPriceStr2 = '무료';
    // } else {
    //   deliveryPriceStr1 = '${Utils.getInstance().priceString(deliveryPrice)}원';
    //   deliveryPriceStr2 = '${Utils.getInstance().priceString(deliveryPrice)}원';
    // }

    String deliveryPriceInfoStr1 = '';
    String deliveryPriceInfoStr2 = '';

    if (productData?.ptDelivery == 1) {
      deliveryPriceInfoStr1 = "무료배송";
      deliveryPriceInfoStr2 = "배송비: 무료";
    } else {
      if (productData?.deliveryInfo?.deliveryDetail?.deliveryPriceType == 1) {
        deliveryPriceInfoStr1 = deliveryBasicPriceStr1;
        deliveryPriceInfoStr2 = "배송비 : $deliveryBasicPriceStr2";
      } else {
        deliveryPriceInfoStr1 = "$deliveryBasicPriceStr1 ($deliveryMinPriceStr원 이상 무료)";
        deliveryPriceInfoStr2 = "배송비 : $deliveryBasicPriceStr2 / $deliveryMinPriceStr원 이상 무료";
      }
    }

    print("productData?.ptDelivery ${productData?.ptDelivery} /// deliveryPriceInfoStr1 ${deliveryPriceInfoStr1} //// deliveryPriceInfoStr2 $deliveryPriceInfoStr2");

    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // 로고 버튼
              GestureDetector(
                onTap: () {
                  Navigator.pushNamed(context, '/store_detail/${storeData?.stIdx ?? 0}');
                },
                child: ClipRect(
                  child: Container(
                    margin: const EdgeInsets.only(top: 9, right: 10),
                    width: 50,
                    height: 50,
                    decoration: BoxDecoration(
                      border: Border.all(color: const Color(0xFFDDDDDD)),
                      shape: BoxShape.circle, // 이미지를 동그랗게 만들기
                    ),
                    child: ClipOval(
                      child: CachedNetworkImage(
                        imageUrl: storeData?.stProfile ?? "",
                        width: double.infinity,
                        height: double.infinity,
                        fit: BoxFit.cover,
                        placeholder: (context, url) {
                          return const Center(
                            child: CircularProgressIndicator(),
                          );
                        },
                        errorWidget: (context, url, error) {
                          return SvgPicture.asset(
                            'assets/images/no_imge.svg',
                            width: double.infinity,
                            height: double.infinity,
                            fit: BoxFit.fitWidth,
                          );
                        },
                      ),
                    ),
                  ),
                ),
              ),
              // 나머지 텍스트와 공유 버튼을 포함한 컬럼
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // 첫 번째 줄: 브랜드명, 공유 버튼
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        // 브랜드명 및 화살표 버튼
                        GestureDetector(
                          onTap: () {
                            // 브랜드명 버튼 동작
                            Navigator.pushNamed(context, '/store_detail/${storeData?.stIdx ?? 0}');
                          },
                          child: Row(
                            children: [
                              Text(
                                storeData?.stName ?? "", // 브랜드명
                                style: TextStyle(
                                  fontFamily: 'Pretendard',
                                  color: const Color(0xFF7B7B7B),
                                  fontSize: Responsive.getFont(context, 13),
                                  height: 1.2,
                                ),
                              ),
                              Container(
                                height: 15,
                                width: 15,
                                margin: const EdgeInsets.symmetric(horizontal: 5),
                                child: SvgPicture.asset(
                                  'assets/images/product/ic_more_arrow.svg',
                                  colorFilter: const ColorFilter.mode(
                                    Color(0xFF7B7B7B),
                                    BlendMode.srcIn,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                        const Spacer(), // 공간을 채워서 오른쪽 정렬
                        // 공유 버튼
                        GestureDetector(
                          child: SvgPicture.asset(
                            'assets/images/product/ic_share.svg',
                            width: 24,
                            height: 24,
                          ),
                          onTap: () {
                            String productUrl = "${Constant.apiShareUrl}?type=product&idx=${_productData?.ptIdx}"; // 고유한 URL 생성
                            Share.share('${_productData?.ptName ?? ''}: $productUrl');
                          },
                        ),
                      ],
                    ),
                    // 상품 제목
                    Container(
                      margin: const EdgeInsets.only(top: 6, bottom: 10),
                      child: Text(
                        productData?.ptName ?? "",
                        style: TextStyle(
                          fontFamily: 'Pretendard',
                          fontSize: Responsive.getFont(context, 16),
                          fontWeight: FontWeight.bold,
                          height: 1.2,
                        ),
                      ),
                    ),
                    // 가격 정보
                    Row(
                      children: [
                        Visibility(
                          visible: (productData?.ptDiscountPer ?? 0) > 0 ? true : false,
                          child: Container(
                            margin: const EdgeInsets.only(right: 6),
                            child: Text(
                              "${productData?.ptDiscountPer ?? 0}%",
                              // 할인률
                              style: TextStyle(
                                fontFamily: 'Pretendard',
                                fontSize: Responsive.getFont(context, 18),
                                color: const Color(0xFFFF6192),
                                fontWeight: FontWeight.bold,
                                height: 1.2,
                              ),
                            ),
                          ),
                        ),
                        Container(
                          margin: const EdgeInsets.only(right: 5),
                          child: Text(
                            '${Utils.getInstance().priceString(productData?.ptPrice ?? 0)}원', // 할인된 가격
                            style: TextStyle(
                              fontFamily: 'Pretendard',
                              fontSize: Responsive.getFont(context, 18),
                              fontWeight: FontWeight.bold,
                              height: 1.2,
                            ),
                          ),
                        ),
                        Visibility(
                          visible: (productData?.ptDiscountPer ?? 0) > 0 ? true : false,
                          child: Stack(
                            children: [
                              // 원래 텍스트 (원래 가격)
                              Text(
                                '${Utils.getInstance().priceString(productData?.ptSellingPrice ?? 0)}원',
                                style: TextStyle(
                                  fontFamily: 'Pretendard',
                                  fontSize: Responsive.getFont(context, 14),
                                  color: const Color(0xFFABABAB),
                                  height: 1.2,
                                ),
                              ),
                              // 커스텀 취소선
                              Positioned(
                                top: 7, // 텍스트 가운데쯤에 맞춰서 위치
                                left: 0,
                                right: 0,
                                child: Container(
                                  height: 1, // 선의 두께
                                  color: const Color(0xFFABABAB), // 취소선 색상
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                    Visibility(
                      visible: (_productData?.ptDeliveryNow ?? "") == "Y",
                      child: Container(
                        margin: const EdgeInsets.only(top: 10),
                        child: Image.asset(
                          'assets/images/product/ic_today_start.png',
                          width: 65,
                          height: 22,
                        ),
                      ),
                    )
                  ],
                ),
              ),
            ],
          ),
          // 구분선
          Container(
            margin: const EdgeInsets.symmetric(vertical: 30),
            decoration: BoxDecoration(
              border: Border.all(color: const Color(0xFFEEEEEE), width: 0.5),
            ),
          ),
          // 배송비 정보
          Column(
            children: [
              GestureDetector(
                onTap: _toggleDeliveryInfo,
                child: Row(
                  children: [
                    Container(
                      margin: const EdgeInsets.only(right: 30),
                      child: Text(
                        '배송비', // 배송비 텍스트
                        style: TextStyle(
                          fontFamily: 'Pretendard',
                          fontSize: Responsive.getFont(context, 14),
                          color: const Color(0xFF7B7B7B),
                          height: 1.2,
                        ),
                      ),
                    ),
                    Expanded(
                      child: Row(
                        children: [
                          Text(
                            deliveryPriceInfoStr1,
                            style: TextStyle(
                              fontFamily: 'Pretendard',
                              fontSize: Responsive.getFont(context, 14),
                              color: Colors.black,
                              fontWeight: FontWeight.w400,
                              height: 1.2,
                            ),
                          ),
                          Container(
                            margin: const EdgeInsets.symmetric(horizontal: 5),
                            child: SvgPicture.asset(
                              'assets/images/product/ic_more_arrow.svg',
                              colorFilter: const ColorFilter.mode(
                                Color(0xFF7B7B7B),
                                BlendMode.srcIn,
                              ),
                            )
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              Visibility(
                visible: _isDeliveryInfoVisible,
                child: Container(
                  padding: const EdgeInsets.all(12),
                  margin: const EdgeInsets.symmetric(vertical: 10),
                  decoration: BoxDecoration(
                    border: Border.all(color: const Color(0xFFDDDDDD)),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        '택배사: ${productData?.deliveryInfo?.deliveryDetail?.deliveryCompany ?? ""}',
                        style: TextStyle(
                          fontFamily: 'Pretendard',
                          fontSize: Responsive.getFont(context, 12),
                          fontWeight: FontWeight.bold,
                          height: 1.2,
                        ),
                      ),
                      const SizedBox(height: 5),
                      Text(
                        deliveryPriceInfoStr2,
                        style: TextStyle(
                          fontFamily: 'Pretendard',
                          fontSize: Responsive.getFont(context, 10),
                          height: 1.2,
                        ),
                      ),
                      const SizedBox(height: 5),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            '제주/도서산간 추가배송비: ${Utils.getInstance().priceString(
                                productData?.deliveryInfo?.deliveryDetail?.deliveryAddPrice1 ?? 0
                            )}원',
                            style: TextStyle(
                              fontFamily: 'Pretendard',
                              fontSize: Responsive.getFont(context, 10),
                              height: 1.2,
                            ),
                          ),
                          // Text(
                          //   '제주 추가배송비: ${Utils.getInstance().priceString(
                          //     productData?.deliveryInfo?.deliveryDetail?.deliveryAddPrice2 ?? 0
                          //   )}원',
                          //   style: TextStyle(
                          //     fontFamily: 'Pretendard',
                          //     fontSize: Responsive.getFont(context, 10),
                          //     height: 1.2,
                          //   ),
                          // ),
                        ],
                      ),
                      const SizedBox(height: 5),
                      Text(
                        '배송 기간: 평균 2-5일 이내 발송 (영업일 기준), 재고현황에 따라 배송이 다소 지연될 수 있습니다.',
                        style: TextStyle(
                          fontFamily: 'Pretendard',
                          fontSize: Responsive.getFont(context, 10),
                          height: 1.2,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              Visibility(
                visible: _couponEnable == 'Y' ? true : false,
                child: Container(
                  margin: const EdgeInsets.only(top: 8),
                  child: Row(
                    children: [
                      Container(
                        margin: const EdgeInsets.only(right: 40),
                        child: Text(
                          '쿠폰',
                          style: TextStyle(
                            fontFamily: 'Pretendard',
                            fontSize: Responsive.getFont(context, 14),
                            color: const Color(0xFF7B7B7B),
                            height: 1.2,
                          ),
                        ),
                      ),
                      GestureDetector(
                        onTap: () {
                          Navigator.pushNamed(context, '/coupon_receive/$_ptIdx');
                        },
                        child: Container(
                          decoration: BoxDecoration(
                            border: Border.all(color: const Color(0xFFDDDDDD)),
                            borderRadius: BorderRadius.circular(6),
                          ),
                          child: Padding(
                            padding: const EdgeInsets.symmetric(vertical: 3.0, horizontal: 8),
                            child: Text(
                              '쿠폰 다운로드',
                              style: TextStyle(
                                fontFamily: 'Pretendard',
                                fontSize: Responsive.getFont(context, 14),
                                color: Colors.black,
                                height: 1.2,
                              ),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          )
        ],
      ),
    );
  }

  Widget _productInfoContent(String content) {
    content = _contentAddHtml(content);

    return SingleChildScrollView(
      // 페이지 전체를 스크롤 가능하게 만듦
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 30),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // 내용이 들어가는 영역
            AnimatedSize(
              duration: const Duration(milliseconds: 500),
              child: Container(
                height: _detailWebViewHeight,
                constraints: BoxConstraints(
                  minHeight: _isExpanded ? 500 : 500,
                  maxHeight: _isExpanded ? double.infinity : 500,
                ),
                child: InAppWebView(
                  initialData: InAppWebViewInitialData(data: content),
                  initialSettings: InAppWebViewSettings(
                    transparentBackground: true,
                    supportZoom: false,
                  ),
                  onWebViewCreated: (controller) {
                    _detailWeViewController = controller;
                  },
                  onProgressChanged: (controller, progress) {
                    if (progress == 100) {
                      Future.delayed(const Duration(seconds: 2), () {
                        controller.getContentHeight().then((height) {
                          setState(() {
                            _detailWebViewHeight = double.parse(height.toString());
                          });
                        });
                      });
                    }
                  },
                ),
              ),
            ),
            // 버튼
            GestureDetector(
              onTap: _toggleExpansion,
              child: Container(
                margin: const EdgeInsets.only(top: 10.0),
                padding: const EdgeInsets.symmetric(vertical: 14.0),
                decoration: BoxDecoration(
                  border: Border.all(color: const Color(0xFFDDDDDD)),
                  borderRadius: BorderRadius.circular(8.0),
                  color: Colors.white,
                ),
                alignment: Alignment.center,
                child: Text(
                  _isExpanded ? "상품 정보 접기" : "상품 정보 펼쳐보기",
                  style: TextStyle(
                    fontFamily: 'Pretendard',
                    fontSize: Responsive.getFont(context, 14),
                    fontWeight: FontWeight.w400,
                    height: 1.2,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _productAi(List<ProductData> productList) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 16.0),
          margin: const EdgeInsets.only(top: 40),
          child: Text(
            '연관 상품',
            style: TextStyle(
              fontFamily: 'Pretendard',
              fontSize: Responsive.getFont(context, 20),
              fontWeight: FontWeight.bold,
              height: 1.2,
            ),
          ),
        ),
        Container(
          height: 320,
          margin: const EdgeInsets.only(top: 20),
          child: ListView.builder(
            shrinkWrap: true,
            scrollDirection: Axis.horizontal, // 가로 스크롤 가능하도록 설정
            itemCount: productList.length, // 임의의 연관 상품 갯수
            itemBuilder: (context, index) {
              final productData = productList[index];

              return Container(
                margin: EdgeInsets.only(left: index == 0 ? 16 : 0),
                padding: const EdgeInsets.only(right: 12),
                child: SizedBox(
                  width: 160, // 가로 너비를 160으로 고정
                  child: ProductListItem(productData: productData),
                ),
              );
            },
          ),
        ),
      ],
    );
  }

  Widget _productInfoBeforeOrder(InfoData? infoData, ProductData? productData) {
    final deliveryBasicPrice = productData?.deliveryInfo?.deliveryDetail?.deliveryBasicPrice ?? 0;
    String deliveryBasicPriceStr = '';
    if (deliveryBasicPrice == 0) {
      deliveryBasicPriceStr = "무료";
    } else {
      deliveryBasicPriceStr = "기본 배송비 ${Utils.getInstance().priceString(deliveryBasicPrice)}원";
    }

    final deliveryMinPrice = productData?.deliveryInfo?.deliveryDetail?.deliveryMinPrice ?? 0;
    final deliveryMinPriceStr = Utils.getInstance().priceString(deliveryMinPrice);

    String deliveryPriceInfoStr = '';

    if (productData?.ptDelivery == 1) {
      deliveryPriceInfoStr = "배송비: 무료";
    } else {
      if (productData?.deliveryInfo?.deliveryDetail?.deliveryPriceType == 1) {
        deliveryPriceInfoStr = "배송비 : $deliveryBasicPriceStr";
      } else {
        deliveryPriceInfoStr = "배송비 : $deliveryBasicPriceStr / $deliveryMinPriceStr원 이상 무료";
      }
    }

    return Container(
      margin: const EdgeInsets.only(top: 30),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // 상단 배너
          Container(
            margin: const EdgeInsets.only(left: 16, right: 16),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(8),
              child: Image.asset(
                'assets/images/product/check_before@2x.png',
                height: 80,
              ),
            ),
          ),
          // 배송 안내 섹션
          Theme(
            data: _infoThemeData,
            // 선 제거
            child: ExpansionTile(
              initiallyExpanded: false,
              title: Text(
                '배송안내',
                style: TextStyle(
                  fontFamily: 'Pretendard',
                  fontWeight: FontWeight.bold,
                  fontSize: Responsive.getFont(context, 14),
                  height: 1.2,
                ),
              ),
              children: [
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 16.0),
                  child: Container(
                    decoration: BoxDecoration(
                      color: const Color(0xFFF5F9F9),
                      borderRadius: BorderRadius.circular(6.0),
                    ),
                    padding: const EdgeInsets.all(16.0),
                    child: SizedBox(
                      width: double.infinity,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: [
                              Expanded(
                                flex: 3,
                                child: Text(
                                  "택배사",
                                  style: TextStyle(
                                    fontFamily: 'Pretendard',
                                    color: const Color(0xFF7B7B7B),
                                    fontSize: Responsive.getFont(context, 14),
                                    height: 1.2,
                                  ),
                                ),
                              ),
                              Expanded(
                                flex: 7,
                                child: Text(
                                  productData?.deliveryInfo?.deliveryDetail?.deliveryCompany ?? "",
                                  style: TextStyle(
                                    fontFamily: 'Pretendard',
                                    fontSize: Responsive.getFont(context, 14),
                                    height: 1.2,
                                  ),
                                ),
                              ),
                            ],
                          ),
                          Container(
                            margin: const EdgeInsets.symmetric(vertical: 4),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.start,
                              children: [
                                Expanded(
                                  flex: 3,
                                  child: Text(
                                    "배송비",
                                    style: TextStyle(
                                      fontFamily: 'Pretendard',
                                      color: const Color(0xFF7B7B7B),
                                      fontSize: Responsive.getFont(context, 14),
                                      height: 1.2,
                                    ),
                                  ),
                                ),
                                Expanded(
                                  flex: 7,
                                  child: Text(
                                    deliveryPriceInfoStr,
                                    style: TextStyle(
                                      fontFamily: 'Pretendard',
                                      fontSize: Responsive.getFont(context, 14),
                                      height: 1.2,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                          Container(
                            margin: const EdgeInsets.symmetric(vertical: 4),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.start,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Expanded(
                                  flex: 3,
                                  child: Text(
                                    "추가 배송비",
                                    style: TextStyle(
                                      fontFamily: 'Pretendard',
                                      color: const Color(0xFF7B7B7B),
                                      fontSize: Responsive.getFont(context, 14),
                                      height: 1.2,
                                    ),
                                  ),
                                ),
                                Expanded(
                                  flex: 7,
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        '제주/도서산간 추가배송비 ${Utils.getInstance().priceString(
                                            productData?.deliveryInfo?.deliveryDetail?.deliveryAddPrice1 ?? 0
                                        )}원',
                                        style: TextStyle(
                                          fontFamily: 'Pretendard',
                                          fontSize: Responsive.getFont(context, 14),
                                          height: 1.2,
                                        ),
                                      ),
                                      // Text(
                                      //   '제주 추가배송비 ${Utils.getInstance().priceString(
                                      //       productData?.deliveryInfo?.deliveryDetail?.deliveryAddPrice2 ?? 0
                                      //   )}원',
                                      //   style: TextStyle(
                                      //     fontFamily: 'Pretendard',
                                      //     fontSize: Responsive.getFont(context, 14),
                                      //     height: 1.2,
                                      //   ),
                                      // ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.start,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Expanded(
                                flex: 3,
                                child: Text(
                                  "배송 기간",
                                  style: TextStyle(
                                    fontFamily: 'Pretendard',
                                    color: const Color(0xFF7B7B7B),
                                    fontSize: Responsive.getFont(context, 14),
                                    height: 1.2,
                                  ),
                                ),
                              ),
                              Expanded(
                                flex: 7,
                                child: Text(
                                  '평균 2-5일 이내 발송 (영업일 기준), 재고현황에 따라 배송이 다소 지연될 수 있습니다.',
                                  style: TextStyle(
                                    fontFamily: 'Pretendard',
                                    fontSize: Responsive.getFont(context, 14),
                                    height: 1.2,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
          // 교환/반품 안내 섹션
          Theme(
            //data: Theme.of(context).copyWith(dividerColor: Colors.transparent),
            data: _infoThemeData,
            // 선 제거
            child: ExpansionTile(
              initiallyExpanded: false,
              title: Text(
                '교환/반품 안내',
                style: TextStyle(
                  fontFamily: 'Pretendard',
                  fontWeight: FontWeight.bold,
                  fontSize: Responsive.getFont(context, 14),
                  height: 1.2,
                ),
              ),
              children: [
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 16.0),
                  child: Container(
                    width: double.infinity,
                    decoration: BoxDecoration(
                      color: const Color(0xFFF5F9F9),
                      borderRadius: BorderRadius.circular(6.0),
                    ),
                    padding: const EdgeInsets.all(16.0),
                    child: SizedBox(
                      height: _deliveryWebViewHeight,
                      child: InAppWebView(
                        initialFile: "assets/html/exchange.html",
                        initialSettings: InAppWebViewSettings(
                          transparentBackground: true,
                        ),
                        onProgressChanged: (controller, progress) {
                          if (progress == 100) {
                            controller.getContentHeight().then((height) {
                              setState(() {
                                _deliveryWebViewHeight = double.parse(height.toString());
                              });
                            });
                            Future.delayed(const Duration(seconds: 1), () {
                              controller.getContentHeight().then((height) {
                                setState(() {
                                  _deliveryWebViewHeight = double.parse(height.toString());
                                });
                              });
                            });
                          }
                        },
                        onZoomScaleChanged: (controller, o, n) {
                          controller.reload();
                        },
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
          //상품정보제공 공시
          Theme(
            data: _infoThemeData,
            child: ExpansionTile(
              initiallyExpanded: false,
              title: Text(
                '상품정보제공고시',
                style: TextStyle(
                  fontFamily: 'Pretendard',
                  fontWeight: FontWeight.bold,
                  fontSize: Responsive.getFont(context, 14),
                  height: 1.2,
                ),
              ),
              children: [
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 16.0),
                  child: Text(
                    '본 상품 정보의 내용은 공정거래위원회 ‘상품정보제공고시’ 에 따라 판매자가 직접 등록한 것으로 해당 정보에 대한 책임은 판매자에게 있습니다.',
                    style: TextStyle(
                      fontFamily: 'Pretendard',
                      fontSize: Responsive.getFont(context, 14),
                      color: const Color(0xFF7B7B7B),
                      height: 1.2,
                    ),
                  ),
                ),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 16.0),
                  margin: const EdgeInsets.only(top: 20),
                  child: _makeProductInfoTable(),
                )
              ],
            ),
          ),
          // 판매자정보
          Theme(
            data: _infoThemeData,
            child: ExpansionTile(
              initiallyExpanded: false,
              title: Text(
                '판매자정보',
                style: TextStyle(
                  fontFamily: 'Pretendard',
                  fontWeight: FontWeight.bold,
                  fontSize: Responsive.getFont(context, 14),
                  height: 1.2,
                ),
              ),
              children: [
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 16.0),
                  child: _makeSellerInfoTable(),
                ),
              ],
            ),
          )
        ],
      ),
    );
  }

  Widget _productInquiry() {
    if (_productQnaCount > 0) {
      _productQnaTotalPages = (_productQnaCount ~/ 10);
      if ((_productQnaCount % 10) > 0) {
        _productQnaTotalPages = _productQnaTotalPages + 1;
      }
    }

    String currentPageStr = _productQnaCurrentPage.toString();
    if (_productQnaCurrentPage < 10) {
      currentPageStr = "0$_productQnaCurrentPage";
    }

    String totalPagesStr = _productQnaTotalPages.toString();
    if (_productQnaTotalPages < 10) {
      totalPagesStr = "0$_productQnaTotalPages";
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          margin: const EdgeInsets.symmetric(vertical: 20),
          height: 10,
          decoration: const BoxDecoration(
            color: Color(0xFFF5F9F9),
          ),
        ),
        Container(
          width: double.infinity,
          padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 20),
          decoration: const BoxDecoration(
            border: Border(bottom: BorderSide(color: Color(0xFFEEEEEE))),
          ),
          child: Text(
            '상품문의',
            style: TextStyle(
              fontFamily: 'Pretendard',
              fontSize: Responsive.getFont(context, 20),
              fontWeight: FontWeight.bold,
              height: 1.2,
            ),
          ),
        ),
        Visibility(
          visible: _productQnaList.isNotEmpty,
          child: ListView(
            shrinkWrap: true,
            // 리스트가 다른 스크롤뷰 내에 있으므로 높이 제한
            physics: const NeverScrollableScrollPhysics(),
            children: [
            ...List.generate(_productQnaList.length, (index) {
              final qnaData = _productQnaList[index];
              final qtStatus = qnaData.qtStatus;
              final myQna = qnaData.myQna;
              return Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    margin: const EdgeInsets.symmetric(horizontal: 16),
                    padding: const EdgeInsets.only(top: 20),
                    child: Row(
                      children: [
                        Text(
                          qtStatus == "Y" ? '답변완료' : '미답변',
                          style: TextStyle(
                            fontFamily: 'Pretendard',
                            fontSize: Responsive.getFont(context, 14),
                            fontWeight: FontWeight.w600,
                            color: Colors.black,
                            height: 1.2,
                          ),
                        ),
                        Container(
                          margin: const EdgeInsets.only(left: 11, right: 10),
                          child: Text(
                            (qnaData.mtId ?? "").length > 15 ? "${(qnaData.mtId ?? "").substring(0, 15)}..." : qnaData.mtId ?? "",
                            style: TextStyle(
                              fontFamily: 'Pretendard',
                              color: const Color(0xFF7B7B7B),
                              fontSize: Responsive.getFont(context, 12),
                              height: 1.2,
                            ),
                          ),
                        ),
                        Text(
                          '${qnaData.qtWdate}',
                          style: TextStyle(
                            fontFamily: 'Pretendard',
                            color: const Color(0xFF7B7B7B),
                            fontSize: Responsive.getFont(context, 12),
                            height: 1.2,
                          ),
                        ),
                      ],
                    ),
                  ),
                  Container(
                    margin: const EdgeInsets.only(top: 12, right: 16, left: 16),
                    child: Row(
                      children: [
                        myQna == "N" ? SvgPicture.asset('assets/images/product/ic_lock.svg') : const SizedBox(),
                        Expanded(
                          child: Container(
                            margin: myQna == "N" ? const EdgeInsets.symmetric(horizontal: 8) : null,
                            child: Text(
                              qnaData.qtTitle ?? "",
                              style: TextStyle(
                                fontFamily: 'Pretendard',
                                fontSize: Responsive.getFont(context, 14),
                                color: Colors.black,
                                height: 1.2,
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  Container(
                    margin: const EdgeInsets.only(top: 20),
                    child: const Divider(thickness: 1, color: Color(0xFFEEEEEE)),
                  ),
                ],
              );
            }),
            ],
          ),
        ),
        Visibility(
          visible: _productQnaList.isEmpty,
          child: Center(
            child: Column(
              children: [
                Container(
                  margin: const EdgeInsets.only(top: 30, bottom: 15),
                  child: SvgPicture.asset('assets/images/product/no_data_img.svg',
                    width: 90,
                    height: 90,
                  ),
                ),
                Container(
                  margin: const EdgeInsets.only(bottom: 80),
                  child: Text(
                    "문의내역이 없습니다.",
                    style: TextStyle(
                      fontFamily: 'Pretendard',
                      fontSize: Responsive.getFont(context, 14),
                      fontWeight: FontWeight.w300,
                      color: const Color(0xFF7B7B7B),
                      height: 1.2,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
       Visibility(
         visible: _productQnaCount == 0 ? false : true,
         child: Container(
           color: Colors.white,
           margin: const EdgeInsets.only(bottom: 50),
           child: Padding(
             padding: const EdgeInsets.symmetric(vertical: 30.0),
             child: Row(
               mainAxisAlignment: MainAxisAlignment.center,
               children: [
                 IconButton(
                   icon: SvgPicture.asset('assets/images/product/pager_prev.svg'),
                   onPressed: () {
                     if (_productQnaCurrentPage > 1) {
                       setState(() {
                         _productQnaCurrentPage--;
                         _getProductQnaList();
                       });
                     }
                   }
                 ),
                 Container(
                   margin: const EdgeInsets.symmetric(horizontal: 20),
                   child: Row(
                     children: [
                       Text(
                         currentPageStr,
                         style: TextStyle(
                           fontFamily: 'Pretendard',
                           fontSize: Responsive.getFont(context, 16),
                           fontWeight: FontWeight.w600,
                           height: 1.2,
                         ),
                       ),
                       Text(
                         ' / $totalPagesStr',
                         style: TextStyle(
                           fontFamily: 'Pretendard',
                           fontSize: Responsive.getFont(context, 16),
                           color: const Color(0xFFCCCCCC),
                           fontWeight: FontWeight.w600,
                           height: 1.2,
                         ),
                       ),
                     ],
                   ),
                 ),
                 IconButton(
                   icon: SvgPicture.asset('assets/images/product/pager_next.svg'),
                   onPressed: () {
                     if (_productQnaCurrentPage < _productQnaTotalPages) {
                       setState(() {
                         _productQnaCurrentPage++;
                         _getProductQnaList();
                       });
                     }
                   }
                 ),
               ],
             ),
           ),
         ),
       ),
     ],
   );
  }

  Widget _productReview() {
    if (_productReviewCount > 0) {
      _productReviewTotalPages = (_productReviewCount ~/ 10);
      if ((_productReviewCount % 10) > 0) {
        _productReviewTotalPages = _productReviewTotalPages + 1;
      }
    }

    String currentPageStr = _productReviewCurrentPage.toString();
    if (_productReviewCurrentPage < 10) {
      currentPageStr = "0$_productReviewCurrentPage";
    }

    String totalPagesStr = _productReviewTotalPages.toString();
    if (_productReviewTotalPages < 10) {
      totalPagesStr = "0$_productReviewTotalPages";
    }

    return ListView(
      children: [
        // 평점과 총 리뷰 수 섹션
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 16.0),
          margin: const EdgeInsets.only(top: 30),
          child: Row(
            children: [
              Text(
                _productReviewStarAvg,
                style: TextStyle(
                  fontFamily: 'Pretendard',
                  fontSize: Responsive.getFont(context, 20),
                  fontWeight: FontWeight.bold,
                  color: Colors.black,
                  height: 1.2,
                ),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 4.0),
                child: Text(
                  '/5.0',
                  style: TextStyle(
                    fontFamily: 'Pretendard',
                    fontSize: Responsive.getFont(context, 20),
                    fontWeight: FontWeight.bold,
                    color: const Color(0xFFA4A4A4),
                    height: 1.2,
                  ),
                ),
              ),
              const Spacer(),
              Text(
                '$_productReviewCount명의 리뷰',
                style: TextStyle(
                  fontFamily: 'Pretendard',
                  fontWeight: FontWeight.w400,
                  fontSize: Responsive.getFont(context, 14),
                  height: 1.2,
                ),
              ),
            ],
          ),
        ),
        Container(
          margin: const EdgeInsets.symmetric(vertical: 10, horizontal: 16),
          child: _ratingTotalStars(double.parse(_productReviewStarAvg)),
        ),
        Container(
          margin: const EdgeInsets.only(top: 10, bottom: 20),
          height: 10,
          width: double.infinity,
          color: const Color(0xFFF5F9F9),
        ),

        // 리뷰 리스트
        ...List.generate(_productReviewList.length, (index) {
          final reviewData = _productReviewList[index];
          final reviewImages = reviewData.imgArr ?? [];

          return GestureDetector(
            onTap: () {
              // 각 리뷰를 클릭했을 때 리뷰 상세 페이지로 이동
              Navigator.pushNamed(context, '/product_review_detail/${reviewData.rtIdx ?? 0}');
            },
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  margin: const EdgeInsets.symmetric(horizontal: 16),
                  child: Row(
                    children: [
                      Text(
                        reviewData.mtId ?? "",
                        style: TextStyle(
                          fontFamily: 'Pretendard',
                          color: const Color(0xFF7B7B7B),
                          fontSize: Responsive.getFont(context, 12),
                          height: 1.2,
                        ),
                      ),
                      Container(
                        margin: const EdgeInsets.symmetric(horizontal: 10),
                        child: Text(
                          reviewData.rtWdate ?? "",
                          style: TextStyle(
                            fontFamily: 'Pretendard',
                            color: const Color(0xFF7B7B7B),
                            fontSize: Responsive.getFont(context, 12),
                            height: 1.2,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                Container(
                  margin: const EdgeInsets.symmetric(vertical: 10, horizontal: 16),
                  child: _ratingStars(double.parse(reviewData.rtStart ?? "0.0")),
                ),
                // 리뷰 텍스트 두 줄로 제한하고 넘칠 경우 생략 부호 표시
                Container(
                  margin: const EdgeInsets.symmetric(horizontal: 16),
                  child: Text(
                    reviewData.rtContent ?? "",
                    style: TextStyle(
                      fontFamily: 'Pretendard',
                      fontSize: Responsive.getFont(context, 14),
                      color: Colors.black,
                      height: 1.2,
                    ),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
                Container(
                  margin: const EdgeInsets.only(top: 10, bottom: 15, left: 16),
                  child: GestureDetector(
                    onTap: () {
                      Navigator.pushNamed(context, '/report/${reviewData.rtIdx ?? 0}');
                    },
                    child: Text(
                      '신고',
                      style: TextStyle(
                        fontFamily: 'Pretendard',
                        fontSize: Responsive.getFont(context, 12),
                        color: const Color(0xFF7B7B7B),
                        height: 1.2,
                      ),
                    ),
                  ),
                ),
                // 사진 목록 - 가로 사이즈에 맞게 배치
                Container(
                  margin: const EdgeInsets.symmetric(horizontal: 16),
                  child: SingleChildScrollView(
                    scrollDirection: Axis.horizontal,
                    child: Row(
                      children: reviewImages.map((imagePath) {
                        return Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 4.0),
                          child: ClipRRect(
                            borderRadius: BorderRadius.circular(8.0),
                            child: CachedNetworkImage(
                              imageUrl: imagePath,
                              width: 90,
                              height: 90,
                              fit: BoxFit.cover,
                              placeholder: (context, url) {
                                return const Center(
                                  child: CircularProgressIndicator(),
                                );
                              },
                              errorWidget: (context, url, error) {
                                return SvgPicture.asset(
                                  'assets/images/no_imge.svg',
                                  width: 90,
                                  height: 90,
                                  fit: BoxFit.fitWidth,
                                );
                              },
                            ),
                          ),
                        );
                      }).toList(),
                    ),
                  ),
                ),
                Container(
                  margin: const EdgeInsets.symmetric(vertical: 20),
                  child: const Divider(thickness: 1, color: Color(0xFFEEEEEE)),
                ),
              ],
            ),
          );
        }),
        // 페이지네이션
        Visibility(
          visible: _productReviewCount == 0 ? false : true,
          child: Container(
            margin: const EdgeInsets.only(bottom: 80),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                IconButton(
                  icon: SvgPicture.asset('assets/images/product/pager_prev.svg'),
                  onPressed: () {
                    if (_productReviewCurrentPage > 1) {
                      setState(() {
                        _productReviewCurrentPage--;
                        _getProductReviewList();
                      });
                    }
                  },
                ),
                Container(
                  margin: const EdgeInsets.symmetric(horizontal: 20),
                  child: Row(
                    children: [
                      Text(
                        currentPageStr,
                        style: TextStyle(
                          fontFamily: 'Pretendard',
                          fontSize: Responsive.getFont(context, 16),
                          fontWeight: FontWeight.w600,
                          height: 1.2,
                        ),
                      ),
                      Text(
                        ' / $totalPagesStr',
                        style: TextStyle(
                          fontFamily: 'Pretendard',
                          fontSize: Responsive.getFont(context, 16),
                          color: const Color(0xFFCCCCCC),
                          fontWeight: FontWeight.w600,
                          height: 1.2,
                        ),
                      ),
                    ],
                  ),
                ),
                IconButton(
                  icon: SvgPicture.asset('assets/images/product/pager_next.svg'),
                  onPressed: () {
                    if (_productReviewCurrentPage < _productReviewTotalPages) {
                      setState(() {
                        _productReviewCurrentPage++;
                        _getProductReviewList();
                      });
                    }
                  },
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget _ratingTotalStars(double rating) {
    int fullStars = rating.floor(); // 꽉 찬 별의 개수
    bool hasHalfStar = (rating - fullStars) >= 0.5; // 반 개짜리 별이 있는지 확인
    int emptyStars = 5 - fullStars - (hasHalfStar ? 1 : 0); // 빈 별의 개수

    return Row(
      children: [
        // 꽉 찬 별을 표시
        for (int i = 0; i < fullStars; i++)
          const Icon(
            Icons.star,
            color: Color(0xFFFF6191),
            size: 26,
          ),

        if (hasHalfStar) _buildHalfTotalStar(rating),

        // 빈 별을 표시
        for (int i = 0; i < emptyStars; i++)
          const Icon(
            Icons.star,
            color: Color(0xFFEEEEEE),
            size: 26,
          ),
      ],
    );
  }

  Widget _ratingStars(double rating) {
    int fullStars = rating.floor(); // 꽉 찬 별의 개수
    bool hasHalfStar = (rating - fullStars) >= 0.5; // 반 개짜리 별이 있는지 확인
    int emptyStars = 5 - fullStars - (hasHalfStar ? 1 : 0); // 빈 별의 개수

    return Row(
      children: [
        // 꽉 찬 별을 표시
        for (int i = 0; i < fullStars; i++)
          const Icon(Icons.star, color: Color(0xFFFF6191), size: 16),

        if (hasHalfStar) _buildHalfStar(rating),

        // 빈 별을 표시
        for (int i = 0; i < emptyStars; i++)
          const Icon(
            Icons.star,
            color: Color(0xFFEEEEEE),
            size: 16,
          ),
      ],
    );
  }

  Widget _buildHalfTotalStar(double rating) {
    return Stack(
      children: [
        const Icon(
          Icons.star,
          color: Color(0xFFEEEEEE), // 빈 별 색상
          size: 26,
        ),
        ClipRect(
          clipper: HalfClipper(),
          child: const Icon(
            Icons.star,
            color: Color(0xFFFF6191), // 채워진 별 색상
            size: 26,
          ),
        ),
      ],
    );
  }

  Widget _buildHalfStar(double rating) {
    return Stack(
      children: [
        const Icon(
          Icons.star,
          color: Color(0xFFEEEEEE), // 빈 별 색상
          size: 16,
        ),
        ClipRect(
          clipper: HalfClipper(),
          child: const Icon(
            Icons.star,
            color: Color(0xFFFF6191), // 채워진 별 색상
            size: 16,
          ),
        ),
      ],
    );
  }

  //상품정보제공고시 테이블 구성 만들기
  Widget _makeProductInfoTable() {
    List<TableRow> tableRows = [];
    final ptCategory = _productData?.ptCategory ?? "";
    List<String> typeList = [];

    // 아우터, 상의, 하의, 원피스, 세트/한벌옷, 언더웨어/홈웨어
    final List<String> type1 = [
      '제품명 및 모델명', 'KC 인증정보', '크기.중량', '색상', '재질', '사용연령 또는 권장사용연령', '동일모델의 출시년월',
      '제조자, 수입품의 경우 수입자와 함께 표기', '제조국', '취급방법 및 취급시 주의사항', '품질보증기간', 'A/S 책임자와 전화번호',
    ];
    //슈즈
    final List<String> type2 = [
      '재품 주소재(운동화인 경우에는 겉감, 안감을 구분하여 표시)', 'KC 인증정보', '색상', '치수', '제조자. 수입품의 경우 수입자와 함께 표기',
      '제조국', '취급방법 및 취급시 주의사항', '품질보증기간', 'A/S 책임자와 전화번호',
    ];
    //악세서리
    final List<String> type3 = [
      '종류', 'KC 인증정보', '소재', '치수 및 크기', '제조자, 수입품의 경우 수입자와 함께 표기', '제조국',
      '취급방법 및 취급시 주의사항', '품질보증기간', 'A/S 책임자와 전화번호'
    ];
    //베이비 잡화
    final List<String> type4 = [
      '종류', 'KC 인증정보', '소재', '치수', '제조자, 수입품의 경우 수입자와 함께 표기', '제조국',
      '취급방법 및 취급시 주의사항', '품질보증기간', 'A/S 책임자와 전화번호'
    ];

    List<String> typeValue = [];

    final pat = _productData?.ptAttribute;

    switch(ptCategory) {
      // 아우터, 상의, 하의, 원피스, 세트/한벌옷, 언더웨어/홈웨어
      case "1":
      case "2":
      case "3":
      case "4":
      case "6":
      case "7":
        typeList = type1;
        typeValue = [
          pat?.patName ?? "", pat?.patKc ?? "", pat?.patSize ?? "", pat?.patColor ?? "",
          pat?.patTexture ?? "", pat?.patAge ?? "", pat?.patSdate ?? "", pat?.patImporter ?? "",
          pat?.patFrom ?? "", pat?.patDanger ?? "", pat?.patQuality ?? "", pat?.patAs ?? "",
        ];
        break;
      //슈즈
      case "5":
        typeList = type2;
        typeValue = [
          pat?.patTexture ?? "", pat?.patKc ?? "", pat?.patColor ?? "", pat?.patSize ?? "", pat?.patImporter ?? "",
          pat?.patFrom ?? "", pat?.patDanger ?? "", pat?.patQuality ?? "", pat?.patAs ?? "",
        ];
        break;
      //악세서리
      case "8":
        typeList = type3;
        typeValue = [
          pat?.patKind ?? "", pat?.patKc ?? "", pat?.patTexture ?? "", pat?.patSize ?? "", pat?.patImporter ?? "",
          pat?.patFrom ?? "", pat?.patDanger ?? "", pat?.patQuality ?? "", pat?.patAs ?? "",
        ];
        break;
      //베이비 잡화
      case "9":
        typeList = type4;
        typeValue = [
          pat?.patKind ?? "", pat?.patKc ?? "", pat?.patTexture ?? "", pat?.patSize ?? "", pat?.patImporter ?? "",
          pat?.patFrom ?? "", pat?.patDanger ?? "", pat?.patQuality ?? "", pat?.patAs ?? "",
        ];
        break;
    }

    for (int i = 0; i < typeList.length; i++) {
      final name = typeList[i];
      final value = typeValue[i];
      tableRows.add(_makeTableRow(name, value));
    }

    return Table(
      //defaultVerticalAlignment: TableCellVerticalAlignment.middle,
      border: TableBorder.all(
        color: const Color(0xFFDDDDDD),
      ),
      columnWidths: const {
        0: FractionColumnWidth(0.45),
        1: FractionColumnWidth(0.55),
      },
      children: tableRows,
    );
  }
  // 판매자 정보
  Widget _makeSellerInfoTable() {
    return Table(
      border: TableBorder.all(
        color: const Color(0xFFDDDDDD),
      ),
      columnWidths: const {
        0: FractionColumnWidth(0.45),
        1: FractionColumnWidth(0.55),
      },
      children: [
        _makeTableRow('상호명', _storeData?.stName ?? ""),
        _makeTableRow('사업자등록번호', _storeData?.stBusiness ?? ""),
        _makeTableRow('대표전화', _storeData?.stHp ?? ""),
      ],
    );
  }

  TableRow _makeTableRow(String name, String value) {
    return TableRow(
      children: [
        TableCell(
          child: Container(
            color: const Color(0xFFF5F9F9),
            padding: const EdgeInsets.fromLTRB(13, 12, 13, 12),
            child: Text(
              name,
              style: TextStyle(
                fontFamily: 'Pretendard',
                fontSize: Responsive.getFont(context, 13),
                color: Colors.black,
                height: 1.2,
              ),
            ),
          ),
        ),
        TableCell(
          verticalAlignment: TableCellVerticalAlignment.middle,
          child: Container(
            padding: const EdgeInsets.fromLTRB(13, 12, 13, 12),
            child: Text(
              value,
              style: TextStyle(
                fontFamily: 'Pretendard',
                fontSize: Responsive.getFont(context, 13),
                color: Colors.black,
                height: 1.2,
              ),
            ),
          ),
        ),
      ],
    );
  }
}

class HalfClipper extends CustomClipper<Rect> {
  @override
  Rect getClip(Size size) {
    return Rect.fromLTRB(0, 0, size.width / 2, size.height); // 별의 절반을 잘라냄
  }

  @override
  bool shouldReclip(CustomClipper<Rect> oldClipper) {
    return false;
  }
}
