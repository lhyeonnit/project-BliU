import 'package:BliU/data/product_data.dart';
import 'package:BliU/utils/responsive.dart';
import 'package:BliU/utils/utils.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

class ProductAi extends StatefulWidget {
  final List<ProductData> productList;

  const ProductAi({super.key, required this.productList});

  @override
  State<ProductAi> createState() => _ProductAiState();
}

class _ProductAiState extends State<ProductAi> {
  late List<ProductData> productList;

  @override
  Widget build(BuildContext context) {
    productList = widget.productList;

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
          height: 290,
          margin: const EdgeInsets.only(top: 20),
          child: ListView.builder(
            shrinkWrap: true,
            scrollDirection: Axis.horizontal, // 가로 스크롤 가능하도록 설정
            itemCount: productList.length, // 임의의 연관 상품 갯수
            itemBuilder: (context, index) {
              final productData = productList[index];

              return Padding(
                padding: const EdgeInsets.only(left: 12.0),
                child: SizedBox(
                  width: 160, // 가로 너비를 160으로 고정
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Stack(
                        children: [
                          ClipRRect(
                            borderRadius: const BorderRadius.all(Radius.circular(10)), // 사진의 모서리만 둥글게 설정
                            child: AspectRatio(
                              aspectRatio: 1,
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
                              onTap: () {
                                //TODO 좋아요 액션
                                // if (productData.likeChk == "Y") {
                                //   productList[index].likeChk = "N";
                                // } else {
                                //   productList[index].likeChk = "Y";
                                // }
                              },
                              child: Image.asset(
                                productList[index].likeChk == "Y" ? 'assets/images/home/like_btn_fill.png' : 'assets/images/home/like_btn.png',
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
                                color: const Color(0xFF7B7B7B),
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
                            maxLines: 2, // 한 줄만 표시
                            overflow: TextOverflow.ellipsis, // 길면 생략부호 처리
                          ),
                          Container(
                            margin: const EdgeInsets.only(top: 12, bottom: 10),
                            child: Row(
                              children: [
                                (productData.ptDiscountPer ?? 0) > 0
                                    ? Row(children: [
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
                                      ])
                                    : Container(),
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
                                    maxLines: 1, // 한 줄만 표시
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
                                  Utils.getInstance().priceString(productData.ptLike ?? 0),
                                  style: TextStyle(
                                    fontFamily: 'Pretendard',
                                    fontSize: Responsive.getFont(context, 12),
                                    color: const Color(0xFFA4A4A4),
                                    height: 1.2,
                                  ),
                                  maxLines: 1, // 한 줄만 표시
                                ),
                              ),
                              const SizedBox(width: 10,),
                              if ((productData.ptReview ?? 0) > 0) ...[
                                SvgPicture.asset(
                                  'assets/images/home/item_comment.svg',
                                  color: const Color(0xFFA4A4A4),
                                  width: Responsive.getWidth(context, 13),
                                  height: Responsive.getHeight(context, 12),
                                ),
                                Container(
                                  margin: const EdgeInsets.only(left: 2, bottom: 2),
                                  child: Text(
                                    Utils.getInstance().priceString(productData.ptReview ?? 0),
                                    style: TextStyle(
                                      fontFamily: 'Pretendard',
                                      fontSize: Responsive.getFont(context, 12),
                                      color: const Color(0xFFA4A4A4),
                                      height: 1.2,
                                    ),
                                    maxLines: 1, // 한 줄만 표시
                                  ),
                                ),
                              ],
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
      ],
    );
  }
}
