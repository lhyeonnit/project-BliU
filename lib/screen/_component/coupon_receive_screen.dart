import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import '../product/dummy/coupon_list.dart';
import '../product/component/detail/coupon_card.dart';

class CouponReceiveScreen extends StatefulWidget {
  const CouponReceiveScreen({Key? key}) : super(key: key);

  @override
  _CouponReceiveScreenState createState() => _CouponReceiveScreenState();
}

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
