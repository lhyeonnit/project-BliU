import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

import '../../../utils/responsive.dart';

class PaymentCoupon extends StatefulWidget {
  const PaymentCoupon({super.key});

  @override
  State<PaymentCoupon> createState() => _PaymentCouponState();
}

const List<Map<String, dynamic>> couponData = [
  {
    "discount": "10%",
    "rate": 0.1,
    "title": "키즈스타일 여름 특별 할인 쿠폰",
    "expiryDate": "~ 24.05.05까지 사용 가능",
    "discountDetails":
        "최대 40,000원 할인 가능\n구매금액 10,000원 이상인 경우 사용 가능\n다른 쿠폰과 중복 사용불가",
  },
  {
    "discount": "30%",
    "rate": 0.3,
    "title": "꼬마옷장 첫 구매 30% 할인권",
    "expiryDate": "~ 24.05.05까지 사용 가능",
    "discountDetails":
        "최대 40,000원 할인 가능\n구매금액 10,000원 이상인 경우 사용 가능\n다른 쿠폰과 중복 사용불가",
  },
  {
    "discount": "5%",
    "rate": 0.05,
    "title": "패션 키즈 VIP 할인 쿠폰",
    "expiryDate": "~ 24.05.05까지 사용 가능",
    "discountDetails":
        "최대 40,000원 할인 가능\n구매금액 10,000원 이상인 경우 사용 가능\n다른 쿠폰과 중복 사용불가",
  },
];

class _PaymentCouponState extends State<PaymentCoupon> {
  int? selectedCouponIndex; // 선택된 쿠폰의 인덱스 저장

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        scrolledUnderElevation: 0,
        backgroundColor: Colors.white,
        leading: IconButton(
          icon: SvgPicture.asset("assets/images/exhibition/ic_back.svg"),
          onPressed: () {
            Navigator.pop(context); // 뒤로가기 동작
          },
        ),
        title: const Text("쿠폰"),
        titleTextStyle: TextStyle(
          fontSize: Responsive.getFont(context, 18),
          fontWeight: FontWeight.w600,
          color: Colors.black,
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
          // 보유 쿠폰 정보
          Container(
            margin: const EdgeInsets.only(left: 16, top: 20),
            child: Text(
              '보유 쿠폰 ${couponData.length}장',
              style: TextStyle(
                fontWeight: FontWeight.normal,
                fontSize: Responsive.getFont(context, 14),
              ),
            ),
          ),
          // 구분선
          Container(
            margin: const EdgeInsets.only(top: 15),
            height: 10,
            width: double.infinity,
            color: const Color(0xFFF5F9F9),
          ),
          // 쿠폰 리스트
          Expanded(
            child: ListView.builder(
              itemCount: couponData.length,
              itemBuilder: (context, index) {
                final coupon = couponData[index];

                // 마지막 쿠폰 비활성화
                final bool isLastCoupon = index == couponData.length - 1;
                final bool isSelected = selectedCouponIndex == index;

                return Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Container(
                            margin: EdgeInsets.symmetric(vertical: 6),
                            child: Radio<int>(
                              value: index,
                              groupValue: selectedCouponIndex,
                              onChanged: isLastCoupon
                                  ? null // 마지막 쿠폰 비활성화
                                  : (int? value) {
                                setState(() {
                                  selectedCouponIndex = value;
                                });
                              },
                              activeColor: const Color(0xFFFF6192),
                              fillColor: MaterialStateProperty.resolveWith((states) {
                                if (!states.contains(MaterialState.selected)) {
                                  return const Color(0xFFDDDDDD); // 비선택 상태의 라디오 버튼 색상
                                }
                                return const Color(0xFFFF6192); // 선택된 상태의 색상
                              }),
                            ),
                          ),
                          Container(
                            margin: EdgeInsets.symmetric(vertical: 20),
                            child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Row(
                                      children: [
                                        Text(
                                          '${coupon["discount"]}',
                                          style: TextStyle(
                                            fontSize: Responsive.getFont(context, 16),
                                            color: const Color(0xFFFF6192),
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),
                                        Padding(
                                          padding: const EdgeInsets.symmetric(horizontal: 6),
                                          child: Text(
                                            '${coupon["title"]}',
                                            style: TextStyle(
                                              fontSize: Responsive.getFont(context, 16),
                                              fontWeight: FontWeight.bold,
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                    Container(
                                      padding: const EdgeInsets.symmetric(vertical: 10),
                                      child: Text(
                                        coupon["expiryDate"]!,
                                        style: TextStyle(
                                          fontSize: Responsive.getFont(context, 14),
                                        ),
                                      ),
                                    ),
                                    Text(
                                      coupon["discountDetails"]!,
                                      style: TextStyle(
                                        fontSize: Responsive.getFont(context, 12),
                                        color: const Color(0xFFA4A4A4),
                                      ),
                                    ),
                                  ],
                                ),
                          ),
                        ],
                      ),
                    // 쿠폰 사이의 선
                    if (!isLastCoupon)
                      Container(margin: EdgeInsets.symmetric(horizontal: 16),child: const Divider(thickness: 1, color: Color(0xFFEEEEEE))),
                  ],
                );
              },
            ),
          ),

          // 하단 할인 적용 버튼
          Container(
            width: double.infinity,
            height: Responsive.getHeight(context, 48),
            margin: const EdgeInsets.only(
              right: 16.0,
              left: 16.0,
              top: 9,
              bottom: 8,
            ),
            decoration: const BoxDecoration(
              color: Colors.black,
              borderRadius: BorderRadius.all(Radius.circular(6)),
            ),
            child: GestureDetector(
              onTap: () {
                if (selectedCouponIndex != null) {
                  // 선택된 쿠폰 데이터를 반환
                  Navigator.pop(context, couponData[selectedCouponIndex!]);
                }
              },
              child: Center(
                child: Text(
                  '할인 적용', // 여기에 실제 적용된 할인 금액을 표시
                  style: TextStyle(
                    fontSize: Responsive.getFont(context, 14),
                    color: Colors.white,
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
