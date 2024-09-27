import 'package:BliU/data/order_detail_info_data.dart';
import 'package:BliU/utils/responsive.dart';
import 'package:BliU/utils/utils.dart';
import 'package:flutter/material.dart';

class ExchangeReturnInfo extends StatelessWidget {
  final OrderDetailInfoData? orderDetailInfoData;

  const ExchangeReturnInfo({super.key, required this.orderDetailInfoData});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          margin: const EdgeInsets.symmetric(vertical: 20),
          height: 10,
          width: double.infinity,
          color: const Color(0xFFF5F9F9),
        ),
        Container(
          padding: const EdgeInsets.only(left: 16, right: 16, bottom: 20),
          child: Text(
            '환불정보',
            style: TextStyle(
              fontFamily: 'Pretendard',
              fontSize: Responsive.getFont(context, 18),
              fontWeight: FontWeight.bold,
              height: 1.2,
            ),
          ),
        ),
        // 배송지 정보 세부 내용
        Container(
          padding: const EdgeInsets.only(top: 20),
          decoration: const BoxDecoration(
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
                  '포인트환급액',
                  "${Utils.getInstance().priceString(orderDetailInfoData?.order?.otUsePoint ?? 0)}원",
                  context),
              Container(
                margin: const EdgeInsets.only(top: 15),
                child: _buildInfoRow(
                    '배송비차감액',
                    "(-) ${Utils.getInstance().priceString((orderDetailInfoData?.order?.otDeliveryCharge ?? 0) + (orderDetailInfoData?.order?.otDeliveryChargeExtra ?? 0))}원",
                    context),
              ),
            ],
          ),
        ),
        Container(
          margin: const EdgeInsets.symmetric(vertical: 20),
          height: 10,
          width: double.infinity,
          color: const Color(0xFFF5F9F9),
        ),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          margin: const EdgeInsets.only(bottom: 20),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                '환불예정금액',
                style: TextStyle(
                  fontFamily: 'Pretendard',
                  fontSize: Responsive.getFont(context, 18),
                  fontWeight: FontWeight.bold,
                  height: 1.2,
                ),
              ),
              Text(
                "${Utils.getInstance().priceString((orderDetailInfoData?.order?.otSprice ?? 0) - ((orderDetailInfoData?.order?.otUseCoupon ?? 0) + (orderDetailInfoData?.order?.otUsePoint ?? 0) + (orderDetailInfoData?.order?.otDeliveryCharge ?? 0) + (orderDetailInfoData?.order?.otDeliveryChargeExtra ?? 0)))}원",
                style: TextStyle(
                  fontFamily: 'Pretendard',
                  fontSize: Responsive.getFont(context, 14),
                  fontWeight: FontWeight.bold,
                  height: 1.2,
                ),
              ),
            ],
          ),
        ),
        // 배송지 정보 세부 내용
        Container(
          padding: const EdgeInsets.symmetric(vertical: 20),
          decoration: const BoxDecoration(
            border: Border(
              top: BorderSide(
                color: Color(0xFFEEEEEE),
              ),
            ),
          ),
          //TODO 차후 변경 필요
          child: _buildInfoRow('환불방법', "카드승인취소", context),
        ),
      ],
    );
  }

  Widget _buildInfoRow(String title, String value, BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            title,
            style: TextStyle(
              fontFamily: 'Pretendard',
              fontSize: Responsive.getFont(context, 14),
              color: Colors.black,
              height: 1.2,
            ),
          ),
          Text(
            value,
            style: TextStyle(
              fontFamily: 'Pretendard',
              fontSize: Responsive.getFont(context, 14),
              color: Colors.black,
              height: 1.2,
            ),
          ),
        ],
      ),
    );
  }
}
