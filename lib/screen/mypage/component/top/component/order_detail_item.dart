import 'package:BliU/data/order_detail_info_data.dart';
import 'package:BliU/utils/responsive.dart';
import 'package:BliU/utils/utils.dart';
import 'package:flutter/material.dart';

class OrderDetailItem extends StatelessWidget {
  final OrderDetailInfoData? orderDetailInfoData;

  const OrderDetailItem({super.key, required this.orderDetailInfoData});

  @override
  Widget build(BuildContext context) {
    Widget widget = const SizedBox();
    if ((orderDetailInfoData?.order?.otCouponInfo?.ctName ?? "").isNotEmpty) {
      widget = Padding(
        padding: const EdgeInsets.only(left: 10.0),
        child: Container(
          margin: const EdgeInsets.only(left: 10, top: 10, right: 16),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text('ㄴ${orderDetailInfoData?.order?.otCouponInfo?.ctName ?? ""}',
                  style: TextStyle(
                      fontFamily: 'Pretendard',
                      fontSize: Responsive.getFont(context, 14),
                      color: const Color(0xFFA4A4A4))),
              Text("${orderDetailInfoData?.order?.otCouponInfo?.ctPrice ?? ""}",
                  style: TextStyle(
                      fontFamily: 'Pretendard',
                      fontSize: Responsive.getFont(context, 14),
                      color: const Color(0xFFA4A4A4))),
            ],
          ),
        ),
      );
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          height: 10,
          width: double.infinity,
          color: const Color(0xFFF5F9F9),
        ),
        // 배송지 정보
        Container(
          padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 16),
          child: Text(
            '배송지 정보',
            style: TextStyle(
                fontFamily: 'Pretendard',
                fontSize: Responsive.getFont(context, 18),
                fontWeight: FontWeight.bold),
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
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildInfoRow(
                  '수령인', orderDetailInfoData?.delivery?.otRname ?? "", context),
              Container(
                padding: const EdgeInsets.symmetric(vertical: 15),
                child: _buildInfoRow('휴대폰번호',
                    orderDetailInfoData?.delivery?.otRtel ?? "", context),
              ),
              _buildAddressRow(
                  '주소',
                  "[${orderDetailInfoData?.delivery?.otRzip ?? ""}]${orderDetailInfoData?.delivery?.otRadd1 ?? ""}",
                  orderDetailInfoData?.delivery?.otRadd1 ?? "",
                  context),
              Container(
                  padding: const EdgeInsets.only(top: 15),
                  child: _buildInfoRow('배송메모',
                      orderDetailInfoData?.delivery?.otRmemo1 ?? "", context)),
            ],
          ),
        ),
        // 빈 공간
        Container(
          height: 10,
          width: double.infinity,
          color: const Color(0xFFF5F9F9),
        ),
        Container(
          padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 16),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                '결제 금액',
                style: TextStyle(
                    fontFamily: 'Pretendard',
                    fontSize: Responsive.getFont(context, 18),
                    fontWeight: FontWeight.bold),
              ),
              Text(
                '${Utils.getInstance().priceString(_getBillingPrice())}원',
                style: TextStyle(
                    fontFamily: 'Pretendard',
                    fontSize: Responsive.getFont(context, 14),
                    fontWeight: FontWeight.bold),
              ),
            ],
          ),
        ),
        //배송지 정보 세부 내용
        Container(
          padding: const EdgeInsets.symmetric(vertical: 20),
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
                  '총 상품 금액',
                  "${Utils.getInstance().priceString(orderDetailInfoData?.order?.otSprice ?? 0)}원",
                  context),
              Container(
                  margin: const EdgeInsets.only(top: 15),
                  child: _buildInfoRow(
                      '총 배송비',
                      "${Utils.getInstance().priceString((orderDetailInfoData?.order?.otDeliveryCharge ?? 0) + (orderDetailInfoData?.order?.otDeliveryChargeExtra ?? 0))}원",
                      context)),
              Container(
                margin: const EdgeInsets.symmetric(vertical: 15),
                child: Column(
                  children: [
                    _buildInfoRow(
                        '할인금액',
                        "${Utils.getInstance().priceString(orderDetailInfoData?.order?.otUseCoupon ?? 0)}원",
                        context),
                    widget,
                  ],
                ),
              ),
              _buildInfoRow(
                  '포인트할인',
                  '${Utils.getInstance().priceString(orderDetailInfoData?.order?.otUsePoint ?? 0)}원',
                  context),
              Container(
                margin: const EdgeInsets.only(top: 20),
                height: 10,
                width: double.infinity,
                color: const Color(0xFFF5F9F9),
              ),
              Container(
                padding:
                    const EdgeInsets.symmetric(vertical: 20, horizontal: 16),
                child: Text(
                  '결제 수단',
                  style: TextStyle(
                      fontFamily: 'Pretendard',
                      fontSize: Responsive.getFont(context, 18),
                      fontWeight: FontWeight.bold),
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
                child: Padding(
                  padding:
                      const EdgeInsets.only(right: 16.0, left: 16, bottom: 30),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(orderDetailInfoData?.order?.otPayType ?? "",
                          style: TextStyle(
                              fontFamily: 'Pretendard',
                              fontSize: Responsive.getFont(context, 14),
                              color: Colors.black)),
                      Text(
                          '${Utils.getInstance().priceString(_getBillingPrice())}원',
                          style: TextStyle(
                              fontFamily: 'Pretendard',
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
            ),
          ),
          Text(
            value,
            style: TextStyle(
              fontFamily: 'Pretendard',
              fontSize: Responsive.getFont(context, 14),
              color: Colors.black,
            ),
          ),
        ],
      ),
    );
  }

  // 주소용 Row 빌더 함수
  Widget _buildAddressRow(String title, String address, String addressDetail,
      BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            title,
            style: TextStyle(
              fontFamily: 'Pretendard',
              fontSize: Responsive.getFont(context, 14),
              color: Colors.black,
            ),
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Text(
                //'[${address['addressCode']}] ${address['addressAll']}',
                address,
                style: TextStyle(
                  fontFamily: 'Pretendard',
                  fontSize: Responsive.getFont(context, 14),
                  color: Colors.black,
                ),
              ),
              Text(
                //'${address['addressDetail']}',
                addressDetail,
                style: TextStyle(
                  fontFamily: 'Pretendard',
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

  int _getBillingPrice() {
    int result = (orderDetailInfoData?.order?.otSprice ?? 0) +
        (orderDetailInfoData?.order?.otDeliveryCharge ?? 0) +
        (orderDetailInfoData?.order?.otDeliveryChargeExtra ?? 0);

    // 할인금액 및 포인트 적용
    result = result -
        (orderDetailInfoData?.order?.otUsePoint ?? 0) -
        (orderDetailInfoData?.order?.otUseCoupon ?? 0);
    return result;
  }
}
