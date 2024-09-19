import 'package:BliU/screen/product/product_detail_screen.dart';
import 'package:BliU/utils/responsive.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

class ProductListCard extends StatefulWidget {
  final int index;
  final Map<String, String> item;

  const ProductListCard({super.key, required this.item, required this.index});

  @override
  _ProductListCardState createState() => _ProductListCardState();
}

class _ProductListCardState extends State<ProductListCard> {
  List<bool> isFavoriteList = List<bool>.generate(10, (index) => false);


  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        // TODO 이동 수정
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => const ProductDetailScreen(ptIdx: 3),
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
                  child: Image.asset(
                    'assets/images/home/exhi.png',
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
                        isFavoriteList[widget.index] =
                            !isFavoriteList[widget.index]; // 좋아요 상태 토글
                      });
                    },
                    child: SvgPicture.asset(
                      isFavoriteList[widget.index]
                          ? 'assets/images/home/like_btn_fill.svg'
                          : 'assets/images/home/like_btn.svg',
                      color: isFavoriteList[widget.index]
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
                  margin: EdgeInsets.only(top: 12, bottom: 4),
                  child: Text(
                    widget.item['brand']!,
                    style: TextStyle(
                        fontSize: Responsive.getFont(context, 12),
                        color: Colors.grey),
                  ),
                ),
                Text(
                  widget.item['name']!,
                  style: TextStyle(
                    fontSize: 14,
                  ),
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
                Container(
                  margin: EdgeInsets.only(top: 12, bottom: 10),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.baseline,
                    textBaseline: TextBaseline.alphabetic,
                    children: [
                      Text(
                        widget.item['discount']!,
                        style: TextStyle(
                          fontSize: Responsive.getFont(context, 14),
                          color: const Color(0xFFFF6192),
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      Container(
                        margin: EdgeInsets.symmetric(horizontal: 2),
                        child: Text(
                          widget.item['price']!,
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
                      margin: EdgeInsets.only(left: 2, bottom: 2),
                      child: Text(
                        widget.item['likes']!,
                        style: TextStyle(
                          fontSize: Responsive.getFont(context, 12),
                          color: Colors.grey,
                        ),
                      ),
                    ),
                    Container(
                      margin: EdgeInsets.symmetric(horizontal: 10),
                      child: Row(
                        children: [
                          SvgPicture.asset(
                            'assets/images/home/item_comment.svg',
                            width: Responsive.getWidth(context, 13),
                            height: Responsive.getHeight(context, 12),
                          ),
                          Container(
                            margin: EdgeInsets.only(left: 2, bottom: 2),
                            child: Text(
                              widget.item['comments']!,
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
