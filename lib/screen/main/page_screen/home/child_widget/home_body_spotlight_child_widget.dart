import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';

class HomeBodySpotlightChildWidget extends ConsumerStatefulWidget {
  const HomeBodySpotlightChildWidget({super.key});

  @override
  ConsumerState<HomeBodySpotlightChildWidget> createState() => HomeBodySpotlightChildWidgetState();
}

class HomeBodySpotlightChildWidgetState extends ConsumerState<HomeBodySpotlightChildWidget> {
  final PageController _pageController = PageController();

  Timer? _timer;
  int _currentPage = 0;

  @override
  void dispose() {
    _timer?.cancel(); // 타이머 해제
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {

    return Consumer(
      builder: (context, ref, widget) {
        // TODO API 작업 필요

        final eList = ['', '', ''];

        if (eList.isNotEmpty) {
          if (_timer != null) {
            _currentPage = 0;
            _timer?.cancel();
          }
          _timer = Timer.periodic(const Duration(seconds: 3), (Timer timer) {
            if (_currentPage < eList.length - 1) {
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

        return Column(
          children: [
            SizedBox(
              height: 240,
              child: PageView.builder(
                controller: _pageController,
                itemCount: eList.length,
                itemBuilder: (context, index) {
                  return GestureDetector(
                    onTap: () {
                      // TODO 탭시 이동
                    },
                    child: SizedBox(
                      width: double.infinity,
                      height: 240,
                      child: ClipRRect(
                        borderRadius: const BorderRadius.all(Radius.circular(8)),
                        child: Image.asset(
                          'assets/images/onbImg01.png',
                          fit: BoxFit.cover,
                        ),
                      ),
                    ),
                  );
                },
              ),
            ),
            const SizedBox(height: 25),
            Center(
              child: SmoothPageIndicator(
                controller: _pageController,
                count: eList.length,
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
      },
    );
  }

}