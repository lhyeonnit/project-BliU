import 'dart:io';
import 'package:BliU/const/constant.dart';
import 'package:BliU/data/payment_data.dart';
import 'package:BliU/screen/payment/component/payment_address_info.dart';
import 'package:BliU/screen/payment/component/payment_order_item.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:tosspayments_widget_sdk_flutter/model/payment_info.dart';
import 'package:tosspayments_widget_sdk_flutter/model/payment_widget_options.dart';
import 'package:tosspayments_widget_sdk_flutter/payment_widget.dart';
import 'package:tosspayments_widget_sdk_flutter/widgets/agreement.dart';
import 'package:tosspayments_widget_sdk_flutter/widgets/payment_method.dart';

import '../../utils/responsive.dart';
import '../_component/move_top_button.dart';

//결제하기
class PaymentScreen extends StatefulWidget {
  final PaymentData paymentData;
  final List<Map<String, dynamic>> cartDetails;

  const PaymentScreen(
      {required this.paymentData, required this.cartDetails, super.key});

  @override
  State<PaymentScreen> createState() => PaymentScreenState();
}

class PaymentScreenState extends State<PaymentScreen> {
  late PaymentWidget _paymentWidget;
  final ScrollController _scrollController = ScrollController();

  PaymentData get paymentData => widget.paymentData;

  @override
  void initState() {
    super.initState();

    _paymentWidget = PaymentWidget(
      clientKey: Constant.TOSS_CLIENT_KEY,
      customerKey: paymentData.customerKey,
    );

    _paymentWidget.renderPaymentMethods(
        selector: 'methods',
        amount: Amount(
            value: paymentData.amount, currency: Currency.KRW, country: "KR"),
        options: RenderPaymentMethodsOptions(variantKey: "DEFAULT"));

    _paymentWidget.renderAgreement(selector: 'agreement');
  }

