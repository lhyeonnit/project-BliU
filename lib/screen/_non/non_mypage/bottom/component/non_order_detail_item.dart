import 'package:BliU/utils/responsive.dart';
import 'package:flutter/material.dart';

class NonOrderDetailItem extends StatelessWidget {
  final Map<String, dynamic> orderDetails; // 모든 정보를 포함한 맵

  const NonOrderDetailItem({super.key, required this.orderDetails});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          height: 10,
          width: double.infinity,
          color: Color(0xFFF5F9F9),
        ),
        // 배송지 정보
        Container(
          padding: EdgeInsets.symmetric(vertical: 20, horizontal: 16),
          child: Text(
            '배송지 정보',
            style: TextStyle(
                fontSize: Responsive.getFont(context, 18),
                fontWeight: FontWeight.bold),
          ),
        ),
        // 배송지 정보 세부 내용
        Container(
          padding: EdgeInsets.symmetric(vertical: 20),
          decoration: BoxDecoration(
            border: Border(
              top: BorderSide(
                color: Color(0xFFEEEEEE),
              ),
            ),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildInfoRow('수령인', orderDetails['recipientName'], context),
              Container(
                padding: EdgeInsets.symmetric(vertical: 15),
                child: _buildInfoRow(
                    '휴대폰번호', orderDetails['phoneNumber'], context),
              ),
              _buildAddressRow('주소', orderDetails['address'], context),
              Container(
                  padding: EdgeInsets.only(top: 15),
                  child: _buildInfoRow(
                      '배송메모', orderDetails['deliveryMemo'], context)),
            ],
          ),
        ),
        // 빈 공간
        Container(
          height: 10,
          width: double.infinity,
          color: Color(0xFFF5F9F9),
        ),
        Container(
          padding: EdgeInsets.symmetric(vertical: 20, horizontal: 16),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                '결제 금액',
                style: TextStyle(
                    fontSize: Responsive.getFont(context, 18),
                    fontWeight: FontWeight.bold),
              ),
              Text(
                '160,500원',
                style: TextStyle(
                    fontSize: Responsive.getFont(context, 14),
                    fontWeight: FontWeight.bold),
              ),
            ],
          ),
        ),
        // 배송지 정보 세부 내용
        Container(
          padding: EdgeInsets.symmetric(vertical: 20),
          decoration: BoxDecoration(
            border: Border(
              top: BorderSide(
                color: Color(0xFFEEEEEE),
              ),
            ),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildInfoRow('총 상품 금액', orderDetails['productPrice'], context),
              Container(
                margin: EdgeInsets.only(top: 15),
                  child: _buildInfoRow('총 배송비', orderDetails['deliveryFee'], context)),
              Container(
                margin: EdgeInsets.symmetric(vertical: 15),
                child: Column(
                  children: [
                    _buildInfoRow(
                        '할인금액', orderDetails['discountPrice'], context),
                    Padding(
                      padding: const EdgeInsets.only(left: 10.0),
                      child: Container(
                        margin: EdgeInsets.only(left: 10, top: 10, right: 16),
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text('ㄴ${orderDetails['couponName']}',
                                style: TextStyle(
                                    fontSize: Responsive.getFont(context, 14),
                                    color: Color(0xFFA4A4A4))),
                            Text("${orderDetails['couponDiscount']}",
                                style: TextStyle(
                                    fontSize: Responsive.getFont(context, 14),
                                    color: Color(0xFFA4A4A4))),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              _buildInfoRow(
                  '포인트할인', '${orderDetails['discountPoint']}', context),
              Container(
                margin: EdgeInsets.only(top: 20),
                height: 10,
                width: double.infinity,
                color: Color(0xFFF5F9F9),
              ),
              Container(
                padding: EdgeInsets.symmetric(vertical: 20, horizontal: 16),
                child: Text(
                  '결제 수단',
                  style: TextStyle(
                      fontSize: Responsive.getFont(context, 18),
                      fontWeight: FontWeight.bold),
                ),
              ),
              // 배송지 정보 세부 내용
              Container(
                padding: EdgeInsets.symmetric(vertical: 20),
                decoration: BoxDecoration(
                  border: Border(
                    top: BorderSide(
                      color: Color(0xFFEEEEEE),
                    ),
                  ),
                ),
                child: Padding(
                  padding:
                      const EdgeInsets.only(right: 16.0, left: 16, bottom: 30),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text('신용카드',
                          style: TextStyle(
                              fontSize: Responsive.getFont(context, 14),
                              color: Colors.black)),
                      Text('160,500원',
                          style: TextStyle(
                              fontSize: Responsive.getFont(context, 14),
                              color: Colors.black)),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  // 공통적인 Row 빌더 함수
  Widget _buildInfoRow(String title, String value, BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 16),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            title,
            style: TextStyle(
              fontSize: Responsive.getFont(context, 14),
              color: Colors.black,
            ),
          ),
          Text(
            value,
            style: TextStyle(
              fontSize: Responsive.getFont(context, 14),
              color: Colors.black,
            ),
          ),
        ],
      ),
    );
  }

  // 주소용 Row 빌더 함수
  Widget _buildAddressRow(
      String title, Map<String, String> address, BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 16),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            title,
            style: TextStyle(
              fontSize: Responsive.getFont(context, 14),
              color: Colors.black,
            ),
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Text(
                '[${address['addressCode']}] ${address['addressAll']}',
                style: TextStyle(
                  fontSize: Responsive.getFont(context, 14),
                  color: Colors.black,
                ),
              ),
              Text(
                '${address['addressDetail']}',
                style: TextStyle(
                  fontSize: Responsive.getFont(context, 14),
                  color: Colors.black,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
