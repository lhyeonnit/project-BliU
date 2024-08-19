import 'package:flutter/material.dart';

class ProductAi extends StatefulWidget {
  const ProductAi({super.key});

  @override
  _ProductAiState createState() => _ProductAiState();
}

class _ProductAiState extends State<ProductAi> {
  // 각 상품별로 좋아요 상태를 관리하는 리스트
  List<bool> isFavoriteList = List.generate(5, (index) => false);

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.all(16.0),
          child: Text(
            '연관 상품',
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),
        ),
        Container(
          height: 280, // 높이를 설정하여 이미지 카드들이 가로로 스크롤되도록 함
          child: ListView.builder(
            scrollDirection: Axis.horizontal, // 가로 스크롤 가능하도록 설정
            itemCount: isFavoriteList.length, // 임의의 연관 상품 갯수
            itemBuilder: (context, index) {
              return Padding(
                padding: const EdgeInsets.only(left: 16.0),
                child: SizedBox(
                  width: 160, // 가로 너비를 160으로 고정
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Stack(
                        children: [
                          ClipRRect(
                            borderRadius: BorderRadius.all(Radius.circular(10)), // 사진의 모서리만 둥글게 설정
                            child: Image.asset(
                              'assets/images/home/exhi.png', // 실제 이미지 경로로 변경
                              height: 160,
                              width: 160, // 고정된 너비 설정
                              fit: BoxFit.cover,
                            ),
                          ),
                          Positioned(
                            top: 5,
                            right: 5,
                            child: GestureDetector(
                              onTap: () {
                                setState(() {
                                  isFavoriteList[index] =
                                  !isFavoriteList[index]; // 각 상품별로 좋아요 상태를 토글
                                });
                              },
                              child: Icon(
                                isFavoriteList[index]
                                    ? Icons.favorite
                                    : Icons.favorite_border,
                                color: isFavoriteList[index]
                                    ? Colors.pink
                                    : Colors.white,
                                size: 24,
                              ),
                            ),
                          ),
                        ],
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(vertical: 8.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              '꿈꾸는데이지',
                              style: TextStyle(fontSize: 12, color: Colors.grey),
                            ),
                            SizedBox(height: 4), // 텍스트와 텍스트 사이에 간격 추가
                            Text(
                              '꿈꾸는 데이지 안나 토션 레이스 베스트',
                              style: TextStyle(
                                fontSize: 14,
                                fontWeight: FontWeight.bold,
                              ),
                              maxLines: 1, // 한 줄만 표시
                              overflow: TextOverflow.ellipsis, // 길면 생략부호 처리
                            ),
                            SizedBox(height: 8),
                            Row(
                              children: [
                                Text(
                                  '15%',
                                  style: TextStyle(
                                    fontSize: 14,
                                    color: Colors.red,
                                  ),
                                ),
                                SizedBox(width: 4),
                                Text(
                                  '32,800원',
                                  style: TextStyle(
                                    fontSize: 14,
                                    fontWeight: FontWeight.bold,
                                  ),
                                  maxLines: 1, // 한 줄만 표시
                                ),
                              ],
                            ),
                            SizedBox(height: 4),
                            Row(
                              children: [
                                Icon(
                                  Icons.favorite_outline,
                                  size: 14,
                                  color: Colors.grey,
                                ),
                                SizedBox(width: 4),
                                Text(
                                  '13,000',
                                  style: TextStyle(
                                    fontSize: 12,
                                    color: Colors.grey,
                                  ),
                                  maxLines: 1, // 한 줄만 표시
                                ),
                                SizedBox(width: 10), // 고정된 공간을 추가하여 아이콘과 텍스트 간격 유지
                                Icon(
                                  Icons.people,
                                  size: 14,
                                  color: Colors.grey,
                                ),
                                SizedBox(width: 4),
                                Text(
                                  '49',
                                  style: TextStyle(fontSize: 12, color: Colors.grey),
                                  maxLines: 1, // 한 줄만 표시
                                ),
                              ],
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
      ],
    );
  }
}
