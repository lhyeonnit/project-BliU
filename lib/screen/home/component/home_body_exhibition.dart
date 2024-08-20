import 'dart:async';
import 'package:BliU/utils/responsive.dart';
import 'package:flutter/material.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';
import '../exhibition_screen.dart';

class HomeBodyExhibition extends StatefulWidget {
  const HomeBodyExhibition({super.key});

  @override
  HomeBodyExhibitionState createState() => HomeBodyExhibitionState();
}

class HomeBodyExhibitionState extends State<HomeBodyExhibition> {
  final PageController _pageController = PageController();
  Timer? _timer;
  int _currentPage = 0;
  final int _totalPages = 3;

  @override
  void initState() {
    super.initState();

    // 타이머를 이용한 페이지 자동 넘기기
    _timer = Timer.periodic(Duration(seconds: 3), (Timer timer) {
      if (_currentPage < _totalPages - 1) {
        _currentPage++;
      } else {
        _currentPage = 0;
      }

      _pageController.animateToPage(
        _currentPage,
        duration: Duration(milliseconds: 300),
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
          width: Responsive.getWidth(context, 380),
          height: 420,
          child: PageView.builder(
            controller: _pageController,
            itemCount: _totalPages,
            itemBuilder: (context, index) {
              return buildPage(
                imagePath: 'assets/images/home/main_bn0${index + 1}.png',
                title: index == 0 ? '우리 아이를 위한 포근한 선택' : '새로운 스타일',
                subtitle: index == 0
                    ? '집에서도 스타일리시하게!\n우리 아이를 위한 홈웨어 컬렉션.'
                    : '모두가 주목하는!\n아이들의 특별한 순간을 위해.',
              );
            },
          ),
        ),
        SizedBox(height: 25),
        Center(
          child: SmoothPageIndicator(
            controller: _pageController,
            count: _totalPages,
            effect: WormEffect(
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

  Widget buildPage({
    required String imagePath,
    required String title,
    required String subtitle,
  }) {
    return Stack(
      children: [
        Container(
          width: Responsive.getWidth(context, 380),
          height: 420,
          child: ClipRRect(
            borderRadius: BorderRadius.all(Radius.circular(8)),
            child: Image.asset(
              imagePath,
              fit: BoxFit.cover, // 이미지를 부모 위젯에 맞게 설정
            ),
          ),
        ),
        Positioned.fill(
          child: Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.only(
                bottomLeft: Radius.circular(8.0),
                bottomRight: Radius.circular(8.0),
              ),
              gradient: LinearGradient(
                colors: [Colors.black.withOpacity(0.5), Colors.transparent],
                begin: Alignment.bottomCenter,
                end: Alignment.center,
              ),
            ),
          ),
        ),
        Positioned(
          bottom: 15,
          left: Responsive.getWidth(context, 20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                style: TextStyle(
                  fontSize: Responsive.getFont(context, 22),
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
              SizedBox(height: Responsive.getHeight(context, 10)),
              Text(
                subtitle,
                style: TextStyle(
                  fontSize: Responsive.getFont(context, 14),
                  color: Colors.white,
                ),
              ),
              SizedBox(height: Responsive.getHeight(context, 15)),
              Container(
                width: Responsive.getWidth(context, 340),
                height: 84,
                child: Row(
                  children: [
                    ClipRRect(
                      borderRadius: BorderRadius.circular(5.0),
                      child: Image.asset(
                        'assets/images/home/exhi.png',
                        width: Responsive.getWidth(context, 84),
                        height: Responsive.getHeight(context, 84),
                        fit: BoxFit.cover, // 이 부분도 추가하면 이미지가 컨테이너를 꽉 채우게 됩니다.
                      ),
                    ),
                    SizedBox(width: Responsive.getWidth(context, 10)),
                    ClipRRect(
                      borderRadius: BorderRadius.circular(5.0),
                      child: Image.asset(
                        'assets/images/home/exhi.png',
                        width: Responsive.getWidth(context, 84),
                        height: Responsive.getHeight(context, 84),
                        fit: BoxFit.cover,
                      ),
                    ),
                    SizedBox(width: Responsive.getWidth(context, 10)),
                    ClipRRect(
                      borderRadius: BorderRadius.circular(5.0),
                      child: Image.asset(
                        'assets/images/home/exhi.png',
                        width: Responsive.getWidth(context, 84),
                        height: Responsive.getHeight(context, 84),
                        fit: BoxFit.cover,
                      ),
                    ),
                    SizedBox(width: Responsive.getWidth(context, 10)),
                    TextButton(
                      style: TextButton.styleFrom(
                        padding: EdgeInsets.zero, // 여백 없앰
                        minimumSize: Size.zero, // 최소 사이즈를 0으로 설정하여 여백 제거
                      ),
                        onPressed: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => ExhibitionScreen(),
                            ),
                          );
                        },
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            // 원형 컨테이너 안에 텍스트
                            Container(
                              width: Responsive.getWidth(context, 58),
                              height: 60,
                              decoration: BoxDecoration(
                                color: Colors.white,
                                shape: BoxShape.circle,
                              ),
                              alignment: Alignment.center,
                              child: Text(
                                '+35',
                                style: TextStyle(
                                  fontSize: Responsive.getFont(context, 14),
                                  color: Colors.black,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                            SizedBox(height: 10), // 간격을 위한 SizedBox
                            // '자세히보기' 텍스트
                            Text(
                              '자세히보기',
                              style: TextStyle(
                                fontSize: Responsive.getFont(context, 12),
                                color: Colors.white,
                              ),
                              textAlign: TextAlign.center,
                            ),
                          ],
                        ),
                      ),

                  ],
                ),
              )
            ],
          ),
        ),
      ],
    );
  }
}
