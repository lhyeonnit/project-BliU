import 'package:flutter/material.dart';

import '../../../../../utils/responsive.dart';

class ExchangeReturnInfo extends StatelessWidget {
  const ExchangeReturnInfo({super.key});

  @override
  Widget build(BuildContext context) {
    Map<String, dynamic> exchangeReturnInfo = {
      'pointRefundAmount': '1,042원',
      'shippingDeductionAmount': '(-) 0원',
      'refundAmount': '13,366원',
      'refundMethod': '카드승인취소',
    };

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          margin: EdgeInsets.symmetric(vertical: 20),
          height: 10,
          width: double.infinity,
          color: Color(0xFFF5F9F9),
        ),
        Container(
          padding: EdgeInsets.only(left: 16, right: 16, bottom: 20),
          child: Text(
            '환불정보',
            style: TextStyle(
                fontSize: Responsive.getFont(context, 18),
                fontWeight: FontWeight.bold),
          ),
        ),
        // 배송지 정보 세부 내용
        Container(
          padding: EdgeInsets.only(top: 20),
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
              _buildInfoRow(
                  '포인트환급액', exchangeReturnInfo['pointRefundAmount'], context),
              Container(
                margin: EdgeInsets.only(top: 15),
                child: _buildInfoRow('배송비차감액',
                    exchangeReturnInfo['shippingDeductionAmount'], context),
              ),
            ],
          ),
        ),
        Container(
          margin: EdgeInsets.symmetric(vertical: 20),
          height: 10,
          width: double.infinity,
          color: Color(0xFFF5F9F9),
        ),
        Container(
          padding: EdgeInsets.symmetric(horizontal: 16),
          margin: EdgeInsets.only(bottom: 20),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                '환불예정금액',
                style: TextStyle(
                    fontSize: Responsive.getFont(context, 18),
                    fontWeight: FontWeight.bold),
              ),
              Text(
                '${exchangeReturnInfo['refundAmount']}',
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
          child: _buildInfoRow(
              '환불방법', exchangeReturnInfo['refundMethod'], context),
        ),
      ],
    );
  }

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
}
