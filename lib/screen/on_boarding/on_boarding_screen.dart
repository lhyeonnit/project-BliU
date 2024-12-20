import 'dart:io';

import 'package:BliU/utils/responsive.dart';
import 'package:BliU/utils/utils.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';

class OnBoardingScreen extends StatefulWidget {
  const OnBoardingScreen({super.key});

  @override
  State<OnBoardingScreen> createState() => OnBoardingScreenState();
}

class OnBoardingScreenState extends State<OnBoardingScreen> {
  DateTime? _backButtonPressedTime;
  final PageController _communityPageController = PageController();
  int _currentPage = 0;

  @override
  void initState() {
    super.initState();
    _communityPageController.addListener(() {
      setState(() {
        _currentPage = _communityPageController.page?.round() ?? 0;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: PopScope(
        canPop: false,
        onPopInvokedWithResult: (bool didPop, Object? result) {
          _backPressed();
        },
        child: SafeArea(
          child: Utils.getInstance().isWebView(
            Column(
              children: [
                Expanded(
                  child: PageView.builder(
                    scrollDirection: Axis.horizontal,
                    controller: _communityPageController,
                    physics: const BouncingScrollPhysics(),
                    itemCount: 3,
                    itemBuilder: (context, index) {
                      String imagePath = '';
                      switch (index) {
                        case 0:
                          imagePath = 'assets/images/onbImg01.png';
                          break;
                        case 1:
                          imagePath = 'assets/images/onbImg02.png';
                          break;
                        case 2:
                          imagePath = 'assets/images/onbImg03.png';
                          break;
                      }
                      return Container(
                        color: Colors.white,
                        child: Image.asset(
                          imagePath,
                          width: double.infinity,
                          fit: BoxFit.cover,
                        ),
                      );
                    },
                  ),
                ),
                Container(
                  margin: const EdgeInsets.only(top: 30, bottom: 10),
                  alignment: Alignment.center,
                  child: SmoothPageIndicator(
                    controller: _communityPageController,
                    count: 3,
                    effect: const ScrollingDotsEffect(
                      activeDotColor: Colors.black,
                      dotColor: Color(0xFFDDDDDD),
                      activeStrokeWidth: 10,
                      activeDotScale: 1.5,
                      maxVisibleDots: 5,
                      radius: 8,
                      spacing: 6,
                      dotHeight: 4,
                      dotWidth: 4,
                    ),
                  ),
                ),
                Align(
                  alignment: Alignment.centerRight,
                  child: GestureDetector(
                    onTap: () {
                      Navigator.pushReplacementNamed(context, "/index");
                    },
                    child: Container(
                      margin: const EdgeInsets.only(right: 16, bottom: 20),
                      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 11),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(19),
                        border: Border.all(
                          width: 1,
                          color: const Color(0xffDDDDDD),
                        ),
                      ),
                      child: Text(
                        _currentPage == 2 ? "다음" : "건너뛰기",
                        style: TextStyle(
                          fontFamily: 'Pretendard',
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
        ),
      ),
    );
  }

  Future<void> _backPressed() async {
    if (Platform.isAndroid) { // 안드로이드 경우일때만
      DateTime currentTime = DateTime.now();

      //Statement 1 Or statement2
      bool backButton = _backButtonPressedTime == null ||
          currentTime.difference(_backButtonPressedTime!) > const Duration(seconds: 3);

      if (backButton) {
        _backButtonPressedTime = currentTime;
        Utils.getInstance().showSnackBar(context, "한번 더 뒤로가기를 누를 시 종료됩니다");
        return;
      }

      SystemNavigator.pop();
    }
  }
}
