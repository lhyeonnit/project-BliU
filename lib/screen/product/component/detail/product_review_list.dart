import 'package:flutter/material.dart';
import 'product_review_detail.dart';
import 'report_page.dart';

class ProductReview extends StatefulWidget {
  const ProductReview({super.key});
  @override
  _ProductReviewState createState() => _ProductReviewState();
}

class _ProductReviewState extends State<ProductReview> {
  int currentPage = 1;
  int totalPages = 10;

  @override
  Widget build(BuildContext context) {
    return ListView(
      children: [
        // 평점과 총 리뷰 수 섹션
        const Padding(
          padding: EdgeInsets.all(16.0),
          child: Row(
            children: [
              Text(
                '4.8',
                style: TextStyle(
                  fontSize: 32,
                  fontWeight: FontWeight.bold,
                  color: Colors.black,
                ),
              ),
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 4.0),
                child: Text(
                  '/5.0',
                  style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                    color: Colors.grey,
                  ),
                ),
              ),
              Spacer(),
              Text(
                '30명의 리뷰',
                style: TextStyle(fontSize: 16, color: Colors.grey),
              ),
            ],
          ),
        ),
        const Padding(
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
        ...List.generate(3, (index) {
          List<String> reviewImages = [
            'assets/images/home/exhi.png',
            'assets/images/home/exhi.png',
            'assets/images/home/exhi.png',
            'assets/images/home/exhi.png',
          ];

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
                    const Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          'jw**********',
                          style: TextStyle(
                              fontWeight: FontWeight.bold, color: Colors.black),
                        ),
                        Text('2024.04.14', style: TextStyle(color: Colors.grey)),
                      ],
                    ),
                    const SizedBox(height: 4),
                    const Row(
                      children: [
                        Row(
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
                    const Text(
                      '저희 아이를 위해 \'해피 키즈 여름 티셔츠\'를 구매했는데 정말 만족스럽습니다! 옷감이 부드럽고 통기성이 좋아서 아이가 하루 종일 입고 다닙니다.',
                      style: TextStyle(fontSize: 14, color: Colors.black),
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
                        // 신고 버튼 클릭시 동작
                        Navigator.push(
                          context,
                          MaterialPageRoute(builder: (context) => const ReportPage()),
                        );
                      },
                      child: const Text(
                        '신고',
                        style: TextStyle(
                          fontSize: 12,
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
                style: const TextStyle(fontSize: 16),
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
}
