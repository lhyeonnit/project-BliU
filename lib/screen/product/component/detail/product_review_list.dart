import 'package:BliU/data/review_data.dart';
import 'package:BliU/screen/product/component/detail/product_review_detail.dart';
import 'package:BliU/screen/product/component/detail/report_page.dart';
import 'package:BliU/screen/product/viewmodel/product_review_list_view_model.dart';
import 'package:BliU/utils/responsive.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_svg/flutter_svg.dart';

class ProductReview extends ConsumerStatefulWidget {
  final int? ptIdx;

  const ProductReview({super.key, required this.ptIdx});

  @override
  ConsumerState<ProductReview> createState() => _ProductReviewState();
}

class _ProductReviewState extends ConsumerState<ProductReview> {
  late int ptIdx;

  int currentPage = 1;
  int totalPages = 1;

  @override
  void initState() {
    super.initState();
    ptIdx = widget.ptIdx ?? 0;
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _afterBuild(context);
    });
  }

  Widget _ratingTotalStars(double rating) {
    int fullStars = rating.floor(); // 꽉 찬 별의 개수
    bool hasHalfStar = (rating - fullStars) >= 0.5; // 반 개짜리 별이 있는지 확인
    int emptyStars = 5 - fullStars - (hasHalfStar ? 1 : 0); // 빈 별의 개수

    return Row(
      children: [
        // 꽉 찬 별을 표시
        for (int i = 0; i < fullStars; i++)
          const Icon(
            Icons.star,
            color: Color(0xFFFF6191),
            size: 26,
          ),

        if (hasHalfStar) _buildHalfTotalStar(rating),

        // 빈 별을 표시
        for (int i = 0; i < emptyStars; i++)
          const Icon(
            Icons.star,
            color: Color(0xFFEEEEEE),
            size: 26,
          ),
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
          const Icon(
            Icons.star,
            color: Color(0xFFFF6191),
            size: 16
          ),

        if (hasHalfStar) _buildHalfStar(rating),

        // 빈 별을 표시
        for (int i = 0; i < emptyStars; i++)
          const Icon(
            Icons.star,
            color: Color(0xFFEEEEEE),
            size: 16,
          ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Consumer(builder: (context, ref, widget) {
      final model = ref.watch(productReviewListModelProvider);
      List<ReviewData> list = model?.reviewInfoResponseDTO?.list ?? [];
      final starAvg = model?.reviewInfoResponseDTO?.reviewInfo?.startAvg ?? "0.0";
      final reviewCount = model?.reviewInfoResponseDTO?.reviewInfo?.reviewCount ?? 0;

      if (reviewCount > 0) {
        totalPages = (reviewCount~/10);
        if ((reviewCount%10) > 0) {
          totalPages = totalPages + 1;
        }
      }

      String currentPageStr = currentPage.toString();
      if (currentPage < 10) {
        currentPageStr = "0$currentPage";
      }

      String totalPagesStr = totalPages.toString();
      if (totalPages < 10) {
        totalPagesStr = "0$totalPages";
      }

      return Container(
        margin: const EdgeInsets.only(bottom: 80),
        child: ListView(
          children: [
            // 평점과 총 리뷰 수 섹션
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              margin: const EdgeInsets.only(top: 30),
              child: Row(
                children: [
                  Text(
                    starAvg,
                    style: TextStyle(
                      fontFamily: 'Pretendard',
                      fontSize: Responsive.getFont(context, 20),
                      fontWeight: FontWeight.bold,
                      color: Colors.black,
                      height: 1.2,
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 4.0),
                    child: Text(
                      '/5.0',
                      style: TextStyle(
                        fontFamily: 'Pretendard',
                        fontSize: Responsive.getFont(context, 20),
                        fontWeight: FontWeight.bold,
                        color: const Color(0xFFA4A4A4),
                        height: 1.2,
                      ),
                    ),
                  ),
                  const Spacer(),
                  Text(
                    '$reviewCount명의 리뷰',
                    style: TextStyle(
                      fontFamily: 'Pretendard',
                      fontWeight: FontWeight.w400,
                      fontSize: Responsive.getFont(context, 14),
                      height: 1.2,
                    ),
                  ),
                ],
              ),
            ),
            Container(
              margin: const EdgeInsets.symmetric(vertical: 10, horizontal: 16),
              child: _ratingTotalStars(double.parse(starAvg)),
            ),
            Container(
              margin: const EdgeInsets.only(top: 10, bottom: 20),
              height: 10,
              width: double.infinity,
              color: const Color(0xFFF5F9F9),
            ),

            // 리뷰 리스트
            ...List.generate(list.length, (index) {
              final reviewData = list[index];
              final reviewImages = reviewData.imgArr ?? [];

              return GestureDetector(
                onTap: () {
                  // 각 리뷰를 클릭했을 때 리뷰 상세 페이지로 이동
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => ProductReviewDetail(rtIdx: reviewData.rtIdx ?? 0,),
                    ),
                  );
                },
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      margin: const EdgeInsets.symmetric(horizontal: 16),
                      child: Row(
                        children: [
                          Text(
                            reviewData.mtId ?? "",
                            style: TextStyle(
                              fontFamily: 'Pretendard',
                              color: const Color(0xFF7B7B7B),
                              fontSize: Responsive.getFont(context, 12),
                              height: 1.2,
                            ),
                          ),
                          Container(
                            margin: const EdgeInsets.symmetric(horizontal: 10),
                            child: Text(
                              reviewData.rtWdate ?? "",
                              style: TextStyle(
                                fontFamily: 'Pretendard',
                                color: const Color(0xFF7B7B7B),
                                fontSize: Responsive.getFont(context, 12),
                                height: 1.2,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    Container(
                      margin: const EdgeInsets.symmetric(vertical: 10, horizontal: 16),
                      child: _ratingStars(double.parse(reviewData.rtStart ?? "0.0")),
                    ),
                    // 리뷰 텍스트 두 줄로 제한하고 넘칠 경우 생략 부호 표시
                    Container(
                      margin: const EdgeInsets.symmetric(horizontal: 16),
                      child: Text(
                        reviewData.rtContent ?? "",
                        style: TextStyle(
                          fontFamily: 'Pretendard',
                          fontSize: Responsive.getFont(context, 14),
                          color: Colors.black,
                          height: 1.2,
                        ),
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                    Container(
                      margin: const EdgeInsets.only(top: 10, bottom: 15, left: 16),
                      child: GestureDetector(
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => ReportPage(rtIdx: reviewData.rtIdx ?? 0,)),
                          );
                        },
                        child: Text(
                          '신고',
                          style: TextStyle(
                            fontFamily: 'Pretendard',
                            fontSize: Responsive.getFont(context, 12),
                            color: const Color(0xFF7B7B7B),
                            height: 1.2,
                          ),
                        ),
                      ),
                    ),
                    // 사진 목록 - 가로 사이즈에 맞게 배치
                    Container(
                      margin: const EdgeInsets.symmetric(horizontal: 16),
                      child: Row(
                        children: reviewImages.map((imagePath) {
                          return Expanded(
                            child: Padding(
                              padding: const EdgeInsets.symmetric(horizontal: 4.0),
                              child: ClipRRect(
                                borderRadius: BorderRadius.circular(8.0),
                                child: Image.network(
                                  imagePath,
                                  height: 90,
                                  fit: BoxFit.cover,
                                  errorBuilder: (BuildContext context, Object exception, StackTrace? stackTrace) {
                                    return const SizedBox();
                                  }
                                ),
                              ),
                            ),
                          );
                        }).toList(),
                      ),
                    ),
                    Container(
                      margin: const EdgeInsets.symmetric(vertical: 20),
                      child: const Divider(thickness: 1, color: Color(0xFFEEEEEE))
                    ),
                  ],
                ),
              );
            }),

            // 페이지네이션
            Visibility(
              visible: reviewCount == 0 ? false : true,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  IconButton(
                    icon: SvgPicture.asset('assets/images/product/pager_prev.svg'),
                    onPressed: () {
                      if (currentPage > 1) {
                        setState(() {
                          currentPage--;
                          _getList();
                        });
                      }
                    }
                  ),
                  Container(
                    margin: const EdgeInsets.symmetric(horizontal: 20),
                    child: Row(
                      children: [
                        Text(
                          currentPageStr,
                          style: TextStyle(
                            fontFamily: 'Pretendard',
                            fontSize: Responsive.getFont(context, 16),
                            fontWeight: FontWeight.w600,
                            height: 1.2,
                          ),
                        ),
                        Text(
                          ' / $totalPagesStr',
                          style: TextStyle(
                            fontFamily: 'Pretendard',
                            fontSize: Responsive.getFont(context, 16),
                            color: const Color(0xFFCCCCCC),
                            fontWeight: FontWeight.w600,
                            height: 1.2,
                          ),
                        ),
                      ],
                    ),
                  ),
                  IconButton(
                    icon: SvgPicture.asset('assets/images/product/pager_next.svg'),
                    onPressed: () {
                      if (currentPage < totalPages) {
                        setState(() {
                          currentPage++;
                          _getList();
                        });
                      }
                    }
                  ),
                ],
              ),
            ),
          ],
        ),
      );
    });
  }

  void _afterBuild(BuildContext context) {
    _getList();
  }

  void _getList() async {
    Map<String, dynamic> requestData = {
      'pt_idx': ptIdx,
      'pg': currentPage,
    };
    ref.read(productReviewListModelProvider)?.reviewInfoResponseDTO?.list?.clear();
    ref.read(productReviewListModelProvider.notifier).getList(requestData);
  }
}

Widget _buildHalfTotalStar(double rating) {
  return Stack(
    children: [
      const Icon(
        Icons.star,
        color: Color(0xFFEEEEEE), // 빈 별 색상
        size: 26,
      ),
       ClipRect(
        clipper: HalfClipper(),
        child: const Icon(
          Icons.star,
          color: Color(0xFFFF6191), // 채워진 별 색상
          size: 26,
        ),
      ),
    ],
  );
}

Widget _buildHalfStar(double rating) {
  return Stack(
    children: [
      const Icon(
        Icons.star,
        color: Color(0xFFEEEEEE), // 빈 별 색상
        size: 16,
      ),
      ClipRect(
        clipper: HalfClipper(),
        child: const Icon(
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
