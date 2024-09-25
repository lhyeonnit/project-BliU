import 'package:BliU/screen/_component/smart_lens_screen.dart';
import 'package:BliU/screen/product/product_detail_screen.dart';
import 'package:BliU/utils/responsive.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

class SmartLensResult extends StatefulWidget {
  const SmartLensResult({super.key});

  @override
  State<SmartLensResult> createState() => _SmartLensResultState();
}

class _SmartLensResultState extends State<SmartLensResult> {
  final bool result = true;
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
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        scrolledUnderElevation: 0,
        backgroundColor: Colors.white,
        title: const Text('스마트렌즈'),
        titleTextStyle: TextStyle( fontFamily: 'Pretendard',
          fontSize: Responsive.getFont(context, 18),
          fontWeight: FontWeight.w600,
          color: Colors.black,
        ),
        leading: IconButton(
          icon: SvgPicture.asset("assets/images/store/ic_back.svg"),
          onPressed: () {
            Navigator.pop(context); // 뒤로가기 동작
          },
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
      ),
      body: Stack(
        children: [
          Column(
            children: [
              Expanded(
                child: Container(
                  height: 300, // 상단 이미지 높이 설정
                  decoration: BoxDecoration(
                    color: Colors.amber,
                  ),
                ),
              ),
            ],
          ),
          if (result == true)
          Align(
            alignment: Alignment.bottomCenter,
            child: DraggableScrollableSheet(
              initialChildSize: 0.5, // 처음 열렸을 때 차지할 화면 비율 (0.4는 40%)
              minChildSize: 0.5, // 최소 확장 크기
              maxChildSize: 0.95, // 최대 확장 크기
              builder:
                  (BuildContext context, ScrollController scrollController) {
                return Container(
                  padding: EdgeInsets.symmetric(horizontal: 16),
                  decoration: const BoxDecoration(
                    color: Colors.white,
                    borderRadius:
                        BorderRadius.vertical(top: Radius.circular(8)),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Center(
                        child: Container(
                          margin: const EdgeInsets.only(bottom: 17, top: 15),
                          width: 40,
                          height: 4,
                          decoration: BoxDecoration(
                            color: Color(0xFFDDDDDD),
                            borderRadius: BorderRadius.circular(3),
                          ),
                        ),
                      ),
                      Container(
                        margin: EdgeInsets.only(top: 13, bottom: 20),
                        child: Text(
                          '이미지와 비슷한 상품',
                          style: TextStyle( fontFamily: 'Pretendard',
                            fontSize: Responsive.getFont(context, 20),
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                      Expanded(
                        child: GridView.builder(
                          controller: scrollController,
                          gridDelegate:
                              const SliverGridDelegateWithFixedCrossAxisCount(
                            crossAxisCount: 2,
                            childAspectRatio: 0.55,
                            crossAxisSpacing: 12,
                            mainAxisSpacing: 30,
                          ),
                          itemCount: items.length,
                          itemBuilder: (context, index) {
                            return buildItemCard(items[index], index);
                          },
                        ),
                      ),
                    ],
                  ),
                );
              },
            ),
          ),
          if (result == false)
          Align(
            alignment: Alignment.bottomCenter,
            child: DraggableScrollableSheet(
              initialChildSize: 0.5, // 처음 열렸을 때 차지할 화면 비율 (0.4는 40%)
              minChildSize: 0.5, // 최소 확장 크기
              maxChildSize: 0.5, // 최대 확장 크기
              builder:
                  (BuildContext context, ScrollController scrollController) {
                return Container(
                  padding: EdgeInsets.symmetric(horizontal: 16),
                  decoration: const BoxDecoration(
                    color: Colors.white,
                    borderRadius:
                    BorderRadius.vertical(top: Radius.circular(8)),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Center(
                        child: Container(
                          margin: const EdgeInsets.only(bottom: 17, top: 15),
                          width: 40,
                          height: 4,
                          decoration: BoxDecoration(
                            color: Color(0xFFDDDDDD),
                            borderRadius: BorderRadius.circular(3),
                          ),
                        ),
                      ),
                      Container(
                          margin: EdgeInsets.only(bottom: 25,top: 23),
                          width: 90,
                          height: 90,
                          padding: EdgeInsets.all(20),
                          decoration: BoxDecoration(
                            color: Color(0xFFF5F9F9),
                            borderRadius: BorderRadius.all(Radius.circular(70)),
                          ),
                          child: SvgPicture.asset(
                            'assets/images/product/ic_top_sch.svg',
                            height: 50,
                            width: 50,
                          )),
                      Container(
                          margin: EdgeInsets.only(bottom: 10),
                          child: Text('비슷한 상품을 찾지 못했어요',
                              style: TextStyle( fontFamily: 'Pretendard',
                                  fontSize: Responsive.getFont(context, 18),
                                  fontWeight: FontWeight.bold))),
                      Text('다른 이미지로 찾아보세요.',
                          style: TextStyle( fontFamily: 'Pretendard',
                              fontSize: Responsive.getFont(context, 14),
                              color: Color(0xFFA4A4A4))),
                      GestureDetector(
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => SmartLensScreen(),
                            ),
                          );
                        },
                        child: Container(
                            margin: EdgeInsets.only(top: 20),
                            padding: EdgeInsets.symmetric(vertical: 14),
                            width: 150,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(22),
                              border: Border.all(color: Color(0xFFDDDDDD)),
                            ),
                            child: Center(
                              child: Text('다시 검색하기',
                                  style: TextStyle( fontFamily: 'Pretendard',
                                      fontSize: Responsive.getFont(context, 14),
                                      fontWeight: FontWeight.bold)),
                            )),
                      ),
                    ],
                  ),
                );
              },
            ),
          ),
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
                    style: TextStyle( fontFamily: 'Pretendard',
                        fontSize: Responsive.getFont(context, 12),
                        color: Colors.grey),
                  ),
                ),
                Text(
                  item['name']!,
                  style: TextStyle( fontFamily: 'Pretendard',
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
                        style: TextStyle( fontFamily: 'Pretendard',
                          fontSize: Responsive.getFont(context, 14),
                          color: const Color(0xFFFF6192),
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      Container(
                        margin: EdgeInsets.symmetric(horizontal: 2),
                        child: Text(
                          item['price']!,
                          style: TextStyle( fontFamily: 'Pretendard',
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
                        style: TextStyle( fontFamily: 'Pretendard',
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
                              style: TextStyle( fontFamily: 'Pretendard',
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
