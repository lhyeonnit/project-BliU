import 'package:BliU/data/review_data.dart';
import 'package:BliU/screen/mypage/viewmodel/my_review_view_model.dart';
import 'package:BliU/screen/product/component/detail/product_review_detail.dart';
import 'package:BliU/utils/responsive.dart';
import 'package:BliU/utils/shared_preferences_manager.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_svg/flutter_svg.dart';

class MyReviewScreen extends ConsumerStatefulWidget {

  const MyReviewScreen({super.key});

  @override
  MyReviewScreenState createState() => MyReviewScreenState();
}

class MyReviewScreenState extends ConsumerState<MyReviewScreen> {
  bool isListVisible = false;
  int reviewCount = 0;
  List<ReviewData> reviewList = [];

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _afterBuild(context);
    });
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
            color: const Color(0xFFF4F4F4), // 하단 구분선 색상
            height: 1.0, // 구분선의 두께 설정
            child: Container(
              height: 1.0, // 그림자 부분의 높이
              decoration: const BoxDecoration(
                boxShadow: [
                  BoxShadow(
                    color: Color(0xFFF4F4F4),
                    blurRadius: 6.0,
                    spreadRadius: 1.0,
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
      body:Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            margin: const EdgeInsets.only(top: 20, bottom: 15),
            child: Text(
              '작성한 리뷰 $reviewCount',
              style: TextStyle(
                fontFamily: 'Pretendard',
                fontSize: Responsive.getFont(context, 14)
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
            child: Stack(
              children: [
                Visibility(
                  visible: isListVisible,
                  child: ListView.builder(
                    itemCount: reviewList.length, // 리뷰 개수에 맞춰 설정
                    shrinkWrap: true,
                    itemBuilder: (context, index) {
                      final reviewData = reviewList[index];

                      return GestureDetector(
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => ProductReviewDetail(rtIdx: reviewData.rtIdx ?? 0),
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
                                    reviewData.rtImg ?? "",
                                    width: 90,
                                    height: 90,
                                    fit: BoxFit.cover,
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
                                      padding: const EdgeInsets.only(top: 4),
                                      child: Text(
                                        reviewData.ptName ?? "", // TODO
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
                                      reviewData.ctOptName ?? "", // TODO
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
                  )
                ),
                Visibility(
                  visible: !isListVisible,
                  child: Center(
                    child: Text(
                      "작성하신 리뷰가 없습니다.",
                      style: TextStyle(
                        fontFamily: 'Pretendard',
                        fontSize: Responsive.getFont(context, 16),
                        color: Colors.grey,
                        height: 1.2,
                      ),
                    ),
                  )
                )
              ],
            )
          ),
        ],
      ),
    );
  }

  void _afterBuild(BuildContext context) {
    _getList();
  }

  void _getList() async {
    // TODO 페이징 처리
    final pref = await SharedPreferencesManager.getInstance();
    final mtIdx = pref.getMtIdx();
    Map<String, dynamic> requestData = {
      'mt_idx': mtIdx,
      'pg' : 1,
    };

    final reviewInfoResponseDTO = await ref.read(myReviewViewModelProvider.notifier).getList(requestData);
    if (reviewInfoResponseDTO!= null) {
      if(reviewInfoResponseDTO.result == true) {
        setState(() {
          reviewCount = reviewInfoResponseDTO.count ?? 0;
          reviewList = reviewInfoResponseDTO.list ?? [];
          if (reviewList.isNotEmpty) {
            isListVisible = true;
          }
        });
      }
    }
  }
}
