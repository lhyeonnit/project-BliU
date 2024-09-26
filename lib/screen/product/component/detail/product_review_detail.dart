import 'package:BliU/utils/responsive.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

import 'report_page.dart';

class ProductReviewDetail extends StatefulWidget {
  const ProductReviewDetail({super.key});

  @override
  _ProductReviewDetailState createState() => _ProductReviewDetailState();
}

class _ProductReviewDetailState extends State<ProductReviewDetail> {
  PageController? _pageController;
  int _currentPage = 0;
  final ScrollController _scrollController = ScrollController();

  final List<String> _images = [
    'assets/images/home/exhi.png',
    'assets/images/home/exhi.png',
    'assets/images/home/exhi.png',
    'assets/images/home/exhi.png',
    // 이미지 경로를 여기에 추가합니다.
  ];

  @override
  void initState() {
    super.initState();
    _pageController = PageController();
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
          Icon(
            Icons.star,
            color: Color(0xFFFF6191),
            size: 16,
          ),

        if (hasHalfStar) _buildHalfStar(rating),

        // 빈 별을 표시
        for (int i = 0; i < emptyStars; i++)
          Icon(
            Icons.star,
            color: Color(0xFFEEEEEE),
            size: 16,
          ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        scrolledUnderElevation: 0,
        backgroundColor: Colors.white,
        title: const Text('리뷰 상세'),
        titleTextStyle: TextStyle(
          fontFamily: 'Pretendard',
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
      body: SingleChildScrollView(
        controller: _scrollController,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Stack(
              children: [
                Container(
                  height: Responsive.getHeight(context, 412),
                  child: PageView.builder(
                    controller: _pageController,
                    itemCount: _images.length,
                    onPageChanged: (int page) {
                      setState(() {
                        _currentPage = page;
                      });
                    },
                    itemBuilder: (context, index) {
                      return Image.asset(
                        _images[index],
                        fit: BoxFit.cover,
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
                    decoration: BoxDecoration(
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
                              color: Colors.white),
                        ),
                        Text(
                          '/${_images.length}',
                          style: TextStyle(
                              fontFamily: 'Pretendard',
                              fontSize: Responsive.getFont(context, 13),
                              color: Color(0x80FFFFFF)),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
            Container(
              padding: EdgeInsets.symmetric(horizontal: 16, vertical: 30),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Text(
                        'blackpink22',
                        style: TextStyle(
                            fontFamily: 'Pretendard',
                            fontSize: Responsive.getFont(context, 12),
                            color: Color(0xFF7B7B7B)),
                      ),
                      Container(
                        margin: EdgeInsets.symmetric(horizontal: 10),
                        child: Text(
                          '2024.04.14',
                          style: TextStyle(
                              fontFamily: 'Pretendard',
                              fontSize: Responsive.getFont(context, 12),
                              color: Color(0xFF7B7B7B)),
                        ),
                      ),
                    ],
                  ),
                  Container(
                    margin: EdgeInsets.symmetric(vertical: 10),
                    child: _ratingStars(4.5),
                  ),
                  Text(
                    '저희 아이를 위해 밀크마일 여름 티셔츠를 구매했는데 정말 만족스럽습니다! 옷감이 부드럽고 통기성이 좋아서 아이가 하루 종일 입고 다녀도 편안해해요. 디자인도 아주 귀엽고 색감이 예뻐서 어디에나 잘 어울립니다. 세탁 후에도 색이 바래지 않고, 형태도 그대로 유지되네요. 사이즈도 정확하게 맞아서 아이에게 딱 맞아요. \n\n가격 대비 품질이 매우 훌륭하고, 배송도 빠르게 이루어졌습니다. 특히 할인 쿠폰 덕분에 더 저렴하게 구매할 수 있어서 기분이 좋네요. 앞으로도 이 쇼핑몰에서 자주 구매할 것 같아요. 부모님들께 강력히 추천합니다!',
                    style: TextStyle(
                        fontFamily: 'Pretendard',
                        fontSize: Responsive.getFont(context, 14)),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(top: 10.0),
                    child: GestureDetector(
                      onTap: () {
                        // 신고 버튼 클릭시 동작
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => const ReportPage()),
                        );
                      },
                      child: const Text(
                        '신고',
                        style: TextStyle(
                          fontFamily: 'Pretendard',
                          fontSize: 12,
                          color: Colors.grey,
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
    );
  }
}

Widget _buildHalfStar(double rating) {
  return Stack(
    children: [
      Icon(
        Icons.star,
        color: Color(0xFFEEEEEE), // 빈 별 색상
        size: 16,
      ),
      ClipRect(
        clipper: HalfClipper(),
        child: Icon(
          Icons.star,
          color: Color(0xFFFF6191), // 채워진 별 색상
          size: 16,
        ),
      ),
    ],
  );
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
