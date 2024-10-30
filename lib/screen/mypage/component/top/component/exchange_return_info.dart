import 'package:BliU/data/cancel_detail_data.dart';
import 'package:BliU/data/order_detail_data.dart';
import 'package:BliU/data/order_detail_info_data.dart';
import 'package:BliU/utils/responsive.dart';
import 'package:BliU/utils/utils.dart';
import 'package:flutter/material.dart';

class ExchangeReturnInfo extends StatelessWidget {
  final OrderDetailInfoData? orderDetailInfoData;
  final OrderDetailData? orderDetailData;
  final int? userType;
  final CancelDetailData? cancelDetailData;

  const ExchangeReturnInfo({
    super.key,
    this.orderDetailInfoData,
    this.orderDetailData,
    this.userType,
    this.cancelDetailData,
  });

  @override
  Widget build(BuildContext context) {
    Widget widget = const SizedBox();
    if ((orderDetailInfoData?.order?.otCouponInfo?.ctName ?? cancelDetailData?.order?.otCouponInfo?.ctName ?? "").isNotEmpty) {
      widget = Padding(
        padding: const EdgeInsets.only(left: 10.0),
        child: Container(
          margin: const EdgeInsets.only(left: 10, top: 10, right: 16),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text('ㄴ${orderDetailInfoData?.order?.otCouponInfo?.ctName ?? cancelDetailData?.order?.otCouponInfo?.ctName ?? ""}',
                  style: TextStyle(
                      fontFamily: 'Pretendard',
                      fontSize: Responsive.getFont(context, 14),
                      color: const Color(0xFFA4A4A4))),
              Text("${orderDetailInfoData?.order?.otCouponInfo?.ctPrice ?? cancelDetailData?.order?.otCouponInfo?.ctPrice ?? ""}",
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
                      "${Utils.getInstance().priceString(orderDetailInfoData?.order?.otUsePoint ?? cancelDetailData?.order?.otUsePoint ?? 0)}원",
                      context,
                    ),
                    Visibility(
                      visible: orderDetailData?.ctStats == 2 || orderDetailData?.ctStats == 3 ? false : true,
                      child: Container(
                        margin: const EdgeInsets.only(top: 15),
                        child: _buildInfoRow(
                          '배송비차감액',
                          "(-) ${Utils.getInstance().priceString((orderDetailInfoData?.order?.otDeliveryCharge ?? cancelDetailData?.order?.otDeliveryCharge ?? 0) + (orderDetailInfoData?.order?.otDeliveryChargeExtra ?? 0))}원",
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
                "${Utils.getInstance().priceString((orderDetailInfoData?.order?.otSprice ?? cancelDetailData?.order?.otSprice ?? 0) - ((orderDetailInfoData?.order?.otUseCoupon ?? cancelDetailData?.order?.otUseCoupon ?? 0) + (orderDetailInfoData?.order?.otUsePoint ?? cancelDetailData?.order?.otUsePoint ?? 0) + (orderDetailInfoData?.order?.otDeliveryCharge ?? cancelDetailData?.order?.otDeliveryCharge ?? 0) + (orderDetailInfoData?.order?.otDeliveryChargeExtra ?? cancelDetailData?.order?.otDeliveryChargeExtra ?? 0)))}원",
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
          child: _buildInfoRow('환불방법', cancelDetailData?.cancelDetailReturn?.octReturnType ?? "", context),
        ),
        Visibility(
          visible: cancelDetailData?.cancelIdx != null,
          child: Column(
            children: [
              Container(
                height: 10,
                width: double.infinity,
                color: const Color(0xFFF5F9F9),
              ),
              Container(
                padding: const EdgeInsets.symmetric(vertical: 15, horizontal: 16),
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
                        '수령인', cancelDetailData?.delivery?.otRname ?? "", context),
                    Container(
                      padding: const EdgeInsets.symmetric(vertical: 15),
                      child: _buildInfoRow('휴대폰번호',
                          cancelDetailData?.delivery?.otRtel ?? "", context),
                    ),
                    _buildAddressRow(
                        '주소',
                        "[${cancelDetailData?.delivery?.otRzip ?? ""}]${cancelDetailData?.delivery?.otRadd1 ?? ""}",
                        cancelDetailData?.delivery?.otRadd1 ?? "",
                        context),
                    Container(
                        padding: const EdgeInsets.only(top: 15),
                        child: _buildInfoRow('배송메모',
                            cancelDetailData?.delivery?.otRmemo1 ?? "", context)),
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
                padding: const EdgeInsets.symmetric(vertical: 15, horizontal: 16),
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
                        "${Utils.getInstance().priceString(cancelDetailData?.order?.otSprice ?? 0)}원",
                        context),
                    Container(
                        margin: const EdgeInsets.only(top: 15),
                        child: _buildInfoRow(
                            '총 배송비',
                            "${Utils.getInstance().priceString((cancelDetailData?.order?.otDeliveryCharge ?? 0) + (orderDetailInfoData?.order?.otDeliveryChargeExtra ?? 0))}원",
                            context)),
                    Visibility(
                      visible: userType == 1,
                      child: Container(
                        margin: const EdgeInsets.symmetric(vertical: 15),
                        child: Column(
                          children: [
                            _buildInfoRow(
                                '할인금액',
                                "${Utils.getInstance().priceString(cancelDetailData?.order?.otUseCoupon ?? 0)}원",
                                context),
                            widget,
                          ],
                        ),
                      ),
                    ),
                    Visibility(
                      visible: userType == 1,
                      child: _buildInfoRow(
                          '포인트할인',
                          '${Utils.getInstance().priceString(cancelDetailData?.order?.otUsePoint ?? 0)}원',
                          context),
                    ),
                    Container(
                      margin: const EdgeInsets.only(top: 20),
                      height: 10,
                      width: double.infinity,
                      color: const Color(0xFFF5F9F9),
                    ),
                    Container(
                      padding:
                      const EdgeInsets.symmetric(vertical: 15, horizontal: 16),
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
                            Text(cancelDetailData?.order?.otPayType ?? "",
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
          ),
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
    int result = (cancelDetailData?.order?.otSprice ?? 0) +
        (cancelDetailData?.order?.otDeliveryCharge ?? 0) +
        (cancelDetailData?.order?.otDeliveryChargeExtra ?? 0);

    // 할인금액 및 포인트 적용
    result = result -
        (cancelDetailData?.order?.otUsePoint ?? 0) -
        (cancelDetailData?.order?.otUseCoupon ?? 0);
    return result;
  }
}
