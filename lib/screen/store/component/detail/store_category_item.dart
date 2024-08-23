import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:BliU/utils/responsive.dart';

class StoreCategoryItem extends StatefulWidget {
  final ScrollController scrollController;
  final int productCount; // 해당 탭의 상품 개수

  StoreCategoryItem({
    required this.scrollController,
    required this.productCount,
  });


  @override
  _StoreCategoryItemState createState() => _StoreCategoryItemState();
}

class _StoreCategoryItemState extends State<StoreCategoryItem> {
  List<bool> isFavoriteList =
      List<bool>.generate(100, (index) => false); // 좋아요 상태 관리

  @override
  Widget build(BuildContext context) {
    return GridView.builder(
      controller: widget.scrollController,
      padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 10),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        crossAxisSpacing: 12.0,
        mainAxisSpacing: 30.0,
        childAspectRatio: 0.8,
      ),
      itemCount: widget.productCount, // 탭별 상품 개수
      itemBuilder: (context, itemIndex) {
        return GestureDetector(
          onTap: () {
            // 상품 클릭 시 이동 처리 등
          },
          child: Container(
            height: 301,
            width: Responsive.getWidth(context, 184),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Stack(
                  children: [
                    ClipRRect(
                      borderRadius: BorderRadius.all(Radius.circular(5)),
                      child: Image.asset(
                        'assets/images/home/exhi.png',
                        fit: BoxFit.contain,
                      ),
                    ),
                    Positioned(
                      top: 0,
                      right: 0,
                      child: GestureDetector(
                        onTap: () {
                          setState(() {
                            isFavoriteList[itemIndex] =
                                !isFavoriteList[itemIndex]; // 좋아요 상태 토글
                          });
                        },
                        child: SvgPicture.asset(
                          isFavoriteList[itemIndex]
                              ? 'assets/images/home/like_btn_fill.svg'
                              : 'assets/images/home/like_btn.svg',
                          color:
                              isFavoriteList[itemIndex] ? Color(0xFFFF6191) : null,
                          height: Responsive.getHeight(context, 34),
                          width: Responsive.getWidth(context, 34),
                        ),
                      ),
                    ),
                  ],
                ),
                SizedBox(
                  height: Responsive.getHeight(context, 12),
                ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      '꿈꾸는데이지',
                      style: TextStyle(
                        fontSize: Responsive.getFont(context, 12),
                        color: Colors.grey,
                      ),
                    ),
                    SizedBox(height: Responsive.getHeight(context, 4)),
                    Text(
                      '꿈꾸는 데이지 안나 토션 레이스 베스트',
                      style: TextStyle(
                        fontSize: Responsive.getFont(context, 14),
                      ),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                    SizedBox(height: Responsive.getHeight(context, 12)),
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.baseline,
                      textBaseline: TextBaseline.alphabetic,
                      children: [
                        Text(
                          '15%',
                          style: TextStyle(
                            fontSize: Responsive.getFont(context, 14),
                            color: Color(0xFFFF6192),
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        SizedBox(width: Responsive.getWidth(context, 2)),
                        Text(
                          '32,800원',
                          style: TextStyle(
                            fontSize: Responsive.getFont(context, 14),
                            fontWeight: FontWeight.bold,
                          ),
                          maxLines: 1,
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
