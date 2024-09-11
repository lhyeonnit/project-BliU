import 'package:BliU/screen/payment/component/payment_coupon.dart';
import 'package:BliU/utils/responsive.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

class PaymentDiscount extends StatefulWidget {
  final Function(double discountRate) onCouponSelected; // 선택된 쿠폰 할인율을 전달할 콜백

  const PaymentDiscount({Key? key, required this.onCouponSelected}) : super(key: key);

  @override
  State<PaymentDiscount> createState() => _PaymentDiscountState();
}

class _PaymentDiscountState extends State<PaymentDiscount> {
  double discountRate = 0.0;
  String couponText = "0원 할인 적용";
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 20.0, horizontal: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                '쿠폰',
                style: TextStyle(
                    fontSize: Responsive.getFont(context, 13),
                    fontWeight: FontWeight.normal),
              ),
              Text(
                '보유 쿠폰 3장',
                style: TextStyle(
                    fontSize: Responsive.getFont(context, 13),
                    color: Color(0xFF7B7B7B)),
              ),
            ],
          ),
          GestureDetector(
            onTap: () async {
              final selectedCoupon = await Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => PaymentCoupon()),
              );
              if (selectedCoupon != null) {
                setState(() {
                  discountRate = selectedCoupon['rate']; // 선택된 할인율 적용
                  couponText = "${(discountRate * 100).toInt()}% 할인 적용";
                });
                widget.onCouponSelected(discountRate); // 부모로 할인율 전달
              }
            },
            child: Container(
              padding: EdgeInsets.symmetric(horizontal: 20, vertical: 14),
              margin: EdgeInsets.only(top: 10, bottom: 20),
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.all(Radius.circular(6)),
                  border: Border.all(color: Color(0xFFDDDDDD))),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(couponText,
                      style: TextStyle(
                          fontSize: Responsive.getFont(context, 14),
                          fontWeight: FontWeight.normal)),
                  SvgPicture.asset(
                    'assets/images/ic_link.svg',
                  ),
                ],
              ),
            ),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text('포인트 사용',
                  style: TextStyle(
                      fontSize: Responsive.getFont(context, 13),
                      fontWeight: FontWeight.normal)),
              Text(
                '보유 포인트 0P',
                style: TextStyle(
                    fontSize: Responsive.getFont(context, 13),
                    color: Color(0xFF7B7B7B)),
              ),
            ],
          ),
          Padding(
            padding: const EdgeInsets.only(top: 10.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  flex: 7,
                  child: Container(
                    margin: EdgeInsets.only(right: 8),
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.all(Radius.circular(6)),
                        border: Border.all(color: Color(0xFFDDDDDD))),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.baseline,
                      textBaseline: TextBaseline.alphabetic,
                      children: [
                        Expanded(
                          child: TextField(
                            keyboardType: TextInputType.number, // 숫자 입력만 가능하게 설정
                            decoration: InputDecoration(
                              border: InputBorder.none, // 테두리 제거
                              hintText: '0',
                              hintStyle: TextStyle(
                                fontSize: Responsive.getFont(context, 14),
                                color: Color(0xFF707070),
                              ),
                            ),
                            textAlign: TextAlign.right, // 텍스트를 오른쪽 정렬
                          ),
                        ),
                        Container(
                          padding: EdgeInsets.only(right: 15, left: 10),
                          child: Text('P',
                              style: TextStyle(
                                  fontSize: Responsive.getFont(context, 14),
                                  fontWeight: FontWeight.normal)),
                        ),
                      ],
                    ),
                  ),
                ),
                Expanded(
                  flex: 3,
                  child: Container(
                    padding: EdgeInsets.symmetric(vertical: 14),
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.all(Radius.circular(6)),
                        border: Border.all(color: Color(0xFFDDDDDD))),
                    child: Center(
                      child: Text(
                        '전액사용',
                        style: TextStyle(
                            fontSize: Responsive.getFont(context, 14),
                            fontWeight: FontWeight.normal),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
