import 'package:BliU/data/review_data.dart';
import 'package:BliU/screen/product_review_detail/view_model/product_review_detail_view_model.dart';
import 'package:BliU/utils/my_app_bar.dart';
import 'package:BliU/utils/responsive.dart';
import 'package:BliU/utils/shared_preferences_manager.dart';
import 'package:BliU/utils/utils.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';

class ProductReviewDetailScreen extends ConsumerStatefulWidget {
  const ProductReviewDetailScreen({super.key});

  @override
  ConsumerState<ProductReviewDetailScreen> createState() => ProductReviewDetailScreenState();
}

class ProductReviewDetailScreenState extends ConsumerState<ProductReviewDetailScreen> {
  int _rtIdx = 0;
  final ScrollController _scrollController = ScrollController();
  PageController? _pageController;

  ReviewData? _reviewData;
  int _currentPage = 0;

  @override
  void initState() {
    super.initState();
    try {
      _rtIdx = int.parse(Get.parameters["rt_idx"].toString());
    } catch(e) {
      //
    }
    _pageController = PageController();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _afterBuild(context);
    });
  }

  @override
  void dispose() {
    _pageController?.dispose();
    super.dispose();
  }

  Widget _ratingStars(double rating) {
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
            size: 16,
          ),

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

  @override
  Widget build(BuildContext context) {
    bool isMy = false;
    List<String> images = [];
    if (_reviewData != null) {
      images = _reviewData?.imgArr ?? [];
      isMy = _reviewData?.myReview == "Y";
    }

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: MyAppBar(
        appBar: AppBar(
          scrolledUnderElevation: 0,
          backgroundColor: Colors.white,
          title: const Text('리뷰 상세'),
          titleTextStyle: TextStyle(
            fontFamily: 'Pretendard',
            fontSize: Responsive.getFont(context, 18),
            fontWeight: FontWeight.w600,
            color: Colors.black,
            height: 1.2,
          ),
          leading: IconButton(
            icon: SvgPicture.asset("assets/images/store/ic_back.svg"),
            onPressed: () {
              Navigator.pop(context); // 뒤로가기 동작
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
        ),
      ),
      body: SafeArea(
        child: Utils.getInstance().isWebView(
          SingleChildScrollView(
            controller: _scrollController,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Stack(
                  children: [
                    SizedBox(
                      height: Responsive.getHeight(context, 412),
                      child: PageView.builder(
                        controller: _pageController,
                        itemCount: images.length,
                        onPageChanged: (int page) {
                          setState(() {
                            _currentPage = page;
                          });
                        },
                        itemBuilder: (context, index) {
                          return CachedNetworkImage(
                            imageUrl: images[index],
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
                          );
                        },
                      ),
                    ),
                    Positioned(
                      bottom: 15,
                      right: 16,
                      child: Container(
                        padding:
                        const EdgeInsets.symmetric(vertical: 4, horizontal: 15),
                        decoration: const BoxDecoration(
                          color: Color(0x45000000),
                          borderRadius: BorderRadius.all(Radius.circular(22)),
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                              '${_currentPage + 1}',
                              style: TextStyle(
                                fontFamily: 'Pretendard',
                                fontSize: Responsive.getFont(context, 13),
                                color: Colors.white,
                                height: 1.2,
                              ),
                            ),
                            Text(
                              '/${images.length}',
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
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 30),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Text(
                            _reviewData?.mtId ?? "",
                            style: TextStyle(
                              fontFamily: 'Pretendard',
                              fontSize: Responsive.getFont(context, 12),
                              color: const Color(0xFF7B7B7B),
                              height: 1.2,
                            ),
                          ),
                          Container(
                            margin: const EdgeInsets.symmetric(horizontal: 10),
                            child: Text(
                              _reviewData?.rtWdate ?? "",
                              style: TextStyle(
                                fontFamily: 'Pretendard',
                                fontSize: Responsive.getFont(context, 12),
                                color: const Color(0xFF7B7B7B),
                                height: 1.2,
                              ),
                            ),
                          ),
                        ],
                      ),
                      Container(
                        margin: const EdgeInsets.symmetric(vertical: 10),
                        child: _ratingStars(double.parse(_reviewData?.rtStart ?? "0.0")),
                      ),
                      Text(
                        _reviewData?.rtContent ?? "",
                        style: TextStyle(
                          fontFamily: 'Pretendard',
                          fontSize: Responsive.getFont(context, 14),
                          height: 1.2,
                        ),
                      ),
                      Visibility(
                        visible: !isMy,
                        child: Padding(
                          padding: const EdgeInsets.only(top: 10.0),
                          child: GestureDetector(
                            onTap: () {
                              Navigator.pushNamed(context, '/report/$_rtIdx');
                            },
                            child: const Text(
                              '신고',
                              style: TextStyle(
                                fontFamily: 'Pretendard',
                                fontSize: 12,
                                color: Colors.grey,
                                height: 1.2,
                              ),
                            ),
                          ),
                        ),
                      ),
                      Visibility(
                        visible: isMy,
                        child: GestureDetector(
                          onTap: () async {
                            if (_reviewData != null) {
                              final result = await Navigator.pushNamed(context, '/my_review_edit', arguments: _reviewData!);
                              if (result == true) {
                                _getDetail();
                              }
                            }
                          },
                          child: Container(
                            margin: const EdgeInsets.only(top: 10.0),
                            height: 48,
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: const BorderRadius.all(
                                Radius.circular(6),
                              ),
                              border: Border.all(color: const Color(0xFFDDDDDD)),
                            ),
                            child: Center(
                              child: Text(
                                '수정',
                                style: TextStyle(
                                  fontFamily: 'Pretendard',
                                  fontSize: Responsive.getFont(context, 14),
                                  fontWeight: FontWeight.normal,
                                  color: Colors.black,
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
        ),
      ),
    );
  }

  void _afterBuild(BuildContext context) {
    _getDetail();
  }

  void _getDetail() async {
    final pref = await SharedPreferencesManager.getInstance();

    Map<String, dynamic> requestData = {
      'mt_idx': pref.getMtIdx(),
      'rt_idx': _rtIdx,
    };

    final reviewDetailResponseDTO = await ref.read(productReviewDetailViewModelProvider.notifier).getDetail(requestData);
    if (reviewDetailResponseDTO != null) {
      if (reviewDetailResponseDTO.result == true) {
        setState(() {
          _reviewData = reviewDetailResponseDTO.data;
        });
      }
    }
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
