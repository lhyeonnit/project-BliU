import 'package:BliU/screen/product/product_detail_screen.dart';
import 'package:BliU/utils/responsive.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

class HomeBodyAi extends StatefulWidget {
  const HomeBodyAi({super.key});

  @override
  _HomeBodyAiState createState() => _HomeBodyAiState();
}

class _HomeBodyAiState extends State<HomeBodyAi> {
  // 각 아이템의 좋아요 상태를 저장하는 리스트
  List<bool> isFavoriteList = List<bool>.generate(10, (index) => false);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(left: 16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'AI 추천 상품',
            style: TextStyle(
              fontSize: Responsive.getFont(context, 20),
              fontWeight: FontWeight.bold,
            ),
          ),
          Container(
            height: Responsive.getHeight(context, 280),
            margin: const EdgeInsets.only(top: 20),
            child: ListView.builder(
              shrinkWrap: true,
              scrollDirection: Axis.horizontal,
              itemCount: isFavoriteList.length, // 리스트의 길이를 사용
              itemBuilder: (context, index) {
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
                              child: Image.asset(
                                'assets/images/home/exhi.png',
                                height: 160,
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
                                    isFavoriteList[index] =
                                        !isFavoriteList[index]; // 좋아요 상태 토글
                                  });
                                },
                                child: SvgPicture.asset(
                                  isFavoriteList[index]
                                      ? 'assets/images/home/like_btn_fill.svg'
                                      : 'assets/images/home/like_btn.svg',
                                  color: isFavoriteList[index]
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
                                '꿈꾸는데이지',
                                style: TextStyle(
                                    fontSize: Responsive.getFont(context, 12),
                                  color: Color(0xFF7B7B7B),
                                ),
                              ),
                            ),
                            Text(
                              '꿈꾸는 데이지 안나 토션 레이스 베스트',
                              style: TextStyle(
                                fontSize: Responsive.getFont(context, 14),
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
                                    '15%',
                                    style: TextStyle(
                                      fontSize: Responsive.getFont(context, 14),
                                      color: const Color(0xFFFF6192),
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                  Container(
                                    margin: EdgeInsets.symmetric(horizontal: 2),
                                    child: Text(
                                      '32,800원',
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
                                  color: Color(0xFFA4A4A4),
                                  width: Responsive.getWidth(context, 13),
                                  height: Responsive.getHeight(context, 11),
                                ),
                                Container(
                                  margin: EdgeInsets.only(left: 2, bottom: 2),
                                  child: Text(
                                    '13,000',
                                    style: TextStyle(
                                      fontSize: Responsive.getFont(context, 12),
                                      color: Color(0xFFA4A4A4),
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
                                          '49',
                                          style: TextStyle(
                                              fontSize: Responsive.getFont(context, 12),
                                            color: Color(0xFFA4A4A4),
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
        ],
      ),
    );
  }
}
