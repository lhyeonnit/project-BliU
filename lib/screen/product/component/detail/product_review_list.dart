import 'package:BliU/data/review_data.dart';
import 'package:BliU/screen/product/viewmodel/product_review_list_view_model.dart';
import 'package:BliU/utils/responsive.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'product_review_detail.dart';
import 'report_page.dart';

class ProductReview extends ConsumerStatefulWidget {
  final int? ptIdx;
  const ProductReview({super.key, required this.ptIdx});

  @override
  _ProductReviewState createState() => _ProductReviewState();
}

class _ProductReviewState extends ConsumerState<ProductReview> {
  late int ptIdx;

  // TODO 페이징 처리 필요
  int currentPage = 1;
  int totalPages = 10;

  @override
  void initState() {
    super.initState();
    ptIdx = widget.ptIdx ?? 0;
    _getList(true);
  }
  Widget _ratingTotalStars(double rating) {
    int fullStars = rating.floor(); // 꽉 찬 별의 개수
    bool hasHalfStar = (rating - fullStars) >= 0.5; // 반 개짜리 별이 있는지 확인
    int emptyStars = 5 - fullStars - (hasHalfStar ? 1 : 0); // 빈 별의 개수

    return Row(
      children: [
        // 꽉 찬 별을 표시
        for (int i = 0; i < fullStars; i++)
          Icon(Icons.star, color: Color(0xFFFF6191), size: 26,),

        if (hasHalfStar)
          _buildHalfTotalStar(rating),

        // 빈 별을 표시
        for (int i = 0; i < emptyStars; i++)
          Icon(Icons.star, color: Color(0xFFEEEEEE), size: 26,),
      ],
    );
  }
  Widget _ratingStars(double rating) {
    int fullStars = rating.floor(); // 꽉 찬 별의 개수
    bool hasHalfStar = (rating - fullStars) >= 0.5; // 반 개짜리 별이 있는지 확인
    int emptyStars = 5 - fullStars - (hasHalfStar ? 1 : 0); // 빈 별의 개수

    return Row(
      children: [
        // 꽉 찬 별을 표시
        for (int i = 0; i < fullStars; i++)
          Icon(Icons.star, color: Color(0xFFFF6191), size: 16),

        if (hasHalfStar)
          _buildHalfStar(rating),

        // 빈 별을 표시
        for (int i = 0; i < emptyStars; i++)
          Icon(Icons.star, color: Color(0xFFEEEEEE), size: 16,),
      ],
    );
  }
  @override
  Widget build(BuildContext context) {
    return Consumer(
      builder: (context, ref, widget) {
        final model = ref.watch(productReviewListModelProvider);
        List<ReviewData> list = model?.reviewInfoResponseDTO?.list ?? [];
        final starAvg = model?.reviewInfoResponseDTO?.reviewInfo?.starAvg ?? 0.0;
        final reviewCount = model?.reviewInfoResponseDTO?.reviewInfo?.reviewCount ?? 0;

        return Container(
          margin: EdgeInsets.only(bottom: 80),
          child: ListView(
            children: [
              // 평점과 총 리뷰 수 섹션
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 16.0),
                margin: EdgeInsets.only(top: 30),
                child: Row(
                  children: [
                    Text(
                      '$starAvg',
                      style: TextStyle(
                        fontSize: Responsive.getFont(context, 20),
                        fontWeight: FontWeight.bold,
                        color: Colors.black,
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 4.0),
                      child: Text(
                        '/5.0',
                        style: TextStyle(
                          fontSize: Responsive.getFont(context, 20),
                          fontWeight: FontWeight.bold,
                          color: Color(0xFFA4A4A4),
                        ),
                      ),
                    ),
                    const Spacer(),
                    Text(
                      '$reviewCount명의 리뷰',
                      style: TextStyle(
                        fontWeight: FontWeight.w400,
                        fontSize: Responsive.getFont(context, 14),
                      ),
                    ),
                  ],
                ),
              ),
               // TODO 실제 별점 값 넣기
               Container(
                  margin: EdgeInsets.symmetric(vertical: 10, horizontal: 16),
                  child: _ratingTotalStars(4.5),
                ),
              Container(
                margin: EdgeInsets.only(top: 10, bottom: 20),
                height: 10,
                width: double.infinity,
                color: Color(0xFFF5F9F9),
              ),

              // 리뷰 리스트
              ...List.generate(list.length, (index) {
                // TODO 이미지 파싱 작업 필요
                List<String> reviewImages = [
                  'assets/images/home/exhi.png',
                  'assets/images/home/exhi.png',
                  'assets/images/home/exhi.png',
                  'assets/images/home/exhi.png',
                ];
                final reviewData = list[index];

                return GestureDetector(
                    onTap: () {
                      // 각 리뷰를 클릭했을 때 리뷰 상세 페이지로 이동
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => const ProductReviewDetail(),
                        ),
                      );
                    },
                    child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Container(
                            margin: EdgeInsets.symmetric(horizontal: 16),
                            child: Row(
                              children: [
                                Text(
                                  '${reviewData.mtId.toString().substring(0, 2)}**********',
                                  style: TextStyle(
                                      color: Color(0xFF7B7B7B),
                                      fontSize: Responsive.getFont(context, 12)),
                                ),
                                Container(
                                  margin: EdgeInsets.symmetric(horizontal: 10),
                                  child: Text(
                                    reviewData.rtWdate ?? "",
                                    style: TextStyle(
                                        color: Color(0xFF7B7B7B),
                                        fontSize: Responsive.getFont(context, 12)),
                                  ),
                                ),
                              ],
                            ),
                          ),
                          // TODO 실제 별점 값 넣기
                          Container(
                            margin: EdgeInsets.symmetric(vertical: 10, horizontal: 16),
                            child: _ratingStars(4.5),
                          ),
                          // 리뷰 텍스트 두 줄로 제한하고 넘칠 경우 생략 부호 표시
                          Container(
                            margin: EdgeInsets.symmetric(horizontal: 16),
                            child: Text(
                              reviewData.rtContent ?? "",
                              style: TextStyle(
                                fontSize: Responsive.getFont(context, 14),
                                color: Colors.black
                              ),
                              maxLines: 2,
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                          Container(
                            margin: EdgeInsets.only(top: 10, bottom: 15, left: 16),
                            child: GestureDetector(
                              onTap: () {
                                // TODO 신고 버튼 클릭시 동작
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(builder: (context) => const ReportPage()),
                                );
                              },
                              child: Text(
                                '신고',
                                style: TextStyle(
                                  fontSize: Responsive.getFont(context, 12),
                                  color: Color(0xFF7B7B7B),
                                ),
                              ),
                            ),
                          ),
                          // 사진 목록 - 가로 사이즈에 맞게 배치
                          Container(
                            margin: EdgeInsets.symmetric(horizontal: 16),
                            child: Row(
                              children: reviewImages.map((imagePath) {
                                return Expanded(
                                  child: Padding(
                                    padding: const EdgeInsets.symmetric(horizontal: 4.0),
                                    child: ClipRRect(
                                      borderRadius: BorderRadius.circular(8.0),
                                      child: Image.asset(
                                        imagePath,
                                        height: 90,
                                        fit: BoxFit.cover,
                                      ),
                                    ),
                                  ),
                                );
                              }).toList(),
                            ),
                          ),

                          Container(
                              margin: EdgeInsets.symmetric(vertical: 20),
                              child: Divider(thickness: 1, color: Color(0xFFEEEEEE))),
                        ],
                      ),
                  );
              }),

              // 페이지네이션
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  IconButton(
                    icon: SvgPicture.asset('assets/images/product/pager_prev.svg'),
                    onPressed: currentPage > 1
                        ? () {
                      setState(() {
                        currentPage--;
                      });
                    }
                        : null,
                  ),
                  Container(
                    margin: EdgeInsets.symmetric(horizontal: 20),
                    child: Row(
                      children: [
                        Text(
                          '${currentPage.toString().padLeft(2, '0')}',
                          style: TextStyle(
                            fontSize: Responsive.getFont(context, 16),
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        Text(
                          ' / $totalPages',
                          style: TextStyle(
                              fontSize: Responsive.getFont(context, 16),
                              color: Color(0xFFCCCCCC),
                              fontWeight: FontWeight.w600),
                        ),
                      ],
                    ),
                  ),
                  IconButton(
                    icon: SvgPicture.asset('assets/images/product/pager_next.svg'),
                    onPressed: currentPage < totalPages
                        ? () {
                      setState(() {
                        currentPage++;
                      });
                    }
                        : null,
                  ),
                ],
              ),
            ],
          ),
        );
      }
    );
  }

  void _getList(bool isNew) async {
    // TODO 페이징 필요
    Map<String, dynamic> requestData = {
      'pt_idx' : ptIdx,
      'pg' : 1,
    };

    ref.read(productReviewListModelProvider.notifier).getList(requestData);
  }
}
Widget _buildHalfTotalStar(double rating) {
  return Stack(
    children: [
      Icon(
        Icons.star,
        color: Color(0xFFEEEEEE), // 빈 별 색상
        size: 26,
      ),
      ClipRect(
        clipper: HalfClipper(),
        child: Icon(
          Icons.star,
          color: Color(0xFFFF6191), // 채워진 별 색상
          size: 26,
        ),
      ),
    ],
  );
}Widget _buildHalfStar(double rating) {
  return Stack(
    children: [
      Icon(
        Icons.star,
        color: Color(0xFFEEEEEE), // 빈 별 색상
        size: 16,
      ),
      ClipRect(
        clipper: HalfClipper(),
        child: Icon(
          Icons.star,
          color: Color(0xFFFF6191), // 채워진 별 색상
          size: 16,
        ),
      ),
    ],
  );
}

class HalfClipper extends CustomClipper<Rect> {
  @override
  Rect getClip(Size size) {
    return Rect.fromLTRB(0, 0, size.width / 2, size.height); // 별의 절반을 잘라냄
  }

  @override
  bool shouldReclip(CustomClipper<Rect> oldClipper) {
    return false;
  }
}