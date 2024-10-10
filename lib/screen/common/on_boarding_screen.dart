import 'package:BliU/screen/main_screen.dart';
import 'package:BliU/utils/responsive.dart';
import 'package:flutter/material.dart';
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
      body: WillPopScope(
        onWillPop: _onWillPop,
        child: Stack(
          children: <Widget>[
            SafeArea(
              child: Column(
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
                  SizedBox(
                    height: Responsive.getHeight(context, 150),

                    child: Column(
                      children: [
                        Expanded(
                          child: Container(
                            color: Colors.white,
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
                        ),
                      ],
                    ),
                  )
                ],
              ),
            ),
            Positioned(
              bottom: 0,
              right: 0,
              child: Container(
                color: Colors.white,
                alignment: Alignment.topRight,
                height: Responsive.getHeight(context, 58),
                child: SizedBox(
                  child: GestureDetector(
                    onTap: () {
                      Navigator.pushReplacement(
                        context,
                        MaterialPageRoute(
                          builder: (context) => const MainScreen(),
                        ),
                      );
                    },
                    child: Container(
                      height: Responsive.getHeight(context, 38),
                      margin: const EdgeInsets.only(right: 16,),
                      padding: const EdgeInsets.symmetric(horizontal: 20),
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
                        style: TextStyle(
                          fontFamily: 'Pretendard',
                          fontSize: Responsive.getFont(context, 14),
                          height: 1.2,
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Future<bool> _onWillPop() async {
    DateTime currentTime = DateTime.now();

    bool backButtonHasNotBeenPressedOrSnackBarHasBeenClosed =
        _backButtonPressedTime == null ||
            currentTime.difference(_backButtonPressedTime!) >
                const Duration(seconds: 3);

    if (backButtonHasNotBeenPressedOrSnackBarHasBeenClosed) {
      _backButtonPressedTime = currentTime;
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text("한번 더 뒤로가기를 누르면 종료됩니다."),
          duration: Duration(seconds: 3),
        ),
      );
      return Future.value(false);
    }

    return Future.value(true);
  }
}
