import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

class StoreInfoPage extends StatelessWidget {
  const StoreInfoPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Stack으로 이미지와 로고를 겹치기
          Stack(
            clipBehavior: Clip.none, // 클리핑을 하지 않도록 설정
            children: [
              ClipRRect(
                borderRadius: BorderRadius.circular(12.0),
                child: Image.asset(
                  'assets/images/store/store_detail.png',
                  width: double.infinity,
                  height: 500,
                  fit: BoxFit.cover,
                ),
              ),
              Positioned(
                bottom: -65, // 이미지 하단에 겹치도록 설정
                left: -15,
                child: Image.asset(
                  'assets/images/store/brand_logo.png',
                  width: 130,
                  height: 130,
                  fit: BoxFit.contain,
                ),
              ),
            ],
          ),

          SizedBox(height: 45),
          // 상점 정보 부분
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 10.0),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // 상점명 및 정보
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        '밀크마일',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 4),
                      const Text(
                        '캐주얼 (Casual), 키즈(3-8세)',
                        style: TextStyle(
                          fontSize: 14,
                          color: Colors.grey,
                        ),
                      ),
                    ],
                  ),
                ),

                // 즐겨찾기 및 아이콘
                Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Container(
                      padding: EdgeInsets.symmetric(vertical: 8.0, horizontal: 12.0),
                      decoration: BoxDecoration(
                        border: Border.all(color: Colors.grey.shade300),
                        borderRadius: BorderRadius.circular(20.0),
                      ),
                      child: Row(
                        children: [
                          const Text(
                            '즐겨찾기 1,761',
                            style: TextStyle(fontSize: 16),
                          ),
                          const SizedBox(width: 8), // 텍스트와 아이콘 사이의 간격
                          SvgPicture.asset(
                            'assets/images/store/book_mark.svg',
                            width: 13,
                            height: 13,
                          ),
                        ],
                      ),
                    ),
                  ],
                ),

              ],
            ),
          ),
          const SizedBox(height: 16),

          // 설명 텍스트
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 10.0),
            child: const Text(
              '저희 키즈 의류 쇼핑몰은 다양한 스타일과 고품질의 어린이 의류 브랜드들을 자랑합니다. 각 브랜드는 아이들의 편안함과 안전을 최우선으로 생각하며, 트렌디하면서도 실용적인 디자인을 제공합니다. 모든 의류는 친환경 소재로 제작되어 아이들의 민감한 피부에도 심하고 착용할 수 있습니다.',
              style: TextStyle(
                fontSize: 14,
                height: 1.5,
              ),
            ),
          ),
          const SizedBox(height: 16),

          // 쿠폰 다운로드 버튼
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 10.0),
            child: SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: () {
                  // 쿠폰 다운로드 기능 구현
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(vertical: 12),
                  shape: RoundedRectangleBorder(
                    side: BorderSide(color: Colors.grey),
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
                child: const Text(
                  '쿠폰 다운로드',
                  style: TextStyle(color: Colors.black),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