  @override
  Widget build(BuildContext context) {
    Map<int, List<Map<String, dynamic>>> storeGroupedItems = {};
    for (var item in widget.cartDetails) {
      int storeId = item['storeId'];
      if (!storeGroupedItems.containsKey(storeId)) {
        storeGroupedItems[storeId] = [];
      }
      storeGroupedItems[storeId]!.add(item);
    }
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        scrolledUnderElevation: 0,
        backgroundColor: Colors.white,
        leading: IconButton(
          icon: SvgPicture.asset("assets/images/exhibition/ic_back.svg"),
          onPressed: () {
            Navigator.pop(context); // 뒤로가기 동작
          },
        ),
        title: const Text("결제하기"),
        titleTextStyle: TextStyle(
          fontSize: Responsive.getFont(context, 18),
          fontWeight: FontWeight.w600,
          color: Colors.black,
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
      body: Stack(
        children: [
          ListView(
            children: [
              Theme(
                data: Theme.of(context)
                    .copyWith(dividerColor: Colors.transparent), // 선 제거
                child: ExpansionTile(
                  title: Container(
                    padding: const EdgeInsets.symmetric(vertical: 20),
                    child: Text(
                      '주문상품',
                      style: TextStyle(
                          fontSize: Responsive.getFont(context, 18),
                          fontWeight: FontWeight.bold),
                    ),
                  ),
                  collapsedBackgroundColor: Colors.white, // 펼쳐지기 전 배경
                  backgroundColor: Colors.white, // 펼쳐진 후 배경
                  children: [
                    Container(
                      decoration: BoxDecoration(
                        border: Border(
                          top: BorderSide(
                            color: Color(0xFFEEEEEE),
                          ),
                        ),
                      ),
                      child: Column(
                        children: [
                          // 장바구니 항목들
                          ...storeGroupedItems.entries.map((entry) {
                            int storeId = entry.key;
                            List<Map<String, dynamic>> items = entry.value;

                            // 마지막 스토어인지 확인
                            bool isLastStore =
                                storeGroupedItems.entries.last.key == storeId;

                            return Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                // 스토어명
                                Container(
                                  margin: const EdgeInsets.only(
                                      right: 16, left: 16, bottom: 10, top: 20),
                                  height: 40,
                                  child: Row(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Container(
                                        height: 40,
                                        width: 40,
                                        decoration: BoxDecoration(
                                          borderRadius: const BorderRadius.all(
                                              Radius.circular(20)),
                                          border: Border.all(
                                            color: const Color(0xFFDDDDDD),
                                            width: 1.0,
                                          ),
                                        ),
                                        child: ClipRRect(
                                          borderRadius: const BorderRadius.all(
                                              Radius.circular(20)),
                                          child: Image.asset(
                                            items.first['storeLogo'],
                                            fit: BoxFit.contain,
                                          ),
                                        ),
                                      ),
                                      Container(
                                        padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 10),
                                        child: Text(
                                          items.first['storeName'],
                                          style: TextStyle(
                                            fontSize:
                                                Responsive.getFont(context, 14),
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                                // 각 스토어의 선택된 상품들만 전달
                                Column(
                                  children: items
                                      .where((item) =>
                                          item['isSelected'] ==
                                          true) // 선택된 항목만 필터링
                                      .map((item) {
                                    return PaymentOrderItem(
                                      item: item, // 선택된 항목을 하나씩 전달
                                    );
                                  }).toList(),
                                ),
                                if (!isLastStore)
                                  const Divider(
                                      thickness: 1, color: Color(0xFFEEEEEE)),
                              ],
                            );
                          }).toList(),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              Container(
                height: 10,
                width: double.infinity,
                color: Color(0xFFF5F9F9),
              ),
              Theme(
                data: Theme.of(context)
                    .copyWith(dividerColor: Colors.transparent), // 선 제거
                child: ExpansionTile(
                  title: Container(
                    padding: const EdgeInsets.symmetric(vertical: 20),
                    child: Text(
                      '배송지 정보',
                      style: TextStyle(
                          fontSize: Responsive.getFont(context, 18),
                          fontWeight: FontWeight.bold),
                    ),
                  ),
                  collapsedBackgroundColor: Colors.white, // 펼쳐지기 전 배경
                  backgroundColor: Colors.white, // 펼쳐진 후 배경
                  children: [
                    Container(
                      decoration: BoxDecoration(
                        border: Border(
                          top: BorderSide(
                            color: Color(0xFFEEEEEE),
                          ),
                        ),
                      ),
                      child: PaymentAddressInfo(),
                    ),
                  ],
                ),
              ),
              Container(
                height: 10,
                width: double.infinity,
                color: Color(0xFFF5F9F9),
              ),
              PaymentMethodWidget(
                paymentWidget: _paymentWidget,
                selector: 'methods',
              ),
              AgreementWidget(
                  paymentWidget: _paymentWidget, selector: 'agreement'),
            ],
          ),
          Positioned(
            bottom: 0,
            left: 0,
            right: 0,
            child: Column(
              children: [
                MoveTopButton(scrollController: _scrollController),
                Container(
                  width: double.infinity,
                  height: Responsive.getHeight(context, 48),
                  margin:
                      EdgeInsets.only(right: 16.0, left: 16, top: 8, bottom: 9),
                  decoration: BoxDecoration(
                    color: Colors.black,
                    borderRadius: BorderRadius.all(
                      Radius.circular(6),
                    ),
                  ),
                  child: GestureDetector(
                    onTap: () async {
                      final paymentResult = await _paymentWidget.requestPayment(
                          paymentInfo: PaymentInfo(
                        orderId: paymentData.orderId,
                        orderName: paymentData.orderName,
                        taxFreeAmount: paymentData.taxFreeAmount,
                        customerName: paymentData.customerName,
                        appScheme: Platform.isIOS ? 'bliuApp://' : null,
                      ));

                      if (paymentResult.success != null) {
                        // 결제 성공 처리
                        var resultData = <String, dynamic>{};
                        resultData['result'] = true;
                        resultData['successData'] = paymentResult.success;

                        paymentResultData(resultData);
                      } else if (paymentResult.fail != null) {
                        // 결제 실패 처리
                        var resultData = <String, dynamic>{};
                        resultData['result'] = false;
                        resultData['errorMessage'] =
                            paymentResult.fail?.errorMessage;

                        paymentResultData(resultData);
                      }
                    },
                    child: Center(
                      child: Text(
                        '결제하기',
                        style: TextStyle(
                          fontSize: Responsive.getFont(context, 14),
                          color: Colors.white,
                        ),
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

  void paymentResultData(Map<String, dynamic> resultData) {
    Navigator.pop(context, resultData);
  }
}
