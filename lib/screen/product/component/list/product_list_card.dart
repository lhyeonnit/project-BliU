import 'package:flutter/material.dart';
import '../../product_detail_screen.dart';

class ProductListCard extends StatefulWidget {
  @override
  _ProductListCardState createState() => _ProductListCardState();
}

class _ProductListCardState extends State<ProductListCard> {
  bool isFavorite = false; // 좋아요 상태를 관리하기 위한 변수

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => ProductDetailScreen(), // 실제 ProductDetailScreen 클래스를 사용해야 합니다.
          ),
        );
      },
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white, // 배경을 흰색으로 설정
          borderRadius: BorderRadius.circular(10), // 카드 모서리를 둥글게 설정
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Stack(
              children: [
                ClipRRect(
                  borderRadius: BorderRadius.all(Radius.circular(10)), // 사진의 모서리만 둥글게 설정
                  child: Image.asset(
                    'assets/images/home/exhi.png', // 실제 이미지 경로로 변경
                    height: 180,
                    width: double.infinity,
                    fit: BoxFit.cover,
                  ),
                ),
                Positioned(
                  top: 5,
                  right: 5,
                  child: GestureDetector(
                    onTap: () {
                      setState(() {
                        isFavorite = !isFavorite; // 좋아요 상태를 토글
                      });
                    },
                    child: Icon(
                      isFavorite ? Icons.favorite : Icons.favorite_border,
                      color: isFavorite ? Colors.pink : Colors.white,
                      size: 24,
                    ),
                  ),
                ),
              ],
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
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
                      Spacer(),
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
  }
}
