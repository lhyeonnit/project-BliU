import 'package:BliU/screen/_component/non_data_screen.dart';
import 'package:BliU/screen/my_review/view_model/my_review_view_model.dart';
import 'package:BliU/screen/product_review_detail/product_review_detail_screen.dart';
import 'package:BliU/utils/responsive.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_svg/flutter_svg.dart';

class MyReviewScreen extends ConsumerStatefulWidget {

  const MyReviewScreen({super.key});

  @override
  ConsumerState<MyReviewScreen> createState() => MyReviewScreenState();
}

class MyReviewScreenState extends ConsumerState<MyReviewScreen> {
  final ScrollController _scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    _scrollController.addListener(_nextLoad);
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _afterBuild(context);
    });
  }

  @override
  void dispose() {
    super.dispose();
    _scrollController.removeListener(_nextLoad);
  }

  void _afterBuild(BuildContext context) {
    ref.read(myReviewViewModelProvider.notifier).listLoad();
  }

  void _nextLoad() async {
    if (_scrollController.position.extentAfter < 200) {
      ref.read(myReviewViewModelProvider.notifier).listNextLoad();
    }
  }

  @override
  Widget build(BuildContext context) {

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        scrolledUnderElevation: 0,
        backgroundColor: Colors.white,
        title: const Text('나의리뷰'),
        titleTextStyle: TextStyle(
          fontFamily: 'Pretendard',
          fontSize: Responsive.getFont(context, 18),
          fontWeight: FontWeight.w600,
          color: Colors.black,
          height: 1.2,
        ),
        leading: IconButton(
          icon: SvgPicture.asset("assets/images/store/ic_back.svg"),
          onPressed: () {
            Navigator.pop(context); // 뒤로가기 동작
          },
        ),
        titleSpacing: -1.0,
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(1.0), // 하단 구분선의 높이 설정
          child: Container(
            color: const Color(0x0D000000), // 하단 구분선 색상
            height: 1.0, // 구분선의 두께 설정
            child: Container(
              height: 1.0, // 그림자 부분의 높이
              decoration: const BoxDecoration(
                boxShadow: [
                  BoxShadow(
                    color: Color(0x0D000000),
                    blurRadius: 6.0,
                    spreadRadius: 0.1,
                    offset: Offset(0, 3),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
      body: SafeArea(
        child: Consumer(
          builder: (context, ref, widget) {
            final model = ref.watch(myReviewViewModelProvider);
            final reviewCount = model.reviewCount;
            final isListVisible = model.isListVisible;
            final reviewList = model.reviewList;

            return Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  margin: const EdgeInsets.only(top: 20, bottom: 15),
                  child: Text(
                    '작성한 리뷰 $reviewCount',
                    style: TextStyle(
                      fontFamily: 'Pretendard',
                      fontSize: Responsive.getFont(context, 14),
                    ),
                  ),
                ),
                Container(
                  margin: const EdgeInsets.only(bottom: 10),
                  child: const Divider(
                    height: 1,
                    color: Color(0xFFEEEEEE),
                  ),
                ),
                Expanded(
                  flex: isListVisible ? 1 : 0,
                  child: Visibility(
                    visible: isListVisible,
                    child: ListView.builder(
                      controller: _scrollController,
                      itemCount: reviewList.length, // 리뷰 개수에 맞춰 설정
                      shrinkWrap: true,
                      itemBuilder: (context, index) {
                        final reviewData = reviewList[index];

                        return GestureDetector(
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => ProductReviewDetailScreen(rtIdx: reviewData.rtIdx ?? 0),
                              ),
                            );
                          },
                          child: Padding(
                            padding: const EdgeInsets.symmetric(vertical: 10.0, horizontal: 16),
                            child: Row(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                // 상품 이미지
                                Padding(
                                  padding: const EdgeInsets.only(right: 20.0),
                                  child: ClipRRect(
                                    borderRadius: BorderRadius.circular(6.0),
                                    child: Image.network(
                                      reviewData.ptImg ?? "",
                                      width: 90,
                                      height: 90,
                                      fit: BoxFit.cover,
                                      errorBuilder: (BuildContext context, Object exception, StackTrace? stackTrace) {
                                        return const SizedBox();
                                      },
                                    ),
                                  ),
                                ),
                                // 상품 정보 텍스트
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        reviewData.stName ?? "",
                                        style: TextStyle(
                                          fontFamily: 'Pretendard',
                                          fontSize: Responsive.getFont(context, 12),
                                          color: const Color(0xFF7B7B7B),
                                          height: 1.2,
                                        ),
                                      ),
                                      Padding(
                                        padding: const EdgeInsets.only(top: 4, bottom: 10),
                                        child: Text(
                                          reviewData.ptName ?? "",
                                          style: TextStyle(
                                            fontFamily: 'Pretendard',
                                            fontSize: Responsive.getFont(context, 14),
                                            height: 1.2,
                                          ),
                                          overflow: TextOverflow.ellipsis,
                                          maxLines: 2,
                                        ),
                                      ),
                                      Text(
                                        reviewData.ctOptValue ?? "",
                                        style: TextStyle(
                                          fontFamily: 'Pretendard',
                                          fontSize: Responsive.getFont(context, 13),
                                          color: const Color(0xFF7B7B7B),
                                          height: 1.2,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          ),
                        );
                      },
                    ),
                  ),
                ),
                Visibility(
                  visible: !isListVisible,
                  child: const NonDataScreen(text: '작성하신 리뷰가 없습니다.'),
                ),
              ],
            );
          },
        ),
      ),
    );
  }
}
