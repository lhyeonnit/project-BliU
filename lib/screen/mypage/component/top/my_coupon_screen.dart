import 'package:BliU/screen/mypage/component/top/my_coupon_card.dart';
import 'package:BliU/screen/product/component/detail/coupon_card.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

import '../../../../utils/responsive.dart';


class MyCouponScreen extends StatefulWidget {
  const MyCouponScreen({super.key});

  @override
  State<MyCouponScreen> createState() => _MyCouponScreenState();
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
class _MyCouponScreenState extends State<MyCouponScreen> {
  List<String> categories = ['사용가능', '완료/만료'];
  List<bool> couponStatus = [false, false, false];
  int selectedCategoryIndex = 0;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        title: const Text('쿠폰'),
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
      body: Padding(
        padding: const EdgeInsets.only(top: 20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                height: 40,
                padding: const EdgeInsets.symmetric(horizontal: 13.0),
                child: ListView.builder(
                  scrollDirection: Axis.horizontal,
                  itemCount: categories.length,
                  itemBuilder: (context, index) {
                    final bool isSelected = selectedCategoryIndex == index;

                    return Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 3.0),
                      child: FilterChip(
                        label: Text(
                          categories[index],
                          style: TextStyle(
                            color:
                                isSelected ? Colors.pink : Colors.black, // 텍스트 색상
                          ),
                        ),
                        selected: isSelected,
                        onSelected: (bool selected) {
                          setState(() {
                            selectedCategoryIndex = index;
                          });
                        },
                        backgroundColor: Colors.white,
                        selectedColor: Colors.white,
                        shape: StadiumBorder(
                          side: BorderSide(
                            color: isSelected ? Colors.pink : Colors.grey,
                            // 테두리 색상
                            width: 1.0,
                          ),
                        ),
                        showCheckmark: false, // 체크 표시 없애기
                      ),
                    );
                  },
                ),
              ),
              const SizedBox(height: 20),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16.0),
                child: Text('쿠폰 ${couponData.length}'),
              ),
              const SizedBox(height: 10),
              Expanded(
                child: ListView.builder(
                  itemCount: couponData.length,
                  itemBuilder: (context, index) {
                    final coupon = couponData[index];
                    return Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 16.0),
                      child: MyCouponCard(
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
                      ),
                    );
                  },
                ),
              ),
            ],
          ),
      ),
      );
  }
}
