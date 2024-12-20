import 'package:BliU/data/order_detail_data.dart';
import 'package:BliU/data/return_info_data.dart';
import 'package:BliU/utils/responsive.dart';
import 'package:BliU/utils/utils.dart';
import 'package:flutter/material.dart';

class ExchangeReturnInfoChildWidget extends StatelessWidget {
  final ReturnInfoData? returnInfoData;
  final int? userType;
  final OrderDetailData orderDetailData;

  const ExchangeReturnInfoChildWidget({
    super.key,
    required this.returnInfoData,
    required this.orderDetailData,
    required this.userType,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Visibility(
          visible: userType == 1,
          child: Column(
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
                      "${Utils.getInstance().priceString(returnInfoData?.octReturnPoint ?? returnInfoData?.ortReturnPoint ?? 0)}원",
                      context,
                    ),
                    Container(
                      margin: const EdgeInsets.only(top: 10),
                      child: _buildInfoRow(
                        '배송비',
                        "${Utils.getInstance().priceString(returnInfoData?.deliveryPrice ?? returnInfoData?.deliveryPrice ?? 0)}원",
                        context,
                      ),
                    ),
                    Visibility(
                      visible: orderDetailData.ctStats == 2 || orderDetailData.ctStats == 3 ? false : true,
                      child: Container(
                        margin: const EdgeInsets.only(top: 10),
                        child: _buildInfoRow(
                          '배송비차감액',
                          "(-) ${Utils.getInstance().priceString((returnInfoData?.octDeliveryReturn ?? 0))}원",
                          context,
                        ),
                      ),
                    )
                  ],
                ),
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
                "${Utils.getInstance().priceString((returnInfoData?.octReturnPrice ?? returnInfoData?.ortReturnPrice ?? 0))}원",
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
          child: _buildInfoRow('환불방법', returnInfoData?.octReturnType ?? returnInfoData?.ortReturnType ?? "", context),
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
