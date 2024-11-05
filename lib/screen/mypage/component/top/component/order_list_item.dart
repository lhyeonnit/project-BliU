import 'package:BliU/data/order_data.dart';
import 'package:BliU/data/order_detail_data.dart';
import 'package:BliU/screen/order_detail/order_detail_screen.dart';
import 'package:BliU/screen/mypage/component/top/component/order_item.dart';
import 'package:BliU/utils/responsive.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

class OrderListItem extends StatelessWidget {
  final OrderData orderData;
  final OrderDetailData detailList;

  const OrderListItem({super.key, required this.orderData, required this.detailList});

  @override
  Widget build(BuildContext context) {
    return Column(
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
                      detailList.otCode ?? "",
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
                    builder: (context) => OrderDetailScreen(orderData: orderData, detailList: detailList,),
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
        OrderItem(
          orderData: orderData,
          orderDetailData: detailList,
        ),
      ],
    );
  }
}
