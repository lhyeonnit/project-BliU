import 'package:BliU/data/coupon_data.dart';
import 'package:BliU/utils/responsive.dart';
import 'package:BliU/utils/utils.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

class PaymentCoupon extends StatefulWidget {
  final List<CouponData> couponList;

  const PaymentCoupon({super.key, required this.couponList});

  @override
  State<PaymentCoupon> createState() => PaymentCouponState();
}

class PaymentCouponState extends State<PaymentCoupon> {
  int? _selectedCouponIndex; // 선택된 쿠폰의 인덱스 저장

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
        titleSpacing: -1.0,
        title: const Text("쿠폰"),
        titleTextStyle: TextStyle(
          fontFamily: 'Pretendard',
          fontSize: Responsive.getFont(context, 18),
          fontWeight: FontWeight.w600,
          color: Colors.black,
        ),
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(1.0), // 하단 구분선의 높이 설정
          child: Container(
            color: const Color(0x0D000000), // 하단 구분선 색상
            height: 1.0, // 구분선의 두께 설정
            child: Container(
              height: 1.0, // 그림자 부분의 높이
              decoration: const BoxDecoration(
                boxShadow: [
                  BoxShadow(
                    color: Color(0x0D000000),
                    blurRadius: 6.0,
                    spreadRadius: 0.1,
                    offset: Offset(0, 3),
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
              '보유 쿠폰 ${widget.couponList.length}장',
              style: TextStyle(
                fontFamily: 'Pretendard',
                fontWeight: FontWeight.normal,
                fontSize: Responsive.getFont(context, 14),
                height: 1.2,
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
              itemCount: widget.couponList.length,
              itemBuilder: (context, index) {
                final coupon = widget.couponList[index];

                final couponDiscount = coupon.couponDiscount ?? "0";
                final couponName = coupon.couponName ?? "";
                final couponEnd = "~ ${coupon.couponEnd ?? ""}까지 사용가능";

                String detailMessage = "구매금액 ${Utils.getInstance().priceString(coupon.couponMinPrice ?? 0)}원 이상인경우 사용 가능";
                if (coupon.couponMaxPrice != null) {
                  detailMessage = "최대 ${Utils.getInstance().priceString(coupon.couponMaxPrice ?? 0)} 할인 가능\n$detailMessage";
                }

                return Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    GestureDetector(
                      onTap: () {
                        if (coupon.couponUsealbe == "Y" && _selectedCouponIndex != index) {
                          setState(() {
                            _selectedCouponIndex = index;
                          });
                        }
                      },
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Container(
                            margin: const EdgeInsets.symmetric(vertical: 6),
                            child: Radio<int>(
                              value: index,
                              groupValue: _selectedCouponIndex,
                              onChanged: (int? value) {
                                if (coupon.couponUsealbe == "Y") {
                                  setState(() {
                                    _selectedCouponIndex = value;
                                  });
                                }
                              },
                              activeColor: const Color(0xFFFF6192),
                              fillColor: WidgetStateProperty.resolveWith((states) {
                                if (!states.contains(WidgetState.selected)) {
                                  return const Color(0xFFDDDDDD); // 비선택 상태의 라디오 버튼 색상
                                }
                                return const Color(0xFFFF6192); // 선택된 상태의 색상
                              }),
                            ),
                          ),
                          Container(
                            margin: const EdgeInsets.symmetric(vertical: 20),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Row(
                                  children: [
                                    Text(
                                      couponDiscount,
                                      style: TextStyle(
                                        fontFamily: 'Pretendard',
                                        fontSize: Responsive.getFont(context, 16),
                                        color: coupon.couponUsealbe == "Y" ? const Color(0xFFFF6192) : const Color(0xFFA4A4A4),
                                        fontWeight: FontWeight.bold,
                                        height: 1.2,
                                      ),
                                    ),
                                    Padding(
                                      padding: const EdgeInsets.symmetric(horizontal: 6),
                                      child: Text(
                                        couponName,
                                        style: TextStyle(
                                          fontFamily: 'Pretendard',
                                          fontSize: Responsive.getFont(context, 16),
                                          fontWeight: FontWeight.bold,
                                          color: coupon.couponUsealbe == "Y" ? Colors.black : const Color(0xFFA4A4A4),
                                          height: 1.2,
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                                Container(
                                  padding: const EdgeInsets.symmetric(vertical: 10),
                                  child: Text(
                                    couponEnd,
                                    style: TextStyle(
                                      fontFamily: 'Pretendard',
                                      fontSize: Responsive.getFont(context, 14),
                                      color: coupon.couponUsealbe == "Y" ? Colors.black : const Color(0xFFA4A4A4),
                                      height: 1.2,
                                    ),
                                  ),
                                ),
                                Text(
                                  detailMessage,
                                  style: TextStyle(
                                    fontFamily: 'Pretendard',
                                    fontSize: Responsive.getFont(context, 12),
                                    color: const Color(0xFFA4A4A4),
                                    height: 1.2,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                    // 쿠폰 사이의 선
                    Container(
                      margin: const EdgeInsets.symmetric(horizontal: 16),
                      child: const Divider(
                        thickness: 1,
                        color: Color(0xFFEEEEEE)
                      )
                    ),
                  ],
                );
              },
            ),
          ),
          // 하단 할인 적용 버튼
          GestureDetector(
            onTap: () {
              if (_selectedCouponIndex != null) {
                // 선택된 쿠폰 데이터를 반환
                Navigator.pop(context, widget.couponList[_selectedCouponIndex!]);
              }
            },
            child: Container(
              width: double.infinity,
              height: 48,
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
              child: Center(
                child: Text(
                  '할인 적용', // 여기에 실제 적용된 할인 금액을 표시
                  style: TextStyle(
                    fontFamily: 'Pretendard',
                    fontSize: Responsive.getFont(context, 14),
                    color: Colors.white,
                    height: 1.2,
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
