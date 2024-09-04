import 'package:BliU/screen/mypage/component/top/order_detail.dart';
import 'package:BliU/screen/mypage/component/top/order_item.dart';
import 'package:BliU/screen/mypage/component/top/order_item_button.dart';
import 'package:BliU/utils/responsive.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

class OrderListItem extends StatelessWidget {
  final String date;
  final String orderId;
  final List<Map<String, dynamic>> orders;

  const OrderListItem({
    Key? key,
    required this.date,
    required this.orderId,
    required this.orders,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 20),
      decoration: const BoxDecoration(
        color: Colors.white,
        border: Border(
          bottom: BorderSide(color: Color(0xFFEEEEEE)), // 구분선 추가
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // 상단 날짜, 주문번호, 주문 상세 버튼을 하나로 묶음
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.baseline,
                  textBaseline: TextBaseline.alphabetic,
                  children: [
                    Text(
                      date,
                      style: TextStyle(
                        color: Colors.black,
                        fontWeight: FontWeight.bold,
                        fontSize: Responsive.getFont(context, 16),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 10.0),
                      child: Text(
                        orderId,
                        style: TextStyle(
                          fontSize: Responsive.getFont(context, 14),
                          color: Color(0xFF7B7B7B),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              GestureDetector(
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => OrderDetail(
                          date: date, orderId: orderId, orders: orders),
                    ),
                  );
                },
                child: Row(
                  children: [
                    Text(
                      '주문상세',
                      style: TextStyle(
                        color: const Color(0xFFFF6192),
                        fontSize: Responsive.getFont(context, 14),
                      ),
                    ),
                    Container(
                      padding: const EdgeInsets.only(left: 2, top: 2),
                      child: SvgPicture.asset(
                        'assets/images/my/ic_link_p.svg',
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          // 같은 날짜의 주문들을 묶어서 표시
          Column(
            children: orders.map((order) {
              return OrderItem(order: order);
            }).toList(),
          ),
        ],
      ),
    );
  }
}
