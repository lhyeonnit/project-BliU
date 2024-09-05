import 'package:BliU/screen/_component/move_top_button.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

import '../../../../../utils/responsive.dart';
import 'order_item.dart';

class OrderDetail extends StatefulWidget {
  final String date;
  final String orderId;
  final List<Map<String, dynamic>> orders;

  const OrderDetail({
    Key? key,
    required this.date,
    required this.orderId,
    required this.orders,
  }) : super(key: key);

  @override
  State<OrderDetail> createState() => _OrderDetailState();
}

final ScrollController _scrollController = ScrollController();

class _OrderDetailState extends State<OrderDetail> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        scrolledUnderElevation: 0,
        backgroundColor: Colors.white,
        title: const Text('주문상세'),
        titleTextStyle: TextStyle(
          fontSize: Responsive.getFont(context, 18),
          fontWeight: FontWeight.w600,
          color: Colors.black,
        ),
        leading: IconButton(
          icon: SvgPicture.asset("assets/images/store/ic_back.svg"),
          onPressed: () {
            Navigator.pop(context); // 뒤로가기 동작
          },
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
          SingleChildScrollView(
            controller: _scrollController,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // 주문 날짜 및 ID
                Container(
                  padding: EdgeInsets.only(left: 16, top: 20),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.baseline,
                    textBaseline: TextBaseline.alphabetic,
                    children: [
                      Text(
                        '${widget.date}',
                        style: TextStyle(
                            fontWeight: FontWeight.bold, fontSize: 16),
                      ),
                      Container(
                        padding: EdgeInsets.symmetric(horizontal: 10),
                        child: Text(
                          '${widget.orderId}',
                          style: TextStyle(
                            fontSize: Responsive.getFont(context, 14),
                            color: Color(0xFF7B7B7B),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                // 주문 아이템 리스트
                Container(
                  padding: EdgeInsets.symmetric(horizontal: 16),
                  child: Column(
                    children: widget.orders.map((order) {
                      return OrderItem(order: order);
                    }).toList(),
                  ),
                ),
                // 구분선
                Container(
                  padding: EdgeInsets.only(top: 15),
                  child: const Divider(
                    color: Color(0xFFEEEEEE),
                  ),
                ),
                // 배송비 정보
                Padding(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 16, vertical: 20),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text('배송비',
                          style: TextStyle(
                              fontSize: Responsive.getFont(context, 14),
                              color: Colors.black)),
                      Text('0원',
                          style: TextStyle(
                              fontSize: Responsive.getFont(context, 14),
                              color: Colors.black)),
                    ],
                  ),
                ),
                // 빈 공간
                Container(
                  height: 10,
                  width: double.infinity,
                  color: Color(0xFFF5F9F9),
                ),
                // 배송지 정보
                Container(
                  padding: EdgeInsets.symmetric(vertical: 20, horizontal: 16),
                  child: Text(
                    '배송지 정보',
                    style: TextStyle(
                        fontSize: Responsive.getFont(context, 18),
                        fontWeight: FontWeight.bold),
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
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Container(
                        padding: EdgeInsets.symmetric(horizontal: 16),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text('수령인',
                                style: TextStyle(
                                    fontSize: Responsive.getFont(context, 14),
                                    color: Colors.black)),
                            Text('김크루',
                                style: TextStyle(
                                    fontSize: Responsive.getFont(context, 14),
                                    color: Colors.black)),
                          ],
                        ),
                      ),
                      Container(
                        padding:
                            EdgeInsets.symmetric(horizontal: 16, vertical: 15),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text('휴대폰번호',
                                style: TextStyle(
                                    fontSize: Responsive.getFont(context, 14),
                                    color: Colors.black)),
                            Text('01012345678',
                                style: TextStyle(
                                    fontSize: Responsive.getFont(context, 14),
                                    color: Colors.black)),
                          ],
                        ),
                      ),
                      Container(
                        padding: EdgeInsets.symmetric(horizontal: 16),
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text('주소',
                                style: TextStyle(
                                    fontSize: Responsive.getFont(context, 14),
                                    color: Colors.black)),
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.end,
                              children: [
                                Text('[66666]서울특별시 강남구 테헤란로 114',
                                    style: TextStyle(
                                        fontSize:
                                            Responsive.getFont(context, 14),
                                        color: Colors.black)),
                                Text('크루온니아파트 101동 777호',
                                    style: TextStyle(
                                        fontSize:
                                            Responsive.getFont(context, 14),
                                        color: Colors.black)),
                              ],
                            ),
                          ],
                        ),
                      ),
                      Container(
                        padding: EdgeInsets.symmetric(horizontal: 16),
                        margin: EdgeInsets.only(top: 15),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text('배송메모',
                                style: TextStyle(
                                    fontSize: Responsive.getFont(context, 14),
                                    color: Colors.black)),
                            Text('배송메모입니다.',
                                style: TextStyle(
                                    fontSize: Responsive.getFont(context, 14),
                                    color: Colors.black)),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
                // 빈 공간
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
                      Text(
                        '결제 금액',
                        style: TextStyle(
                            fontSize: Responsive.getFont(context, 18),
                            fontWeight: FontWeight.bold),
                      ),
                      Text(
                        '160,500원',
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
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Container(
                        padding: EdgeInsets.symmetric(horizontal: 16),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text('총 상품 금액',
                                style: TextStyle(
                                    fontSize: Responsive.getFont(context, 14),
                                    color: Colors.black)),
                            Text('100,400원',
                                style: TextStyle(
                                    fontSize: Responsive.getFont(context, 14),
                                    color: Colors.black)),
                          ],
                        ),
                      ),
                      Container(
                        padding:
                            EdgeInsets.symmetric(horizontal: 16, vertical: 15),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text('총 배송비',
                                style: TextStyle(
                                    fontSize: Responsive.getFont(context, 14),
                                    color: Colors.black)),
                            Text('2,500원',
                                style: TextStyle(
                                    fontSize: Responsive.getFont(context, 14),
                                    color: Colors.black)),
                          ],
                        ),
                      ),
                      Container(
                        padding: EdgeInsets.symmetric(horizontal: 16),
                        child: Column(
                          children: [
                            Row(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text('할인금액',
                                    style: TextStyle(
                                        fontSize: Responsive.getFont(context, 14),
                                        color: Colors.black)),
                                Text('(-)3,000원',
                                    style: TextStyle(
                                        fontSize: Responsive.getFont(context, 14),
                                        color: Colors.black)),
                              ],
                            ),
                            Row(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text('할인금액',
                                    style: TextStyle(
                                        fontSize: Responsive.getFont(context, 14),
                                        color: Colors.black)),
                                Text('(-)3,000원',
                                    style: TextStyle(
                                        fontSize: Responsive.getFont(context, 14),
                                        color: Colors.black)),
                              ],
                            ),
                          ],
                        ),
                      ),
                      Container(
                        padding: EdgeInsets.symmetric(horizontal: 16),
                        margin: EdgeInsets.only(top: 15),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text('배송메모',
                                style: TextStyle(
                                    fontSize: Responsive.getFont(context, 14),
                                    color: Colors.black)),
                            Text('배송메모입니다.',
                                style: TextStyle(
                                    fontSize: Responsive.getFont(context, 14),
                                    color: Colors.black)),
                          ],
                        ),
                      ),
                      Container(
                        margin: EdgeInsets.only(top: 20),
                        height: 10,
                        width: double.infinity,
                        color: Color(0xFFF5F9F9),
                      ),
                      Container(
                        padding:
                            EdgeInsets.symmetric(vertical: 20, horizontal: 16),
                        child: Text(
                          '결제 수단',
                          style: TextStyle(
                              fontSize: Responsive.getFont(context, 18),
                              fontWeight: FontWeight.bold),
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
                        child: Padding(
                          padding: const EdgeInsets.only(
                              right: 16.0, left: 16, bottom: 30),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text('수령인',
                                  style: TextStyle(
                                      fontSize: Responsive.getFont(context, 14),
                                      color: Colors.black)),
                              Text('김크루',
                                  style: TextStyle(
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
          MoveTopButton(scrollController: _scrollController),
        ],
      ),
    );
  }
}
