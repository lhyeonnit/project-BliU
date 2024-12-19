import 'dart:async';

import 'package:BliU/utils/responsive.dart';
import 'package:flutter/material.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';

class NonTopChildWidget extends StatefulWidget {
  const NonTopChildWidget({super.key});

  @override
  State<NonTopChildWidget> createState() => NonTopChildWidgetState();
}

class NonTopChildWidgetState extends State<NonTopChildWidget> {
  final PageController _pageController = PageController();
  Timer? _timer;
  int _currentPage = 0;
  final int _totalPages = 4;

  final List<String> _banners = [
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
        Container(
          margin: const EdgeInsets.symmetric(horizontal: 16),
          padding: const EdgeInsets.only(top: 20),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Container(
                    height: 70,
                    width: 70,
                    decoration: const BoxDecoration(
                      shape: BoxShape.circle,
                      gradient: LinearGradient(
                        colors: [
                          Color(0xFFFFE4DF), // 첫 번째 색상
                          Color(0xFFFFDFEE), // 두 번째 색상
                        ],
                        begin: Alignment.topCenter,
                        end: Alignment.bottomCenter,
                      ),
                    ),
                    child: ClipOval(child: Image.asset('assets/images/non/gender_select_boy.png')),
                  ),
                  Container(
                    margin: const EdgeInsets.only(left: 10),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Container(
                          margin: const EdgeInsets.only(bottom: 4),
                          child: Text(
                            '블리유',
                            style: TextStyle(
                              fontFamily: 'Pretendard',
                              fontSize: Responsive.getFont(context, 18),
                              fontWeight: FontWeight.bold,
                              height: 1.2,
                            ),
                          ),
                        ),
                        Text(
                          '회원이 되어 주세요!',
                          style: TextStyle(
                            fontFamily: 'Pretendard',
                            color: const Color(0xFF7B7B7B),
                            fontSize: Responsive.getFont(context, 12),
                            height: 1.2,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              GestureDetector(
                onTap: () {
                  Navigator.pushNamed(context, "/login/N");
                },
                child: Container(
                  height: 38,
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(22),
                    border: Border.all(color: const Color(0xFFFF6192)),
                  ),
                  child: Center(
                    child: Text(
                      '로그인',
                      style: TextStyle(
                        fontFamily: 'Pretendard',
                        color: const Color(0xFFFF6192),
                        fontSize: Responsive.getFont(context, 14),
                        height: 1.2,
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
        Container(
          clipBehavior: Clip.antiAlias,
          margin: const EdgeInsets.symmetric(vertical: 15, horizontal: 16),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(6),
          ),
          child:AspectRatio(
            aspectRatio: 38/8,
            child: PageView.builder(
              controller: _pageController,
              itemCount: _totalPages,
              itemBuilder: (context, index) {
                return ClipRRect(
                  borderRadius: BorderRadius.circular(6),
                  child: Image.asset(_banners[index]),
                );
              },
            ),
          ),
        ),
        Center(
          child: SmoothPageIndicator(
            controller: _pageController,
            count: _totalPages,
            effect: CustomizableEffect(
              activeDotDecoration: DotDecoration(
                width: 6.0,
                height: 6.0,
                color: Colors.black,
                borderRadius: BorderRadius.circular(50),
              ),
              dotDecoration: DotDecoration(
                width: 5.0, // 미선택된 dot의 크기
                height: 5.0,
                color: const Color(0xFFDDDDDD),
                borderRadius: BorderRadius.circular(50),
              ),
            ),
          ),
        ),
      ],
    );
  }
}
