import 'dart:io';
import 'package:BliU/const/constant.dart';
import 'package:BliU/data/payment_data.dart';
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

  const PaymentScreen({required this.paymentData, super.key});

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
      body: SafeArea(
        child: Stack(
          children: [
            ListView(
              children: [
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
                          '확인',
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
      ),
    );
  }

  void paymentResultData(Map<String, dynamic> resultData) {
    Navigator.pop(context, resultData);
  }
}
