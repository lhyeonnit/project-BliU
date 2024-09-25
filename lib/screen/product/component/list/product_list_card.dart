import 'package:BliU/data/product_data.dart';
import 'package:BliU/screen/product/product_detail_screen.dart';
import 'package:BliU/utils/responsive.dart';
import 'package:BliU/utils/utils.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

class ProductListCard extends StatefulWidget {
  final ProductData productData;

  const ProductListCard({super.key, required this.productData,});

  @override
  _ProductListCardState createState() => _ProductListCardState();
}

class _ProductListCardState extends State<ProductListCard> {

  @override
  Widget build(BuildContext context) {
    final ProductData productData = widget.productData;
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
        width: 184,
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
                  child: Image.network(
                    productData.ptImg ?? "",
                    height: 184,
                    width: double.infinity,
                    fit: BoxFit.cover,
                  ),
                ),
                Positioned(
                  top: 0,
                  right: 0,
                  child: GestureDetector(
                    onTap: () {
                      setState(() {
                        // TODO 좋아요 관련
                        // isFavoriteList[widget.index] =
                        //     !isFavoriteList[widget.index]; // 좋아요 상태 토글
                      });
                    },
                    child: SvgPicture.asset(
                      //'assets/images/home/like_btn.svg',
                      productData.likeChk == "Y"
                          ? "assets/images/home/like_btn_fill.svg"
                          : "assets/images/home/like_btn.svg",
                      color: productData.likeChk == "Y"
                          ? const Color(0xFFFF6191)
                          : null,
                      // 좋아요 상태에 따라 내부 색상 변경
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
                    //widget.item['brand']!,
                    productData.ptName ?? "",
                    style: TextStyle(
                        fontSize: Responsive.getFont(context, 12),
                        color: Colors.grey),
                  ),
                ),
                Text(
                  //widget.item['name']!,
                  productData.ptName ?? "",
                  style: TextStyle(
                    fontSize: Responsive.getFont(context, 14),
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
                        //widget.item['discount']!,
                        '${productData.ptDiscountPer ?? 0}%',
                        style: TextStyle(
                          fontSize: Responsive.getFont(context, 14),
                          color: const Color(0xFFFF6192),
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      Container(
                        margin: const EdgeInsets.symmetric(horizontal: 2),
                        child: Text(
                          //widget.item['price']!,
                          Utils.getInstance().priceString(productData.ptPrice ?? 0),
                          style: TextStyle(
                            fontSize: Responsive.getFont(context, 14),
                            fontWeight: FontWeight.bold,
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
                        //widget.item['likes']!,
                        '${productData.ptLike ?? ""}',
                        style: TextStyle(
                          fontSize: Responsive.getFont(context, 12),
                          color: Colors.grey,
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
                              //widget.item['comments']!,
                              '${productData.ptReview ?? ""}',
                              style: TextStyle(
                                  fontSize: Responsive.getFont(context, 12),
                                  color: Colors.grey),
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
  }
}
