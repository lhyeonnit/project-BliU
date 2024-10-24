import 'package:BliU/const/constant.dart';
import 'package:BliU/data/iamport_pay_data.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:iamport_flutter/iamport_payment.dart';
import 'package:iamport_flutter/model/payment_data.dart';

class PaymentIamport extends StatelessWidget {
  final IamportPayData iamportPayData;

  const PaymentIamport({required this.iamportPayData, super.key});

  @override
  Widget build(BuildContext context) {

    return IamportPayment(
      appBar: AppBar(
        title: const Text('결제'),
        centerTitle: true,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios),
          onPressed: () {
            Navigator.pop(context, null);
          },
        ),
      ),
      /* 웹뷰 로딩 컴포넌트 */
      initialChild: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Image.asset('assets/images/iamport-logo.png'),
            const Padding(padding: EdgeInsets.symmetric(vertical: 15)),
            const Text('잠시만 기다려주세요...', style: TextStyle(fontSize: 20)),
          ],
        ),
      ),
      /* [필수입력] 가맹점 식별코드 */
      userCode: Constant.iamportUserCode,
      /* [필수입력] 결제 데이터 */
      data: PaymentData(
        pg: Constant.iamportPg, // PG사
        payMethod: iamportPayData.payMethod, // 결제수단
        digital: true,
        name: iamportPayData.name, // 주문명
        merchantUid: iamportPayData.merchantUid, // 주문번호
        amount: iamportPayData.amount, // 결제금액
        buyerName: iamportPayData.name, // 구매자 이름
        buyerTel: iamportPayData.buyerTel ?? '', // 구매자 연락처
        buyerEmail: iamportPayData.buyerEmail ?? '', // 구매자 이메일
        buyerAddr: iamportPayData.buyerAddr, // 구매자 주소
        buyerPostcode: iamportPayData.buyerPostcode, // 구매자 우편번호
        appScheme: 'bliuApp', // 앱 URL scheme
        //cardQuota : [2,3] //결제창 UI 내 할부개월수 제한
      ),
      /* [필수입력] 콜백 함수 */
      callback: (Map<String, String> result) {
        if (kDebugMode) {
          print("result $result");
        }
        Navigator.pop(context, result);
      },
    );
  }
}