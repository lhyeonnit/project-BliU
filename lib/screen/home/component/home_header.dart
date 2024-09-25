import 'dart:async';
import 'package:BliU/utils/responsive.dart';
import 'package:flutter/material.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';

class HomeHeader extends StatefulWidget {
  const HomeHeader({super.key});

  @override
  _HomeHeaderState createState() => _HomeHeaderState();
}

class _HomeHeaderState extends State<HomeHeader> {
  final PageController _pageController = PageController();
  Timer? _timer;
  int _currentPage = 0;
  final int _totalPages = 3;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _timer = Timer.periodic(const Duration(seconds: 3), (Timer timer) {
        if (_currentPage < _totalPages - 1) {
          _currentPage++;
        } else {
          _currentPage = 0;
        }

        _pageController.animateToPage(
          _currentPage,
          duration: const Duration(milliseconds: 300),
          curve: Curves.easeIn,
        );
      });
    });
  }

  @override
  void dispose() {
    _timer?.cancel();
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        PageView(
          controller: _pageController,
          children: [
            buildPage(
              imagePath: 'assets/images/home/main_bn01.png',
              title: '아이들을 위한',
              subtitle: '스타일리시한 선택!',
              description: '특별한 시간을 오래오래 함께하고 하고싶은',
            ),
            buildPage(
              imagePath: 'assets/images/home/main_bn02.png',
              title: '새로운 스타일',
              subtitle: '모두가 주목하는!',
              description: '아이들의 특별한 순간을 위해',
            ),
            buildPage(
              imagePath: 'assets/images/home/main_bn03.png',
              title: '새로운 스타일',
              subtitle: '모두가 주목하는!',
              description: '아이들의 특별한 순간을 위해',
            ),
          ],
        ),
        Positioned(
          top: Responsive.getHeight(context, 536),
          left: Responsive.getWidth(context, 19),
          child: Center(
            child: SmoothPageIndicator(
              controller: _pageController,
              count: _totalPages,
              effect: const WormEffect(
                dotWidth: 6.0,
                dotHeight: 6.0,
                activeDotColor: Colors.white,
                dotColor: Colors.grey,
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget buildPage({
    required String imagePath,
    required String title,
    required String subtitle,
    required String description,
  }) {
    return Stack(
      children: [
        SizedBox(
          width: double.infinity,
          height: Responsive.getHeight(context, 625),
          child: Image.asset(
            imagePath,
            fit: BoxFit.cover, // 이미지를 전체 화면에 맞추고 가로 여백 없이 설정
          ),
        ),
        Positioned(
          top: Responsive.getHeight(context, 409),
          left: Responsive.getWidth(context, 16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                style: TextStyle( fontFamily: 'Pretendard',
                  fontSize: Responsive.getFont(context, 30),
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
              Text(
                subtitle,
                style: TextStyle( fontFamily: 'Pretendard',
                  fontSize: Responsive.getFont(context, 30),
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
              SizedBox(height: Responsive.getHeight(context, 13.82)),
              Text(
                description,
                style: TextStyle( fontFamily: 'Pretendard',
                  fontSize: Responsive.getFont(context, 16),
                  color: Colors.white,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
