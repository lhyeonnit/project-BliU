import 'package:flutter/material.dart';

import '../../../_component/coupon_receive_screen.dart';

class ProductInfoTitle extends StatelessWidget {
  const ProductInfoTitle({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(10.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // 로고 버튼
              Container(
                width: 50,
                height: 50,
                decoration: const BoxDecoration(
                  shape: BoxShape.circle, // 이미지를 동그랗게 만들기
                  image: DecorationImage(
                    image: AssetImage('assets/images/home/exhi.png'),
                    // 실제 로고 이미지 경로로 변경
                    fit: BoxFit.cover,
                  ),
                ),
              ),
              const SizedBox(width: 8),
              // 나머지 텍스트와 공유 버튼을 포함한 컬럼
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // 첫 번째 줄: 브랜드명, 공유 버튼
                    Row(
                      children: [
                        // 브랜드명 및 화살표 버튼
                        TextButton(
                          onPressed: () {
                            // 브랜드명 버튼 동작
                          },
                          child: const Row(
                            children: [
                              Text(
                                '밀크마일', // 브랜드명
                                style: TextStyle(
                                    color: Colors.black, fontSize: 16),
                              ),
                              Icon(Icons.arrow_forward_ios,
                                  size: 16, color: Colors.black),
                            ],
                          ),
                        ),
                        const Spacer(), // 공간을 채워서 오른쪽 정렬
                        // 공유 버튼
                        IconButton(
                          icon: const Icon(Icons.share, color: Colors.black),
                          onPressed: () {
                            // 공유 버튼 동작
                          },
                        ),
                      ],
                    ),
                    const SizedBox(height: 8), // 첫 번째 줄과 제목 사이 간격
                    // 상품 제목
                    const Text(
                      '[밀크마일] [균일특가+무배] 밀크마일 에스더버니 12종 10,900원 균일가 상하복/원피스/티셔츠',
                      style: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 8), // 제목과 가격 정보 사이 간격
                    // 가격 정보
                    const Row(
                      children: [
                        Text(
                          '10%', // 할인률
                          style: TextStyle(
                            fontSize: 16,
                            color: Colors.red,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        SizedBox(width: 8), // 할인률과 할인 가격 사이 간격
                        Text(
                          '53,800원', // 할인된 가격
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        SizedBox(width: 8), // 할인 가격과 원래 가격 사이 간격
                        Text(
                          '53,800원', // 원래 가격
                          style: TextStyle(
                            fontSize: 14,
                            color: Colors.grey,
                            decoration: TextDecoration.lineThrough, // 취소선
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 15), // 로고 및 텍스트와 구분선 사이 간격
          // 구분선
          Divider(
            height: 1,
            thickness: 1,
            color: Colors.grey[300],
            indent: 5,
            // 왼쪽 여백
            endIndent: 5, // 오른쪽 여백
          ),
          const SizedBox(height: 15), // 구분선과 배송비 정보 사이 간격
          // 배송비 정보
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8.0),
            child: Column(
              children: [
                const Row(
                  children: [
                    Text(
                      '배송비', // 배송비 텍스트
                      style: TextStyle(fontSize: 14, color: Colors.black),
                    ),
                    SizedBox(width: 40),
                    Expanded(
                      child: Text(
                        '3,000원(50,000원 이상 무료배송)', // 배송비 정보
                        style: TextStyle(fontSize: 14, color: Colors.black),
                      ),
                    ),
                    Icon(Icons.arrow_forward_ios,
                        size: 16, color: Colors.black),
                    // 화살표 아이콘
                  ],
                ),
                Row(
                  children: [
                    const Text(
                      '쿠폰',
                      style: TextStyle(fontSize: 14, color: Colors.black),
                    ),
                    const SizedBox(width: 35),
                    TextButton(
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => const CouponReceiveScreen(),
                          ),
                        );
                      },
                      child: Container(
                        decoration: BoxDecoration(
                          border: Border.all(color: Colors.grey),
                          borderRadius: BorderRadius.circular(5),
                        ),
                        child: const Padding(
                          padding: EdgeInsets.symmetric(vertical: 3.0, horizontal: 8),
                          child: Text(
                            '쿠폰 다운로드',
                            style: TextStyle(fontSize: 14, color: Colors.black),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
