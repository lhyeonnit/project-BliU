import 'package:BliU/data/order_data.dart';
import 'package:BliU/screen/mypage/component/top/component/order_detail.dart';
import 'package:BliU/screen/mypage/component/top/component/order_item.dart';
import 'package:BliU/utils/responsive.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

class OrderListItem extends StatelessWidget {
  final OrderData orderData;
  final int count;

  const OrderListItem({super.key, required this.orderData, required this.count});

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
                      orderData.ctWdate ?? "",
                      style: TextStyle(
                        fontFamily: 'Pretendard',
                        color: Colors.black,
                        fontWeight: FontWeight.bold,
                        fontSize: Responsive.getFont(context, 16),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 10.0),
                      child: Text(
                        orderData.detailList?[0].otCode ?? "",
                        style: TextStyle(
                          fontFamily: 'Pretendard',
                          fontSize: Responsive.getFont(context, 14),
                          color: const Color(0xFF7B7B7B),
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
                      builder: (context) => OrderDetail(orderData: orderData, count: count,),
                    ),
                  );
                },
                child: Row(
                  children: [
                    Text(
                      '주문상세',
                      style: TextStyle(
                        fontFamily: 'Pretendard',
                        color: const Color(0xFFFF6192),
                        fontSize: Responsive.getFont(context, 14),
                      ),
                    ),
                    Container(
                      padding: const EdgeInsets.only(left: 2, top: 2),
                      child: SvgPicture.asset('assets/images/my/ic_link_p.svg'),
                    ),
                  ],
                ),
              ),
            ],
          ),
          // 같은 날짜의 주문들을 묶어서 표시
          Column(
            children: (orderData.detailList ?? []).map((orderDetailData) {
              return OrderItem(
                orderData: orderData,
                orderDetailData: orderDetailData,
              );
            }).toList(),
          ),
        ],
      ),
    );
  }
}
