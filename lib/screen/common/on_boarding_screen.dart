import 'dart:io';
import 'package:BliU/screen/main_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
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
      body: Stack(children: <Widget>[
        SafeArea(
          child: Column(
            children: [
              Expanded(
                flex: 66,
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
                      color: Colors.white, // 배경색을 흰색으로 설정
                      child: Align(
                        alignment: Alignment.topCenter, // 상단 중앙에 맞추기
                        child: Image.asset(
                          imagePath,
                          width: 412,
                          height: 660,
                        ),
                      ),
                    );
                  },
                ),
              ),
              SizedBox(
                height: 100,
                width: 412,
                child: Column(
                  children: [
                    Expanded(
                      flex: 1,
                      child: Container(
                        color: Colors.white,
                        width: double.infinity,
                        alignment: Alignment.center,
                        child: SmoothPageIndicator(
                          controller: _communityPageController,
                          count: 3,
                          effect: const ScrollingDotsEffect(
                            activeDotColor: Colors.indigoAccent,
                            activeStrokeWidth: 10,
                            activeDotScale: 1.5,
                            maxVisibleDots: 5,
                            radius: 8,
                            spacing: 10,
                            dotHeight: 4,
                            dotWidth: 4,
                          ),
                        ),
                      ),
                    ),
                    Container(
                      color: Colors.white,
                      alignment: Alignment.topRight,
                      height: 58,
                      child: SizedBox(
                        child: InkWell(
                          onTap: () {
                            Get.off(() => const MainPage()); // MainPage로 이동하고 온보딩 화면 제거
                          },
                          child: Container(
                            width: 88,
                            height: 38,
                            margin: const EdgeInsets.only(right: 16),
                            alignment: Alignment.center,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(19),
                              border: Border.all(
                                width: 1,
                                color: const Color(0xffDDDDDD),
                              ),
                            ),
                            child: Text(
                              _currentPage == 2 ? "다음" : "건너뛰기",
                              style: const TextStyle(fontSize: 14),
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              )
            ],
          ),
        ),
      ]),
    );
  }

  Future<void> _backPressed() async {
    if (Platform.isAndroid) { // 안드로이드 경우일때만
      DateTime currentTime = DateTime.now();

      bool backButton = _backButtonPressedTime == null ||
          currentTime.difference(_backButtonPressedTime!) > const Duration(seconds: 3);

      if (backButton) {
        _backButtonPressedTime = currentTime;
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text("한번 더 뒤로가기를 누를 시 종료됩니다"),
            duration: Duration(seconds: 3),
          ),
        );
        return;
      }

      SystemNavigator.pop();
    }
  }
}
