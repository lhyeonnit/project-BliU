import 'package:BliU/utils/responsive.dart';
import 'package:flutter/material.dart';

class PaymentDiscount extends StatefulWidget {
  const PaymentDiscount({super.key});

  @override
  State<PaymentDiscount> createState() => _PaymentDiscountState();
}

class _PaymentDiscountState extends State<PaymentDiscount> {
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
                '보유 쿠폰 2장',
                style: TextStyle(
                    fontSize: Responsive.getFont(context, 13),
                    color: Color(0xFF7B7B7B)),
              ),
            ],
          ),
          GestureDetector(
            onTap: () {},
            child: Container(
              padding: EdgeInsets.symmetric(horizontal: 20, vertical: 14),
              margin: EdgeInsets.only(top: 10, bottom: 20),
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.all(Radius.circular(6)),
                  border: Border.all(color: Color(0xFFDDDDDD))),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text('0원 할인 적용',
                      style: TextStyle(
                          fontSize: Responsive.getFont(context, 14),
                          fontWeight: FontWeight.normal)),
                  Text(
                    '>',
                    style: TextStyle(
                        fontSize: Responsive.getFont(context, 13),
                        color: Color(0xFF7B7B7B)),
                  ),
                ],
              ),
            ),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.baseline,
            textBaseline: TextBaseline.alphabetic,
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
