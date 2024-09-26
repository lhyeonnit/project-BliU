import 'dart:async';
import 'package:BliU/data/exhibition_data.dart';
import 'package:BliU/screen/home/exhibition_screen.dart';
import 'package:BliU/screen/home/viewmodel/home_body_exhibition_view_model.dart';
import 'package:BliU/utils/responsive.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';

class HomeBodyExhibition extends ConsumerStatefulWidget {
  const HomeBodyExhibition({super.key});

  @override
  HomeBodyExhibitionState createState() => HomeBodyExhibitionState();
}

class HomeBodyExhibitionState extends ConsumerState<HomeBodyExhibition> {
  final PageController _pageController = PageController();
  List<ExhibitionData> exhibitionList = [];

  Timer? _timer;
  int _currentPage = 0;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _afterBuild(context);
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
        SizedBox(
          width: Responsive.getWidth(context, 380),
          height: 420,
          child: PageView.builder(
            controller: _pageController,
            itemCount: exhibitionList.length,
            itemBuilder: (context, index) {
              final exhibitionData = exhibitionList[index];
              return buildPage(exhibitionData);
            },
          ),
        ),
        const SizedBox(height: 25),
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
  }

  void _afterBuild(BuildContext context) {
    _getList();
  }

  void _getList() async {
    final exhibitionListResponseDTO = await ref.read(homeBodyExhibitionViewModelProvider.notifier).getList();
    if (exhibitionListResponseDTO != null) {
      if (exhibitionListResponseDTO.result == true) {
        setState(() {
          exhibitionList = exhibitionListResponseDTO.list ?? [];
        });

        // 타이머를 이용한 페이지 자동 넘기기
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
    }
  }

  Widget buildPage(ExhibitionData exhibitionData) {
    return Stack(
      children: [
        SizedBox(
          width: Responsive.getWidth(context, 380),
          height: 420,
          child: ClipRRect(
            borderRadius: const BorderRadius.all(Radius.circular(8)),
            child: Image.network(
              exhibitionData.etBanner ?? "",
              fit: BoxFit.cover, // 이미지를 부모 위젯에 맞게 설정
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
                ),
              ),
              SizedBox(height: Responsive.getHeight(context, 10)),
              Text(
                exhibitionData.etSubTitle ?? "",
                style: TextStyle(
                  fontFamily: 'Pretendard',
                  fontSize: Responsive.getFont(context, 14),
                  color: Colors.white,
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
                          child: ClipRRect(
                            borderRadius: BorderRadius.circular(5.0),
                            child: Image.network(
                              exhibitionData.ptImg?[0] ?? "",
                              height: Responsive.getHeight(context, 84),
                              fit: BoxFit
                                  .cover, // 이 부분도 추가하면 이미지가 컨테이너를 꽉 채우게 됩니다.
                            ),
                          ),
                        ),
                        const SizedBox(width: 10),
                        Flexible(
                          flex: 1,
                          child: ClipRRect(
                            borderRadius: BorderRadius.circular(5.0),
                            child: Image.network(
                              exhibitionData.ptImg?[1] ?? "",
                              height: Responsive.getHeight(context, 84),
                              fit: BoxFit
                                  .cover, // 이 부분도 추가하면 이미지가 컨테이너를 꽉 채우게 됩니다.
                            ),
                          ),
                        ),
                        const SizedBox(width: 10),
                        Flexible(
                          flex: 1,
                          child: ClipRRect(
                            borderRadius: BorderRadius.circular(5.0),
                            child: Image.network(
                              exhibitionData.ptImg?[2] ?? "",
                              height: Responsive.getHeight(context, 84),
                              fit: BoxFit
                                  .cover, // 이 부분도 추가하면 이미지가 컨테이너를 꽉 채우게 됩니다.
                            ),
                          ),
                        ),
                      ],
                    )),
                    Container(
                      margin: const EdgeInsets.fromLTRB(10, 0, 0, 0),
                      child: TextButton(
                        style: TextButton.styleFrom(
                          padding: EdgeInsets.zero, // 여백 없앰
                          minimumSize: Size.zero, // 최소 사이즈를 0으로 설정하여 여백 제거
                        ),
                        onPressed: () {
                          print("exhibitionData.etIdx ?? 0 ${exhibitionData.etIdx ?? 0}");

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
                                '+${exhibitionData.etProductCount}',
                                style: TextStyle(
                                  fontFamily: 'Pretendard',
                                  fontSize: Responsive.getFont(context, 14),
                                  color: Colors.black,
                                  fontWeight: FontWeight.bold,
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
    );
  }
}
