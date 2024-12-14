import 'dart:async';

import 'package:BliU/screen/event_detail/event_detail_screen.dart';
import 'package:BliU/screen/main/page_screen/home/view_model/home_header_view_model.dart';
import 'package:BliU/utils/responsive.dart';
import 'package:BliU/utils/utils.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_svg/flutter_svg.dart';
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

  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    _timer?.cancel();
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Consumer(
      builder: (context, ref, widget) {
        final model = ref.watch(homeHeaderViewModelProvider);
        final bannerList = model.bannerListResponseDTO?.list ?? [];
        if (bannerList.isNotEmpty) {
          if (_timer != null) {
            _currentPage = 0;
            _timer?.cancel();
          }

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
                        height: Utils.getInstance().isWeb() ? 450 * 1.4 : double.infinity,
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
                          child: CachedNetworkImage(
                            imageUrl: banner.btImg ?? "",
                            width: double.infinity,
                            height: double.infinity,
                            fit: BoxFit.fitWidth, // 이미지를 전체 화면에 맞추고 가로 여백 없이 설정
                            placeholder: (context, url) {
                              return const Center(
                                child: CircularProgressIndicator(),
                              );
                            },
                            errorWidget: (context, url, error) {
                              return SvgPicture.asset(
                                'assets/images/no_imge.svg',
                                width: double.infinity,
                                fit: BoxFit.fitWidth,
                              );
                            },
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
      },
    );
  }
}
