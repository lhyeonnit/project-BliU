import 'dart:async';

import 'package:flutter/material.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';

class NonTop extends StatefulWidget {
  const NonTop({super.key});

  @override
  State<NonTop> createState() => _NonTopState();
}

class _NonTopState extends State<NonTop> {
  final PageController _pageController = PageController();
  Timer? _timer;
  int _currentPage = 0;
  final int _totalPages = 4;

  final List<String> banners = [
    'assets/images/non/not_member_bn01.png',
    'assets/images/non/not_member_bn02.png',
    'assets/images/non/not_member_bn03.png',
    'assets/images/non/not_member_bn04.png',
  ];

  @override
  void initState() {
    super.initState();

    // 타이머를 이용한 페이지 자동 넘기기
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
  }

  @override
  void dispose() {
    _timer?.cancel(); // 타이머 해제
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Row(
          children: [],
        ),
        Container(
          height: 420,
          child: PageView.builder(
            controller: _pageController,
            itemCount: _totalPages,
            itemBuilder: (context, index) {
              return Image.asset(banners[index]);
            },
          ),
        ),
        Center(
          child: SmoothPageIndicator(
            controller: _pageController,
            count: _totalPages,
            effect: const WormEffect(
              dotWidth: 6.0,
              dotHeight: 6.0,
              activeDotColor: Colors.black,
              dotColor: Colors.grey,
            ),
          ),
        ),
      ],
    );
  }
}
