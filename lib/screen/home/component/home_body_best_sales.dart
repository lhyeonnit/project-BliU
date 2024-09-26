import 'package:BliU/screen/product/product_detail_screen.dart';
import 'package:BliU/screen/store/component/store_age_group_selection.dart';
import 'package:BliU/utils/responsive.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:flutter_svg/svg.dart';

class HomeBodyBestSales extends StatefulWidget {
  const HomeBodyBestSales({super.key});

  @override
  State<HomeBodyBestSales> createState() => _HomeBodyBestSalesState();
}

class _HomeBodyBestSalesState extends State<HomeBodyBestSales> {
  String selectedAgeGroup = '';
  List<bool> isFavoriteList = List<bool>.generate(10, (index) => false);

  void _showAgeGroupSelection() {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.white,
      builder: (BuildContext context) {
        return StoreAgeGroupSelection(
          selectedAgeGroup: selectedAgeGroup,
          onSelectionChanged: (String newSelection) {
            setState(() {
              selectedAgeGroup = newSelection;
            });
          },
        );
      },
    );
  }

  String getSelectedAgeGroupText() {
    if (selectedAgeGroup.isEmpty) {
      return '연령';
    } else {
      return selectedAgeGroup;
    }
  }

  final List<String> categories = [
    '전체',
    '아우터',
    '상의',
    '하의',
    '원피스',
    '슈즈',
  ];

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

  String selectedCategory = '전체';

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.only(left: 16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            '판매베스트',
            style: TextStyle(
              fontFamily: 'Pretendard',
              fontSize: Responsive.getFont(context, 20),
              fontWeight: FontWeight.bold,
            ),
          ),
          Container(
            margin: const EdgeInsets.only(top: 20),
            child: SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Row(
                children: List<Widget>.generate(categories.length, (index) {
                  return Container(
                    padding: const EdgeInsets.only(right: 4.0),
                    child: GestureDetector(
                      onTap: () {
                        setState(() {
                          selectedCategory = categories[index];
                        });
                      },
                      child: categoryTab(index),
                    ),
                  );
                }),
              ),
            ),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              Container(
                margin: const EdgeInsets.only(top: 20.0),
                padding: const EdgeInsets.only(right: 16.0),
                child: GestureDetector(
                  onTap: _showAgeGroupSelection,
                  child: Container(
                    padding: const EdgeInsets.fromLTRB(20, 11, 20, 11),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      shape: BoxShape.rectangle,
                      borderRadius: BorderRadius.circular(22),
                      border: Border.all(
                        color: const Color(0xFFDDDDDD), // 테두리 색상
                      ),
                    ),
                    child: Row(
                      children: [
                        Container(
                          margin: EdgeInsets.only(right: 5),
                          child: Text(
                            getSelectedAgeGroupText(),
                            style: TextStyle(
                                fontFamily: 'Pretendard',
                                fontSize: Responsive.getFont(context, 14),
                                color: Colors.black),
                          ),
                        ),
                        SvgPicture.asset(
                          "assets/images/product/filter_select.svg",
                          width: 14,
                          height: 14,
                          fit: BoxFit.contain,
                          alignment: Alignment.topCenter,
                        )
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
          Container(
            margin: EdgeInsets.only(right: 16, bottom: 29),
            child: GridView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                crossAxisSpacing: 12.0,
                mainAxisSpacing: 30.0,
                childAspectRatio: 0.5,
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
  }

  Widget categoryTab(int index) {
    var borderColor = const Color(0xFFDDDDDD);
    var textColor = Colors.black;

    if (selectedCategory == categories[index]) {
      borderColor = const Color(0xFFFF6192);
      textColor = const Color(0xFFFF6192);
    }

    return Container(
      padding: const EdgeInsets.fromLTRB(20, 11, 20, 11),
      decoration: BoxDecoration(
        color: Colors.white,
        shape: BoxShape.rectangle,
        borderRadius: BorderRadius.circular(200),
        border: Border.all(
          color: borderColor, // 테두리 색상
          width: 1.0,
        ),
      ),
      child: Text(
        categories[index],
        style: TextStyle(
            fontFamily: 'Pretendard',
            fontSize: Responsive.getFont(context, 14),
            color: textColor),
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
                    style: TextStyle(
                        fontFamily: 'Pretendard',
                        fontSize: Responsive.getFont(context, 12),
                        color: Colors.grey),
                  ),
                ),
                Text(
                  item['name']!,
                  style: TextStyle(
                    fontFamily: 'Pretendard',
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
                          fontFamily: 'Pretendard',
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
                            fontFamily: 'Pretendard',
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
                          fontFamily: 'Pretendard',
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
                                  fontFamily: 'Pretendard',
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
