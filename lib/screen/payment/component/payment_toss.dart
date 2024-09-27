import 'dart:io';
import 'package:BliU/const/constant.dart';
import 'package:BliU/data/payment_data.dart';
import 'package:flutter/material.dart';
import 'package:tosspayments_widget_sdk_flutter/model/payment_info.dart';
import 'package:tosspayments_widget_sdk_flutter/model/payment_widget_options.dart';
import 'package:tosspayments_widget_sdk_flutter/payment_widget.dart';
import 'package:tosspayments_widget_sdk_flutter/widgets/agreement.dart';
import 'package:tosspayments_widget_sdk_flutter/widgets/payment_method.dart';

//결제하기
class PaymentToss extends StatefulWidget {
  final PaymentData paymentData;

  const PaymentToss({required this.paymentData, super.key});

  @override
  State<PaymentToss> createState() => PaymentTossState();
}

class PaymentTossState extends State<PaymentToss> {
  late PaymentWidget _paymentWidget;

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
          title: const Text('결제'),
          centerTitle: true,
          titleTextStyle: const TextStyle(
            fontFamily: 'Pretendard',
            fontSize: 20,
            color: Colors.black,
            height: 1.2,
          ),
          leading: IconButton(
            icon: const Icon(Icons.arrow_back, size: 25),
            onPressed: () {
              Navigator.pop(context, null); // 뒤로가기 동작
            },
          ),
        ),
        body: SafeArea(
            child: Column(children: [
          Expanded(
              child: ListView(children: [
            PaymentMethodWidget(
              paymentWidget: _paymentWidget,
              selector: 'methods',
            ),
            AgreementWidget(
                paymentWidget: _paymentWidget, selector: 'agreement'),
            Container(
              margin: const EdgeInsets.all(20),
              child: TextButton(
                  onPressed: () async {
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
                  style: TextButton.styleFrom(
                      backgroundColor: const Color(0xff7C001D),
                      shape: const RoundedRectangleBorder(
                          borderRadius:
                              BorderRadius.all(Radius.circular(100)))),
                  child: const Text(
                    '결제하기',
                    style: TextStyle(
                      fontFamily: 'Pretendard',
                      color: Colors.white,
                      height: 1.2,
                    ),
                  )
              ),
            ),
          ]))
        ])));
  }

  void paymentResultData(Map<String, dynamic> resultData) {
    Navigator.pop(context, resultData);
  }
}
