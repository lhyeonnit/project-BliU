import 'package:BliU/screen/_component/move_top_button.dart';
import 'package:BliU/screen/mypage/component/top/component/order_detail_item.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

import '../../../../../utils/responsive.dart';
import 'order_item.dart';

class OrderDetail extends StatefulWidget {
  final String date;
  final String orderId;
  final List<Map<String, dynamic>> orders;
  final Map<String, dynamic> orderDetails; // 모든 정보를 포함한 맵

  const OrderDetail({
    Key? key,
    required this.date,
    required this.orderId,
    required this.orders,
    required this.orderDetails,
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
                      return OrderItem(order: order, orderDetails: widget.orderDetails,);
                    }).toList(),
                  ),
                ),
                // 배송비 정보
                Container(
                  margin: EdgeInsets.only(top: 20),
                  padding:
                      const EdgeInsets.symmetric(horizontal: 16, vertical: 20),
                  decoration: BoxDecoration(
                    border: Border(
                      top: BorderSide(
                        color: Color(0xFFEEEEEE),
                      ),
                    ),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text('배송비',
                          style: TextStyle(
                              fontSize: Responsive.getFont(context, 14),
                              color: Colors.black)),
                      Text('${widget.orderDetails['deliveryCost']}',
                          style: TextStyle(
                              fontSize: Responsive.getFont(context, 14),
                              color: Colors.black)),
                    ],
                  ),
                ),
                OrderDetailItem(orderDetails: widget.orderDetails,),
              ],
            ),
          ),
          MoveTopButton(scrollController: _scrollController),
        ],
      ),
    );
  }
}
