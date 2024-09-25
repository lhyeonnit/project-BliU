import 'dart:async';
import 'package:BliU/data/banner_data.dart';
import 'package:BliU/screen/home/viewmodel/home_header_view_model.dart';
import 'package:BliU/screen/mypage/component/bottom/component/event_detail.dart';
import 'package:BliU/utils/responsive.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';

class HomeHeader extends ConsumerStatefulWidget {
  const HomeHeader({super.key});

  @override
  _HomeHeaderState createState() => _HomeHeaderState();
}

class _HomeHeaderState extends ConsumerState<HomeHeader> {
  final PageController _pageController = PageController();
  Timer? _timer;
  int _currentPage = 0;
  List<BannerData> bannerList = [];

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
            ...bannerList.map((banner) {
              return Stack(
                children: [
                  SizedBox(
                    width: double.infinity,
                    height: Responsive.getHeight(context, 625),
                    child: GestureDetector(
                      onTap: () {
                        if (banner.btContentType == "Y") {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => EventDetail(btIdx: banner.btIdx ?? 0),
                            ),
                          );
                        }
                      },
                      child: Image.network(
                        banner.btImg ?? "",
                        fit: BoxFit.cover, // 이미지를 전체 화면에 맞추고 가로 여백 없이 설정
                      ),
                    ),
                  ),
                  // Positioned(
                  //   top: Responsive.getHeight(context, 409),
                  //   left: Responsive.getWidth(context, 16),
                  //   child: Column(
                  //     crossAxisAlignment: CrossAxisAlignment.start,
                  //     children: [
                  //       Text(
                  //         title,
                  //         style: TextStyle(
                  //           fontSize: Responsive.getFont(context, 30),
                  //           fontWeight: FontWeight.bold,
                  //           color: Colors.white,
                  //         ),
                  //       ),
                  //       Text(
                  //         subtitle,
                  //         style: TextStyle(
                  //           fontSize: Responsive.getFont(context, 30),
                  //           fontWeight: FontWeight.bold,
                  //           color: Colors.white,
                  //         ),
                  //       ),
                  //       SizedBox(height: Responsive.getHeight(context, 13.82)),
                  //       Text(
                  //         description,
                  //         style: TextStyle(
                  //           fontSize: Responsive.getFont(context, 16),
                  //           color: Colors.white,
                  //         ),
                  //       ),
                  //     ],
                  //   ),
                  // ),
                ],
              );
            }),
          ],
        ),
        Positioned(
          top: Responsive.getHeight(context, 536),
          left: Responsive.getWidth(context, 19),
          child: Center(
            child: SmoothPageIndicator(
              controller: _pageController,
              count: bannerList.length,
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
          bannerList = bannerListResponseDTO.list ?? [];
        });

        _timer = Timer.periodic(const Duration(seconds: 3), (Timer timer) {
          if (_currentPage < bannerList.length - 1) {
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
