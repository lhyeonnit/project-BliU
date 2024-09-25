import 'package:BliU/screen/mypage/component/top/component/my_review_detail.dart';
import 'package:BliU/screen/mypage/component/top/review_write_screen.dart';
import 'package:BliU/utils/responsive.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

class MyReviewScreen extends StatelessWidget {
  final Review? review;

  const MyReviewScreen({
    super.key,
    this.review,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        scrolledUnderElevation: 0,
        backgroundColor: Colors.white,
        title: const Text('나의리뷰'),
        titleTextStyle: TextStyle( fontFamily: 'Pretendard',
          fontSize: Responsive.getFont(context, 18),
          fontWeight: FontWeight.w600,
          color: Colors.black,
        ),
        leading: IconButton(
          icon: SvgPicture.asset("assets/images/store/ic_back.svg"),
          onPressed: () {
            Navigator.pop(context); // 뒤로가기 동작
          },
        ),
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
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            padding: EdgeInsets.symmetric(horizontal: 16),
            margin: EdgeInsets.only(top: 20, bottom: 15),
            child: Text(
              '작성한 리뷰 0',
              style: TextStyle( fontFamily: 'Pretendard',fontSize: Responsive.getFont(context, 14)),
            ),
          ),
          Container(
            margin: EdgeInsets.only(bottom: 10),
            child: Divider(
              height: 1,
              color: Color(0xFFEEEEEE),
            ),
          ),
          review != null
              ? Expanded(
            child: ListView.builder(
              itemCount: 1, // 리뷰 개수에 맞춰 설정
              shrinkWrap: true,
              itemBuilder: (context, index) {
                return GestureDetector(
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => MyReviewDetail(review: review!,),
                      ),
                    );
                  },
                  child: Padding(
                    padding:
                    EdgeInsets.symmetric(vertical: 10.0, horizontal: 16),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // 상품 이미지
                        Padding(
                          padding: const EdgeInsets.only(right: 20.0),
                          child: ClipRRect(
                            borderRadius: BorderRadius.circular(6.0),
                            child: Image.asset(
                              review!.image,
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
                                review!.store,
                                style: TextStyle( fontFamily: 'Pretendard',
                                    fontSize: Responsive.getFont(context, 12),
                                    color: Color(0xFF7B7B7B)),
                              ),
                              Padding(
                                padding: EdgeInsets.only(top: 4),
                                child: Text(
                                  review!.name,
                                  style: TextStyle( fontFamily: 'Pretendard',
                                    fontSize: Responsive.getFont(context, 14),
                                  ),
                                  overflow: TextOverflow.ellipsis,
                                  maxLines: 2,
                                ),
                              ),
                              Text(
                                review!.size,
                                style: TextStyle( fontFamily: 'Pretendard',
                                  fontSize: Responsive.getFont(context, 13),
                                  color: Color(0xFF7B7B7B),
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
          )
              : Expanded(
            child: Center(
              child: Text(
                "작성하신 리뷰가 없습니다.",
                style: TextStyle( fontFamily: 'Pretendard',
                  fontSize: Responsive.getFont(context, 16),
                  color: Colors.grey,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
