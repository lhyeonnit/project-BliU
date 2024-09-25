import 'dart:async';

import 'package:BliU/screen/login/login_screen.dart';
import 'package:BliU/utils/responsive.dart';
import 'package:flutter/material.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';

class NonTopScreen extends StatefulWidget {
  const NonTopScreen({super.key});

  @override
  State<NonTopScreen> createState() => _NonTopScreenState();
}

class _NonTopScreenState extends State<NonTopScreen> {
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
        Container(
          margin: EdgeInsets.symmetric(horizontal: 16),
          padding: EdgeInsets.only(top: 20),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Container(
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Container(
                      height: 70,
                      width: 70,
                      decoration: BoxDecoration(
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
                      margin: EdgeInsets.only(left: 10),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Container(
                              margin: EdgeInsets.only(bottom: 4),
                              child: Text('블리유', style: TextStyle( fontFamily: 'Pretendard',fontSize: Responsive.getFont(context, 18), fontWeight: FontWeight.bold),)),
                          Text('회원이 되어 주세요!', style: TextStyle( fontFamily: 'Pretendard',color: Color(0xFF7B7B7B), fontSize: Responsive.getFont(context, 12)),),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              GestureDetector(
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => LoginScreen()
                    ),
                  );
                },
                child: Container(
                  padding: EdgeInsets.symmetric(vertical: 11,horizontal: 20),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(22),
                    border: Border.all(color: Color(0xFFFF6192)),
                  ),
                  child: Text('로그인', style: TextStyle( fontFamily: 'Pretendard',color: Color(0xFFFF6192), fontSize: Responsive.getFont(context, 14)),),
                ),
              ),
            ],
          ),
        ),
        Container(
          height: 80,
          margin: EdgeInsets.symmetric(vertical: 20),
          child: PageView.builder(
            controller: _pageController,
            itemCount: _totalPages,
            itemBuilder: (context, index) {
              return ClipRRect(
                  borderRadius: BorderRadius.circular(9),
                  child: Image.asset(banners[index]));
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
              dotColor: Color(0xFFDDDDDD),
            ),
          ),
        ),
      ],
    );
  }
}
