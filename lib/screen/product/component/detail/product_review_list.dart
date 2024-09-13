import 'package:BliU/data/review_data.dart';
import 'package:BliU/screen/product/viewmodel/product_review_list_view_model.dart';
import 'package:BliU/utils/responsive.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
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

  @override
  Widget build(BuildContext context) {
    return Consumer(
      builder: (context, ref, widget) {
        final model = ref.watch(productReviewListModelProvider);
        List<ReviewData> list = model?.reviewInfoResponseDTO?.list ?? [];
        final starAvg = model?.reviewInfoResponseDTO?.reviewInfo?.starAvg ?? 0.0;
        final reviewCount = model?.reviewInfoResponseDTO?.reviewInfo?.reviewCount ?? 0;

        return ListView(
          children: [
            // 평점과 총 리뷰 수 섹션
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Row(
                children: [
                  Text(
                    '$starAvg',
                    style: TextStyle(
                      fontSize: Responsive.getFont(context, 32),
                      fontWeight: FontWeight.bold,
                      color: Colors.black,
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 4.0),
                    child: Text(
                      '/5.0',
                      style: TextStyle(
                        fontSize: Responsive.getFont(context, 24),
                        fontWeight: FontWeight.bold,
                        color: Colors.grey,
                      ),
                    ),
                  ),
                  const Spacer(),
                  Text(
                    '$reviewCount명의 리뷰',
                    style: TextStyle(
                      fontSize: Responsive.getFont(context, 16),
                      color: Colors.grey
                    ),
                  ),
                ],
              ),
            ),
            const Padding(
              // TODO 별점 작업
              padding: EdgeInsets.symmetric(horizontal: 16.0),
              child: Row(
                children: [
                  Icon(Icons.star, color: Colors.pink, size: 24),
                  Icon(Icons.star, color: Colors.pink, size: 24),
                  Icon(Icons.star, color: Colors.pink, size: 24),
                  Icon(Icons.star, color: Colors.pink, size: 24),
                  Icon(Icons.star_half, color: Colors.pink, size: 24),
                ],
              ),
            ),
            const SizedBox(height: 40),

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

              return Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16.0), // 양옆 여백 추가
                child: GestureDetector(
                  onTap: () {
                    // 각 리뷰를 클릭했을 때 리뷰 상세 페이지로 이동
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const ProductReviewDetail(),
                      ),
                    );
                  },
                  child: Padding(
                    padding: const EdgeInsets.only(bottom: 8.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              '${reviewData.mtId.toString().substring(0, 2)}**********',
                              style: const TextStyle(
                                fontWeight: FontWeight.bold,
                                color: Colors.black
                              ),
                            ),
                            Text(
                              reviewData.rtWdate ?? "",
                              style: const TextStyle(color: Colors.grey)
                            ),
                          ],
                        ),
                        const SizedBox(height: 4),
                        const Row(
                          children: [
                            Row(
                              // TODO 별점 작업 필요
                              children: [
                                Icon(Icons.star, color: Colors.pink, size: 16),
                                Icon(Icons.star, color: Colors.pink, size: 16),
                                Icon(Icons.star, color: Colors.pink, size: 16),
                                Icon(Icons.star, color: Colors.pink, size: 16),
                                Icon(Icons.star_half, color: Colors.pink, size: 16),
                              ],
                            ),
                          ],
                        ),
                        const SizedBox(height: 8),
                        // 리뷰 텍스트 두 줄로 제한하고 넘칠 경우 생략 부호 표시
                        Text(
                          reviewData.rtContent ?? "",
                          style: TextStyle(
                            fontSize: Responsive.getFont(context, 14),
                            color: Colors.black
                          ),
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                        ),
                        const SizedBox(height: 8),
                        // 사진 목록 - 가로 사이즈에 맞게 배치
                        Row(
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
                        const SizedBox(height: 8),
                        GestureDetector(
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
                              color: Colors.grey,
                            ),
                          ),
                        ),
                        Divider(thickness: 1, color: Colors.grey[300]),
                      ],
                    ),
                  ),
                ),
              );
            }),

            // 페이지네이션
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 16.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  IconButton(
                    icon: const Icon(Icons.arrow_back_ios),
                    onPressed: currentPage > 1
                        ? () {
                      setState(() {
                        currentPage--;
                      });
                    }
                        : null,
                  ),
                  Text(
                    '${currentPage.toString().padLeft(2, '0')} / $totalPages',
                    style: TextStyle(
                      fontSize: Responsive.getFont(context, 16)
                    ),
                  ),
                  IconButton(
                    icon: const Icon(Icons.arrow_forward_ios),
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
            ),
          ],
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
