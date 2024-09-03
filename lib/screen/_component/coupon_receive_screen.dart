import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import '../product/component/detail/coupon_card.dart';

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
    "discountDetails": "최대 40,000원 할인 가능\n구매금액 10,000원 이상인 경우 사용 가능\n다른 쿠폰과 중복 사용불가",
  },
  {
    "discount": "30%",
    "title": "꼬마옷장 첫 구매 30% 할인권",
    "expiryDate": "~ 24.05.05까지 사용 가능",
    "discountDetails": "최대 40,000원 할인 가능\n구매금액 10,000원 이상인 경우 사용 가능\n다른 쿠폰과 중복 사용불가",
  },
  {
    "discount": "5%",
    "title": "패션 키즈 VIP 할인 쿠폰",
    "expiryDate": "~ 24.05.05까지 사용 가능",
    "discountDetails": "최대 40,000원 할인 가능\n구매금액 10,000원 이상인 경우 사용 가능\n다른 쿠폰과 중복 사용불가",
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
        backgroundColor: Colors.white,
        title: const Text("쿠폰 받기", style: TextStyle(color: Colors.black)),
        leading: IconButton(
          icon: SvgPicture.asset("assets/images/product/ic_back.svg"),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
      ),
      body: Padding(
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
                    isDownloaded: couponStatus[index], // 상태 전달
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
            SizedBox(
              width: double.infinity,
              height: 48,
              child: ElevatedButton(
                onPressed: areAllCouponsDownloaded
                    ? null
                    : () {
                  markAllCouponsAsDownloaded();
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor:
                  areAllCouponsDownloaded ? Colors.grey : Colors.black,
                ),
                child: const Text(
                  "전체받기",
                  style: TextStyle(color: Colors.white),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
