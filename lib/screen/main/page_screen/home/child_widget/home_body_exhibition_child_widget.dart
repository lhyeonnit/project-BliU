import 'dart:async';

import 'package:BliU/data/exhibition_data.dart';
import 'package:BliU/screen/exhibition/exhibition_screen.dart';
import 'package:BliU/screen/main/page_screen/home/view_model/home_body_exhibition_view_model.dart';
import 'package:BliU/utils/responsive.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';

class HomeBodyExhibitionChildWidget extends ConsumerStatefulWidget {
  const HomeBodyExhibitionChildWidget({super.key});

  @override
  ConsumerState<HomeBodyExhibitionChildWidget> createState() => HomeBodyExhibitionChildWidgetState();
}

class HomeBodyExhibitionChildWidgetState extends ConsumerState<HomeBodyExhibitionChildWidget> {
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
    //TODO API작업 필요
    return Consumer(
      builder: (context, ref, widget) {
        final model = ref.watch(homeBodyExhibitionViewModelProvider);
        final exhibitionList = model.exhibitionListResponseDTO?.list ?? [];

        if (exhibitionList.isNotEmpty) {
          if (_timer != null) {
            _currentPage = 0;
            _timer?.cancel();
          }
          _timer = Timer.periodic(const Duration(seconds: 3), (Timer timer) {
            if (_currentPage < exhibitionList.length - 1) {
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
            AspectRatio(
              aspectRatio: 38/42,
              child: Container(
                //width: Responsive.getWidth(context, 380),
                margin: const EdgeInsets.only(left: 16, right: 16),
                child: PageView.builder(
                  controller: _pageController,
                  itemCount: exhibitionList.length,
                  itemBuilder: (context, index) {
                    final exhibitionData = exhibitionList[index];
                    return buildPage(exhibitionData);
                  },
                ),
              ),
            ),
            const SizedBox(height: 25),
            if (exhibitionList.isNotEmpty)
              Center(
                child: SmoothPageIndicator(
                  controller: _pageController,
                  count: exhibitionList.length,
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

  Widget buildPage(ExhibitionData exhibitionData) {
    var ptImg0 = "";
    var ptImg1 = "";
    var ptImg2 = "";

    for (int i = 0; i < (exhibitionData.ptImg?.length ?? 0); i++) {
      final ptImg = exhibitionData.ptImg?[i];
      if(i==0) {
        ptImg0 = ptImg ?? "";
      } else if (i==1) {
        ptImg1 = ptImg ?? "";
      } else if (i==2) {
        ptImg2 = ptImg ?? "";
      }
    }

    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => ExhibitionScreen(etIdx: exhibitionData.etIdx ?? 0,),
          ),
        );
      },
      child: Stack(
        children: [
          SizedBox(
            width: double.infinity,
            height: double.infinity,
            child: ClipRRect(
              borderRadius: const BorderRadius.all(Radius.circular(8)),
              child: CachedNetworkImage(
                imageUrl: exhibitionData.etBanner ?? "",
                width: double.infinity,
                height: double.infinity,
                fit: BoxFit.cover,
                placeholder: (context, url) {
                  return const Center(
                    child: CircularProgressIndicator(),
                  );
                },
                errorWidget: (context, url, error) {
                  return SvgPicture.asset(
                    'assets/images/no_imge.svg',
                    width: double.infinity,
                    height: double.infinity,
                    fit: BoxFit.fitWidth,
                  );
                },
              ),
            ),
          ),
          Positioned.fill(
            child: Container(
              decoration: BoxDecoration(
                borderRadius: const BorderRadius.only(
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
                  exhibitionData.etTitle ?? "",
                  style: TextStyle(
                    fontFamily: 'Pretendard',
                    fontSize: Responsive.getFont(context, 22),
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                    height: 1.2,
                  ),
                ),
                SizedBox(height: Responsive.getHeight(context, 10)),
                SizedBox(
                  width: Responsive.getWidth(context, 340),
                  child: Text(
                    exhibitionData.etSubTitle ?? "",
                    overflow: TextOverflow.ellipsis,
                    maxLines: 2,
                    style: TextStyle(
                      fontFamily: 'Pretendard',
                      fontSize: Responsive.getFont(context, 14),
                      color: Colors.white,
                      height: 1.2,
                    ),
                  ),
                ),
                SizedBox(height: Responsive.getHeight(context, 15)),
                SizedBox(
                  width: Responsive.getWidth(context, 340),
                  child: Row(
                    children: [
                      Expanded(
                        child: Row(
                          children: [
                            Flexible(
                              flex: 1,
                              child: Visibility(
                                visible: ptImg0.isNotEmpty,
                                child: ClipRRect(
                                  borderRadius: BorderRadius.circular(5.0),
                                  child: AspectRatio(
                                    aspectRatio: 1,
                                    child: CachedNetworkImage(
                                      imageUrl: ptImg0,
                                      width: double.infinity,
                                      height: Responsive.getHeight(context, 84),
                                      fit: BoxFit.cover, // 이 부분도 추가하면 이미지가 컨테이너를 꽉 채우게 됩니다.
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
                              ),
                            ),
                            const SizedBox(width: 10),
                            Flexible(
                              flex: 1,
                              child: Visibility(
                                visible: ptImg1.isNotEmpty,
                                child: ClipRRect(
                                  borderRadius: BorderRadius.circular(5.0),
                                  child: AspectRatio(
                                    aspectRatio: 1,
                                    child: CachedNetworkImage(
                                      imageUrl: ptImg1,
                                      width: double.infinity,
                                      height: Responsive.getHeight(context, 84),
                                      fit: BoxFit.cover, // 이 부분도 추가하면 이미지가 컨테이너를 꽉 채우게 됩니다.
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
                              ),
                            ),
                            const SizedBox(width: 10),
                            Flexible(
                              flex: 1,
                              child: Visibility(
                                visible: ptImg2.isNotEmpty,
                                child: ClipRRect(
                                  borderRadius: BorderRadius.circular(5.0),
                                  child: AspectRatio(
                                    aspectRatio: 1,
                                    child: CachedNetworkImage(
                                      imageUrl: ptImg2,
                                      width: double.infinity,
                                      height: Responsive.getHeight(context, 84),
                                      fit: BoxFit.cover, // 이 부분도 추가하면 이미지가 컨테이너를 꽉 채우게 됩니다.
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
                              ),
                            ),
                          ],
                        ),
                      ),
                      Container(
                        margin: const EdgeInsets.fromLTRB(10, 0, 0, 0),
                        child: TextButton(
                          style: TextButton.styleFrom(
                            padding: EdgeInsets.zero, // 여백 없앰
                            minimumSize: Size.zero, // 최소 사이즈를 0으로 설정하여 여백 제거
                          ),
                          onPressed: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => ExhibitionScreen(etIdx: exhibitionData.etIdx ?? 0,),
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
                                decoration: const BoxDecoration(
                                  color: Colors.white,
                                  shape: BoxShape.circle,
                                ),
                                alignment: Alignment.center,
                                child: Text(
                                  '+${exhibitionData.etProductCount ?? 0}',
                                  style: TextStyle(
                                    fontFamily: 'Pretendard',
                                    fontSize: Responsive.getFont(context, 14),
                                    color: Colors.black,
                                    fontWeight: FontWeight.bold,
                                    height: 1.2,
                                  ),
                                ),
                              ),
                              const SizedBox(height: 10), // 간격을 위한 SizedBox
                              // '자세히보기' 텍스트
                              Text(
                                '자세히보기',
                                style: TextStyle(
                                  fontFamily: 'Pretendard',
                                  fontSize: Responsive.getFont(context, 12),
                                  color: Colors.white,
                                  height: 1.2,
                                ),
                                textAlign: TextAlign.center,
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                )
              ],
            ),
          ),
        ],
      ),
    );
  }
}
