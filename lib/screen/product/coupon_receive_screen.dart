import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import '../../utils/responsive.dart';
import 'component/detail/coupon_card.dart';

class CouponReceiveScreen extends StatefulWidget {
  const CouponReceiveScreen({super.key});

  @override
  _CouponReceiveScreenState createState() => _CouponReceiveScreenState();
}

const List<Map<String, String>> couponData = [
  {
    "discount": "10%",
    "title": "키즈스타일 여름 특별 할인 쿠폰",
    "expiryDate": "~ 24.05.05까지 사용 가능",
    "discountDetails":
        "최대 40,000원 할인 가능\n구매금액 10,000원 이상인 경우 사용 가능\n다른 쿠폰과 중복 사용불가",
  },
  {
    "discount": "30%",
    "title": "꼬마옷장 첫 구매 30% 할인권",
    "expiryDate": "~ 24.05.05까지 사용 가능",
    "discountDetails":
        "최대 40,000원 할인 가능\n구매금액 10,000원 이상인 경우 사용 가능\n다른 쿠폰과 중복 사용불가",
  },
  {
    "discount": "5%",
    "title": "패션 키즈 VIP 할인 쿠폰",
    "expiryDate": "~ 24.05.05까지 사용 가능",
    "discountDetails":
        "최대 40,000원 할인 가능\n구매금액 10,000원 이상인 경우 사용 가능\n다른 쿠폰과 중복 사용불가",
  },
];

class _CouponReceiveScreenState extends State<CouponReceiveScreen> {
  // 쿠폰 상태를 관리하는 리스트
  List<bool> couponStatus = [false, false, false];

  // 모든 쿠폰을 발급 완료로 변경하는 함수
  void markAllCouponsAsDownloaded() {
    setState(() {
      for (int i = 0; i < couponStatus.length; i++) {
        couponStatus[i] = true;
      }
    });
  }

  // 전체받기 버튼 활성화 여부 판단
  bool get areAllCouponsDownloaded => couponStatus.every((status) => status);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        scrolledUnderElevation: 0,
        backgroundColor: Colors.white,
        title: const Text('쿠폰 받기'),
        titleTextStyle: TextStyle(
          fontSize: Responsive.getFont(context, 18),
          fontWeight: FontWeight.w600,
          color: Colors.black,
        ),
        leading: IconButton(
          icon: SvgPicture.asset("assets/images/store/ic_back.svg"),
          onPressed: () {
            Navigator.pop(context); // 뒤로가기 동작
          },
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
      body: Stack(
        children: [
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              children: [
                Expanded(
                  child: ListView.builder(
                    itemCount: couponData.length,
                    itemBuilder: (context, index) {
                      final coupon = couponData[index];
                      return CouponCard(
                        discount: coupon["discount"]!,
                        title: coupon["title"]!,
                        expiryDate: coupon["expiryDate"]!,
                        discountDetails: coupon["discountDetails"]!,
                        isDownloaded: couponStatus[index],
                        // 상태 전달
                        onDownload: () {
                          setState(() {
                            couponStatus[index] = true; // 쿠폰 상태 업데이트
                          });
                        },
                        couponKey: index.toString(), // 고유한 키 전달
                      );
                    },
                  ),
                ),
              ],
            ),
          ),
          Positioned(
            bottom: 0,
            left: 0,
            right: 0,
            child: GestureDetector(
              onTap: areAllCouponsDownloaded
                  ? null // 이미 모든 쿠폰을 다운로드받았을 경우 작동하지 않도록
                  : () {
                markAllCouponsAsDownloaded(); // 전체 쿠폰을 다운로드 처리
              },
              child: Container(
                width: double.infinity,
                height: Responsive.getHeight(context, 48),
                margin: EdgeInsets.only(
                    right: 16.0, left: 16, top: 8, bottom: 9),
                decoration: BoxDecoration(
                  color: areAllCouponsDownloaded
                      ? Color(0xFFDDDDDD) // 모든 쿠폰이 다운로드된 경우 회색으로 비활성화
                      : Colors.black, // 다운로드할 쿠폰이 있으면 활성화
                  borderRadius: BorderRadius.all(
                    Radius.circular(6),
                  ),
                ),
                child: Center(
                  child: Text(
                    '전체받기',
                    style: TextStyle(
                      fontSize: Responsive.getFont(context, 14),
                      color: Colors.white,
                    ),
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