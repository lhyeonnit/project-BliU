import 'package:BliU/screen/_component/cart_screen.dart';
import 'package:BliU/screen/_component/move_top_button.dart';
import 'package:BliU/screen/product/product_detail_screen.dart';
import 'package:BliU/utils/responsive.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

import '../_component/search_screen.dart';

//기획전
class ExhibitionScreen extends StatefulWidget {
  const ExhibitionScreen({super.key});

  @override
  State<StatefulWidget> createState() => ExhibitionScreenState();
}

class ExhibitionScreenState extends State<ExhibitionScreen> {
  final ScrollController _scrollController = ScrollController();
  List<bool> isFavoriteList = List<bool>.generate(10, (index) => false);
  final List<Map<String, String>> items = [
    {
      'image': 'http://example.com/item1.png',
      'name': '꿈꾸는데이지 안나 토션 레이스 베스트',
      'brand': '꿈꾸는데이지',
      'price': '32,800원',
      'discount': '15%',
      'likes': '13,000',
      'comments': '49'
    },
    {
      'image': 'http://example.com/item2.png',
      'name': '레인보우꿈 안나 토션 레이스 베스트',
      'brand': '레인보우꿈',
      'price': '32,800원',
      'discount': '15%',
      'likes': '13,000',
      'comments': '49'
    },
    {
      'image': 'http://example.com/item3.png',
      'name': '기글옷장 안나 토션 레이스 베스트',
      'brand': '기글옷장',
      'price': '32,800원',
      'discount': '15%',
      'likes': '13,000',
      'comments': '49'
    },
    {
      'image': 'http://example.com/item4.png',
      'name': '스파클나라 안나 토션 레이스 베스트',
      'brand': '스파클나라',
      'price': '32,800원',
      'discount': '15%',
      'likes': '13,000',
      'comments': '49'
    },
  ];
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        scrolledUnderElevation: 0,
        backgroundColor: Colors.white,
        leading: IconButton(
          icon: SvgPicture.asset("assets/images/exhibition/ic_back.svg"),
          onPressed: () {
            Navigator.pop(context); // 뒤로가기 동작
          },
        ),
        title: const Text("우리 아이를 위한 포근한 선택"),
        titleTextStyle: TextStyle(
          fontSize: Responsive.getFont(context, 18),
          fontWeight: FontWeight.w600,
          color: Colors.black,
        ),
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(1.0), // 하단 구분선의 높이 설정
          child: Container(
            color: const Color(0xFFF4F4F4), // 하단 구분선 색상
            height: 1.0, // 구분선의 두께 설정
            child: Container(
              height: 1.0, // 그림자 부분의 높이
              decoration: const BoxDecoration(
                boxShadow: [
                  BoxShadow(
                    color: Color(0xFFF4F4F4),
                    blurRadius: 6.0,
                    spreadRadius: 1.0,
                  ),
                ],
              ),
            ),
          ),
        ),
        actions: [
          IconButton(
            icon: SvgPicture.asset("assets/images/exhibition/ic_top_sch.svg"),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => const SearchScreen(),
                ),
              );
            },
          ),
          Stack(
            children: [
              IconButton(
                icon: SvgPicture.asset("assets/images/exhibition/ic_cart.svg"),
                onPressed: () {
                  // 장바구니 버튼 동작
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const CartScreen(),
                    ),
                  );
                },
              ),
              Positioned(
                right: 8,
                top: 28,
                child: Container(
                  padding: const EdgeInsets.all(2),
                  decoration: BoxDecoration(
                    color: const Color(0xFFFF6191),
                    borderRadius: BorderRadius.circular(6),
                  ),
                  constraints: BoxConstraints(
                    minWidth: Responsive.getWidth(context, 15),
                    minHeight: Responsive.getHeight(context, 14),
                  ),
                  child: Text(
                    '2',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: Responsive.getFont(context, 9),
                    ),
                    textAlign: TextAlign.center,
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
      body: Stack(
        children: [
          SingleChildScrollView(
            controller: _scrollController,
            scrollDirection: Axis.vertical,
            child: Column(
              children: [
                SizedBox(
                  height: 620,
                  width: Responsive.getWidth(context, 412),
                  child: Image.asset(
                    "assets/images/exhibition/exhibition_img.png",
                    width: Responsive.getWidth(context, 412),
                    height: 620,
                    fit: BoxFit.contain,
                    alignment: Alignment.topCenter,
                  ),
                ),
                Container(
                  margin: EdgeInsets.only(bottom: 10),
                  child: Text(
                    '우리 아이를 위한 포근한 선택',
                    style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: Responsive.getFont(context, 20)),
                  ),
                ),
                Container(
                  child: Text(
                    '집에서도 스타일리시하게!\n우리 아이를 위한 홈웨어 컬렉션.',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                        fontSize: Responsive.getFont(context, 14),
                        color: const Color(0xFF7B7B7B)),
                  ),
                ),
                Container(
                  margin: EdgeInsets.symmetric(vertical:30, horizontal: 16),
                  child: GridView.builder(
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 2,
                      crossAxisSpacing: 12.0,
                      mainAxisSpacing: 30.0,
                      childAspectRatio: 0.55,
                    ),
                    itemCount: items.length,
                    itemBuilder: (context, index) {
                      return buildItemCard(items[index], index);
                    },
                  ),
                ),
              ],
            ),
          ),
          MoveTopButton(scrollController: _scrollController)
        ],
      ),
    );
  }
  Widget buildItemCard(Map<String, String> item, int index) {
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
                  borderRadius:
                  const BorderRadius.all(Radius.circular(5)),
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
                    item['brand']!,
                    style: TextStyle(
                        fontSize: Responsive.getFont(context, 12),
                        color: Colors.grey),
                  ),
                ),
                Text(
                  item['name']!,
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
                        item['discount']!,
                        style: TextStyle(
                          fontSize: Responsive.getFont(context, 14),
                          color: const Color(0xFFFF6192),
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      Container(
                        margin: EdgeInsets.symmetric(horizontal: 2),
                        child: Text(
                          item['price']!,
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
                        item['likes']!,
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
                              item['comments']!,
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
