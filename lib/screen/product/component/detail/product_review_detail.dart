import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

import 'report_screen.dart';

class ProductReviewDetail extends StatefulWidget {
  @override
  _ProductReviewDetailState createState() => _ProductReviewDetailState();
}

class _ProductReviewDetailState extends State<ProductReviewDetail> {
  PageController? _pageController;
  int _currentPage = 0;
  final List<String> _images = [
    'assets/images/home/exhi.png',
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

  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        leading: IconButton(
          icon: SvgPicture.asset("assets/images/product/ic_back.svg"),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
        title: const Text(
          '리뷰 상세',
          style: TextStyle(color: Colors.black),
        ),
      ),
      body: SingleChildScrollView(  // Added SingleChildScrollView for scrolling
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Image Carousel
            Container(
              width: screenWidth, // 가로 길이를 화면 전체로 설정
              height: screenWidth, // 세로 길이도 가로 길이와 동일하게 설정
              child: Stack(
                children: [
                  PageView.builder(
                    controller: _pageController,
                    itemCount: _images.length,
                    onPageChanged: (int page) {
                      setState(() {
                        _currentPage = page;
                      });
                    },
                    itemBuilder: (context, index) {
                      return ClipRRect(
                        child: Image.asset(
                          _images[index],
                          fit: BoxFit.cover, // 이미지가 컨테이너를 꽉 채우도록 설정
                          width: double.infinity,
                          height: double.infinity,
                        ),
                      );
                    },
                  ),
                  Positioned(
                    bottom: 10,
                    right: 10,
                    child: Container(
                      padding: EdgeInsets.symmetric(vertical: 4, horizontal: 8),
                      decoration: BoxDecoration(
                        color: Colors.black.withOpacity(0.5),
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: Text(
                        '${_currentPage + 1}/${_images.length}',
                        style: TextStyle(color: Colors.white),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 16),
            Container(
              padding: EdgeInsets.symmetric(horizontal: 16),
              child: Row(
                children: const [
                  Text(
                    'jw**********',
                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                  ),
                  Spacer(),
                  Text(
                    '2024.04.14',
                    style: TextStyle(color: Colors.grey),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 8),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              child: Row(
                children: const [
                  Icon(Icons.star, color: Colors.pink, size: 20),
                  Icon(Icons.star, color: Colors.pink, size: 20),
                  Icon(Icons.star, color: Colors.pink, size: 20),
                  Icon(Icons.star, color: Colors.pink, size: 20),
                  Icon(Icons.star_half, color: Colors.pink, size: 20),
                ],
              ),
            ),
            const SizedBox(height: 16),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              child: Text(
                '저희 아이를 위해 \'밀크마일 여름 티셔츠\'를 구매했는데 정말 만족스럽습니다! '
                    '옷감이 부드럽고 통기성이 좋아서 아이가 하루 종일 입고 다녀도 편안해해요. '
                    '디자인도 아주 귀엽고 색감이 예뻐서 어디에나 잘 어울립니다. '
                    '세탁 후에도 색이 바래지 않고, 형태도 그대로 유지되네요. '
                    '사이즈도 정확하게 맞아서 아이에게 딱 맞아요.\n\n'
                    '가격 대비 품질이 매우 훌륭하고, 배송도 빠르게 이루어졌습니다. '
                    '특히 할인 쿠폰 덕분에 더 저렴하게 구매할 수 있어서 기분이 좋네요. 앞으로도 '
                    '이 쇼핑몰에서 자주 구매할 것 같아요. 부모님들께 강력히 추천합니다!',
                style: TextStyle(fontSize: 14, height: 1.5),
              ),
            ),
            const SizedBox(height: 8),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              child: GestureDetector(
                onTap: () {
                  // 신고 버튼 클릭시 동작
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => ReportScreen()),
                  );
                },
                child: Text(
                  '신고',
                  style: TextStyle(
                    fontSize: 12,
                    color: Colors.grey,
                  ),
                ),
              ),
            ),
            const SizedBox(height: 16), // Add some space at the bottom for good measure
          ],
        ),
      ),
    );
  }
}
