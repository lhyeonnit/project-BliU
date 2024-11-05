import 'dart:async';

import 'package:BliU/data/banner_data.dart';
import 'package:BliU/screen/event_detail/event_detail_screen.dart';
import 'package:BliU/screen/main/page_screen/home/view_model/home_header_view_model.dart';
import 'package:BliU/utils/responsive.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';

class HomeHeaderChildWidget extends ConsumerStatefulWidget {
  const HomeHeaderChildWidget({super.key});

  @override
  ConsumerState<HomeHeaderChildWidget> createState() => HomeHeaderChildWidgetState();
}

class HomeHeaderChildWidgetState extends ConsumerState<HomeHeaderChildWidget> {
  final PageController _pageController = PageController();
  Timer? _timer;
  int _currentPage = 0;
  List<BannerData> _bannerList = [];

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _getBanner();
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
            ..._bannerList.map((banner) {
              return Stack(
                children: [
                  SizedBox(
                    width: double.infinity,
                    height: double.infinity,
                    child: GestureDetector(
                      onTap: () {
                        if (banner.btContentType == "Y") {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => EventDetailScreen(btIdx: banner.btIdx ?? 0),
                            ),
                          );
                        }
                      },
                      child: Image.network(
                        banner.btImg ?? "",
                        fit: BoxFit.fitWidth, // 이미지를 전체 화면에 맞추고 가로 여백 없이 설정
                        errorBuilder: (BuildContext context, Object exception, StackTrace? stackTrace) {
                          return const SizedBox();
                        }
                      ),
                    ),
                  ),
                  // // 상단 그림자
                  // Positioned(
                  //   top: 0,
                  //   left: 0,
                  //   right: 0,
                  //   height: 56, // 상단 그림자의 높이
                  //   child: Container(
                  //     decoration: BoxDecoration(
                  //       gradient: LinearGradient(
                  //         begin: Alignment.topCenter,
                  //         end: Alignment.bottomCenter,
                  //         colors: [
                  //           Colors.black.withOpacity(0.4), // 더 진한 그림자 색
                  //           Colors.transparent, // 투명색으로 변화
                  //         ],
                  //       ),
                  //     ),
                  //   ),
                  // ),
                  // Positioned(
                  //   bottom: 0,
                  //   left: 0,
                  //   right: 0,
                  //   height: 270, // 상단 그림자의 높이
                  //   child: Container(
                  //     decoration: BoxDecoration(
                  //       gradient: LinearGradient(
                  //         begin: Alignment.bottomCenter,
                  //         end: Alignment.topCenter,
                  //         colors: [
                  //           Colors.black.withOpacity(0.4), // 더 진한 그림자 색
                  //           Colors.transparent, // 투명색으로 변화
                  //         ],
                  //       ),
                  //     ),
                  //   ),
                  // ),
                ],
              );
            }),
          ],
        ),
        Positioned(
          top: MediaQuery.of(context).size.width * 1.3,
          left: Responsive.getWidth(context, 19),
          child: Center(
            child: SmoothPageIndicator(
              controller: _pageController,
              count: _bannerList.length,
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

  void _getBanner() async {
    final bannerListResponseDTO = await ref.read(homeHeaderViewModelProvider.notifier).getBanner();
    if (bannerListResponseDTO != null) {
      if (bannerListResponseDTO.result == true) {
        setState(() {
          _bannerList = bannerListResponseDTO.list ?? [];
        });

        _timer = Timer.periodic(const Duration(seconds: 3), (Timer timer) {
          if (_currentPage < _bannerList.length - 1) {
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
    }
  }
}
