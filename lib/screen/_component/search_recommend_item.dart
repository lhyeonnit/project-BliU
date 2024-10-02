import 'package:BliU/data/product_data.dart';
import 'package:BliU/screen/home/viewmodel/home_body_ai_view_model.dart';
import 'package:BliU/screen/product/product_detail_screen.dart';
import 'package:BliU/utils/responsive.dart';
import 'package:BliU/utils/shared_preferences_manager.dart';
import 'package:BliU/utils/utils.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_svg/flutter_svg.dart';

class SearchRecommendItem extends ConsumerStatefulWidget {
  const SearchRecommendItem({super.key});

  @override
  ConsumerState<SearchRecommendItem> createState() => _SearchRecommendItemState();
}

class _SearchRecommendItemState extends ConsumerState<SearchRecommendItem> {
  List<bool> isFavoriteList = List<bool>.generate(10, (index) => false);
  List<ProductData> _productList = [];

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _afterBuild(context);
    });
  }
  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(left: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            margin: const EdgeInsets.only(top: 40),
            child: Text(
              '이런 아이템은 어떠세요?',
              style: TextStyle(
                fontFamily: 'Pretendard',
                fontSize: Responsive.getFont(context, 18),
                fontWeight: FontWeight.bold,
                height: 1.2,
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 15.0),
            child: Container(
              height: 290,
              child: ListView.builder(
                shrinkWrap: true,
                scrollDirection: Axis.horizontal,
                itemCount: _productList.length, // 리스트의 길이를 사용
                itemBuilder: (context, index) {
                  final productData = _productList[index];
                  return GestureDetector(
                    onTap: () {
                      // TODO 이동 수정
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) =>
                              const ProductDetailScreen(ptIdx: 3),
                        ),
                      );
                    },
                    child: Container(
                      width: 160,
                      padding: const EdgeInsets.only(right: 12),
                      decoration: const BoxDecoration(
                        color: Colors.white,
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Stack(
                            children: [
                              ClipRRect(
                                borderRadius:
                                    const BorderRadius.all(Radius.circular(5)),
                                child: Image.network(
                                  productData.ptImg ?? '',
                                  height: 160,
                                  fit: BoxFit.cover,
                                  errorBuilder: (BuildContext context, Object exception, StackTrace? stackTrace) {
                                    return const SizedBox();
                                  },
                                ),
                              ),
                              Positioned(
                                top: 0,
                                right: 0,
                                child: GestureDetector(
                                  onTap: () {
                                    setState(() {
                                      isFavoriteList[index] =
                                          !isFavoriteList[index]; // 좋아요 상태 토글
                                    });
                                  },
                                  child: Image.asset(
                                    productData.likeChk == "Y" ? 'assets/images/home/like_btn_fill.png'
                                        : 'assets/images/home/like_btn.png',
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
                                  productData.stName ?? '',
                                  style: TextStyle(
                                    fontFamily: 'Pretendard',
                                    fontSize: Responsive.getFont(context, 12),
                                    color: const Color(0xFF7B7B7B),
                                    height: 1.2,
                                  ),
                                ),
                              ),
                              Text(
                                productData.ptName ?? '',
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
                                      '${productData.ptDiscountPer}%',
                                      style: TextStyle(
                                        fontFamily: 'Pretendard',
                                        fontSize: Responsive.getFont(context, 14),
                                        color: const Color(0xFFFF6192),
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                    Container(
                                      margin: const EdgeInsets.symmetric(horizontal: 2),
                                      child: Text(
                                        '${Utils.getInstance().priceString(productData.ptPrice ?? 0)}원',
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
                                    color: const Color(0xFFA4A4A4),
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
                                        color: const Color(0xFFA4A4A4),
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
                                          height:
                                              Responsive.getHeight(context, 12),
                                        ),
                                        Container(
                                          margin: const EdgeInsets.only(left: 2, bottom: 2),
                                          child: Text(
                                            '${productData.ptReview ?? ""}',
                                            style: TextStyle(
                                              fontFamily: 'Pretendard',
                                              fontSize: Responsive.getFont(context, 12),
                                              color: const Color(0xFFA4A4A4),
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
              ),
            ),
          ),
        ],
      ),
    );
  }
  void _afterBuild(BuildContext context) {
    _getList();
  }

  void _getList() async {
    // TODO 회원 비회원 처리 필요
    final pref = await SharedPreferencesManager.getInstance();
    final mtIdx = pref.getMtIdx();
    Map<String, dynamic> requestData = {
      'mt_idx': mtIdx,
    };

    final productListResponseDTO = await ref.read(homeBodyAiViewModelProvider.notifier).getList(requestData);
    if (productListResponseDTO != null) {
      if (productListResponseDTO.result == true) {
        setState(() {
          _productList = productListResponseDTO.list;
        });
      }
    }
  }
}
