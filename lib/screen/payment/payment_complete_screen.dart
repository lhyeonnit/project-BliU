import 'package:BliU/data/cart_data.dart';
import 'package:BliU/screen/_component/move_top_button.dart';
import 'package:BliU/screen/mypage/component/top/order_list_screen.dart';
import 'package:BliU/screen/payment/component/payment_order_item.dart';
import 'package:BliU/utils/responsive.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

class PaymentCompleteScreen extends StatefulWidget {
  final String? savedRecipientName; // 저장된 수령인 이름
  final String? savedRecipientPhone; // 저장된 전화번호
  final String? savedAddressRoad; // 저장된 도로명 주소
  final String? savedAddressDetail; // 저장된 상세주소
  final String? savedMemo; // 저장된 메모
  final List<CartData> cartDetails;

  const PaymentCompleteScreen({
    super.key,
    required this.cartDetails,
    required this.savedRecipientName,
    required this.savedRecipientPhone,
    required this.savedAddressRoad,
    required this.savedAddressDetail,
    required this.savedMemo,
  });

  @override
  State<PaymentCompleteScreen> createState() => _PaymentCompleteScreenState();
}

final ScrollController _scrollController = ScrollController();

class _PaymentCompleteScreenState extends State<PaymentCompleteScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        scrolledUnderElevation: 0,
        backgroundColor: Colors.white,
        automaticallyImplyLeading: false,
        // 기본 뒤로가기 버튼을 숨김
        title: const Text("주문완료"),
        titleTextStyle: TextStyle(
          fontSize: Responsive.getFont(context, 18),
          fontWeight: FontWeight.w600,
          color: Colors.black,
        ),
        actions: [
          GestureDetector(
            onTap: () {
              Navigator.of(context).pop();
              Navigator.of(context).pop();
              Navigator.of(context).pop();
            },
            child: Container(
                margin: EdgeInsets.only(right: 16),
                child: SvgPicture.asset('assets/images/product/ic_close.svg')),
          ),
        ],
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
            controller: _scrollController,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    margin: EdgeInsets.symmetric(vertical: 40, horizontal: 16),
                    child: Column(
                      children: [
                        Center(
                          child: Image.asset(
                              'assets/images/product/order_complet.png'),
                        ),
                        Center(
                          child: Padding(
                            padding:
                                const EdgeInsets.only(top: 25.0, bottom: 29.55),
                            child: Text('주문이 완료되었습니다!',
                                style: TextStyle(
                                    fontSize: Responsive.getFont(context, 18),
                                    fontWeight: FontWeight.bold)),
                          ),
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Expanded(
                              child: GestureDetector(
                                onTap: () {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) =>
                                            OrderListScreen()),
                                  );
                                },
                                child: Container(
                                  padding: EdgeInsets.symmetric(vertical: 14),
                                  margin: EdgeInsets.only(right: 4),
                                  decoration: BoxDecoration(
                                      borderRadius:
                                          BorderRadius.all(Radius.circular(6)),
                                      border:
                                          Border.all(color: Color(0xFFDDDDDD))),
                                  child: Center(
                                      child: Text(
                                    '주문상세보기',
                                    style: TextStyle(
                                        fontSize:
                                            Responsive.getFont(context, 14)),
                                  )),
                                ),
                              ),
                            ),
                            Expanded(
                              child: GestureDetector(
                                onTap: () {
                                  Navigator.of(context).pop();
                                  Navigator.of(context).pop();
                                  Navigator.of(context).pop();
                                },
                                child: Container(
                                  padding: EdgeInsets.symmetric(vertical: 14),
                                  margin: EdgeInsets.only(left: 4),
                                  decoration: BoxDecoration(
                                    color: Colors.black,
                                    borderRadius:
                                        BorderRadius.all(Radius.circular(6)),
                                  ),
                                  child: Center(
                                      child: Text(
                                    '계속 쇼핑하기',
                                    style: TextStyle(
                                        color: Colors.white,
                                        fontSize:
                                            Responsive.getFont(context, 14)),
                                  )),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                  Container(
                    height: 10,
                    width: double.infinity,
                    color: Color(0xFFF5F9F9),
                  ),
                  Container(
                    padding: EdgeInsets.symmetric(vertical: 20, horizontal: 16),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Container(
                          margin: EdgeInsets.only(right: 4),
                          child: Text(
                            '주문번호',
                            style: TextStyle(
                              fontSize: Responsive.getFont(context, 14),
                            ),
                          ),
                        ),
                        Text(
                          '1231234512312',
                          style: TextStyle(
                              fontSize: Responsive.getFont(context, 14),
                              fontWeight: FontWeight.bold),
                        ),
                      ],
                    ),
                  ),
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
                        Expanded(
                          flex: 6,
                          child: Text(
                            '결제 금액',
                            style: TextStyle(
                                fontSize: Responsive.getFont(context, 18),
                                fontWeight: FontWeight.bold),
                          ),
                        ),
                        Expanded(
                          flex: 4,
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.end,
                            children: [
                              Text(
                                '160,500원',
                                style: TextStyle(
                                    fontSize: Responsive.getFont(context, 14),
                                    fontWeight: FontWeight.bold),
                              ),
                              Container(
                                margin: EdgeInsets.only(left: 4),
                                child: Text(
                                  '네이버페이',
                                  style: TextStyle(
                                    fontSize: Responsive.getFont(context, 14),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                  Container(
                    padding: EdgeInsets.symmetric(horizontal: 16, vertical: 20),
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
                        _buildPaymentCompleteRow(
                            '총 상품 금액', 'productPrice', context),
                        Container(
                            margin: EdgeInsets.symmetric(vertical: 15),
                            child: _buildPaymentCompleteRow(
                                '총 배송비', 'productPrice', context)),
                        Divider(
                          color: Color(0xFFEEEEEE),
                        ),
                        Container(
                          margin: EdgeInsets.symmetric(vertical: 15),
                          child: Column(
                            children: [
                              _buildPaymentCompleteRow(
                                  '할인금액', 'productPrice', context),
                              Padding(
                                padding: const EdgeInsets.only(left: 10.0),
                                child: Container(
                                  margin: EdgeInsets.only(left: 10, top: 10),
                                  child: Row(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      Text('ㄴproductPrice',
                                          style: TextStyle(
                                              fontSize: Responsive.getFont(
                                                  context, 14),
                                              color: Color(0xFFA4A4A4))),
                                      Text('productPrice',
                                          style: TextStyle(
                                              fontSize: Responsive.getFont(
                                                  context, 14),
                                              color: Color(0xFFA4A4A4))),
                                    ],
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                        _buildPaymentCompleteRow(
                            '포인트할인', 'productPrice', context),
                      ],
                    ),
                  ),
                  Container(
                    height: 10,
                    width: double.infinity,
                    color: Color(0xFFF5F9F9),
                  ),
                  Container(
                    padding: EdgeInsets.symmetric(vertical: 20, horizontal: 16),
                    child: Text(
                      '배송지 정보',
                      style: TextStyle(
                          fontSize: Responsive.getFont(context, 18),
                          fontWeight: FontWeight.bold),
                    ),
                  ),
                  Container(
                    padding: EdgeInsets.symmetric(vertical: 20, horizontal: 16),
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
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Expanded(
                                flex: 6,
                                child: Text(
                                  '받는사람',
                                  style: TextStyle(
                                      fontSize:
                                          Responsive.getFont(context, 14)),
                                )),
                            Expanded(
                              flex: 4,
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.end,
                                children: [
                                  Text(
                                    '${widget.savedRecipientName}',
                                    style: TextStyle(
                                        fontSize:
                                            Responsive.getFont(context, 14),
                                        fontWeight: FontWeight.bold),
                                  ),
                                  Container(
                                      margin: EdgeInsets.only(left: 4),
                                      child: Text(
                                        '${widget.savedRecipientPhone}',
                                        style: TextStyle(
                                          fontSize:
                                              Responsive.getFont(context, 14),
                                        ),
                                      )),
                                ],
                              ),
                            ),
                          ],
                        ),
                        Container(
                          margin: EdgeInsets.only(top: 15),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Expanded(
                                  flex: 5,
                                  child: Text(
                                    '배송지 주소',
                                    style: TextStyle(
                                      fontSize: Responsive.getFont(context, 14),
                                    ),
                                  )),
                              Expanded(
                                flex: 5,
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.end,
                                  children: [
                                    Text(
                                      '${widget.savedAddressRoad}',
                                      style: TextStyle(
                                        fontSize:
                                            Responsive.getFont(context, 14),
                                      ),
                                    ),
                                    Text(
                                      '${widget.savedAddressDetail}',
                                      style: TextStyle(
                                        fontSize:
                                            Responsive.getFont(context, 14),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),
                        // 예시에서 productPrice를 배송메모로 가정하겠습니다.
                        if (widget.savedMemo != null && widget.savedMemo!.isNotEmpty)
                          Container(
                            padding: EdgeInsets.only(top: 15),
                            child: _buildPaymentCompleteRow(
                                '배송메모', '${widget.savedMemo}', context),
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
                        .copyWith(dividerColor: Colors.transparent),
                    child: ExpansionTile(
                      title: Container(
                        padding: const EdgeInsets.symmetric(vertical: 20),
                        child: Text(
                          '주문상품',
                          style: TextStyle(
                            fontSize: Responsive.getFont(context, 18),
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                      collapsedBackgroundColor: Colors.white,
                      backgroundColor: Colors.white,
                      children: [
                        Container(
                          decoration: BoxDecoration(
                            border: Border(
                              top: BorderSide(
                                color: Color(0xFFEEEEEE),
                              ),
                            ),
                          ),
                          child:
                              PaymentOrderItem(cartDetails: widget.cartDetails),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ],
          ),
          MoveTopButton(scrollController: _scrollController),
        ],
      ),
    );
  }

  Widget _buildPaymentCompleteRow(
      String title, String value, BuildContext context) {
    return Container(
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
