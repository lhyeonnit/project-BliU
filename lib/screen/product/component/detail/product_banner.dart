import 'package:flutter/material.dart';

class ProductBanner extends StatefulWidget {
  @override
  _ProductBannerState createState() => _ProductBannerState();
}

class _ProductBannerState extends State<ProductBanner> {
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

    return Container(
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
    );
  }
}
