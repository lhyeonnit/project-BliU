import 'package:flutter/material.dart';

import '../../../../../utils/responsive.dart';
import 'order_item_button.dart';

class OrderItem extends StatelessWidget {
  final  Map<String, dynamic> order;
  final Map<String, dynamic> orderDetails; // 모든 정보를 포함한 맵

  const OrderItem({
    required this.order,
    required this.orderDetails,
  });
  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          margin: EdgeInsets.only(top: 15),
          child: Text(
            '${order['status']}',
            style: TextStyle(
              fontWeight: FontWeight.w600,
              color: Colors.black,
              fontSize: Responsive.getFont(context, 15),
            ),
          ),
        ),
        // 상품 정보
        Padding(
          padding: EdgeInsets.symmetric(vertical: 15.0),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // 상품 이미지
              Padding(
                padding: const EdgeInsets.only(right: 20.0),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(6.0),
                  child: Image.asset(
                    order['items'][0]['image'] ??
                        'assets/images/product/default.png',
                    width: 90,
                    height: 90,
                    fit: BoxFit.cover,
                  ),
                ),
              ),
              // 상품 정보 텍스트
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      order['items'][0]['store'] ?? "",
                      style: TextStyle(
                          fontSize: Responsive.getFont(context, 12),
                          color: Color(0xFF7B7B7B)),
                    ),
                    Padding(
                      padding: EdgeInsets.only(top: 4, bottom: 10),
                      child: Text(
                        order['items'][0]['name'] ?? "",
                        style: TextStyle(
                          fontSize: Responsive.getFont(context, 14),
                        ),
                        overflow: TextOverflow.ellipsis,
                        maxLines: 2,
                      ),
                    ),
                    Text(
                      order['items'][0]['size'] ?? "",
                      style: TextStyle(
                        fontSize: Responsive.getFont(context, 13),
                        color: Color(0xFF7B7B7B),
                      ),
                    ),
                    Padding(
                      padding: EdgeInsets.only(top: 15),
                      child: Text(
                        '${order['price']}원',
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
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
        // 상태에 따라 버튼 표시
        OrderItemButton(status: order['status'], date: order['date'], orderId: order['orderId'], orders: [order], orderDetails: orderDetails,),
      ],
    );
  }
}
