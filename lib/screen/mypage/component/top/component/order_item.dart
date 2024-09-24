import 'package:BliU/data/order_detail_data.dart';
import 'package:BliU/screen/mypage/component/top/component/order_item_button.dart';
import 'package:BliU/utils/responsive.dart';
import 'package:BliU/utils/utils.dart';
import 'package:flutter/material.dart';

class OrderItem extends StatelessWidget {
  final OrderDetailData orderDetailData;

  const OrderItem({super.key, required this.orderDetailData,});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          margin: const EdgeInsets.only(top: 15),
          child: Text(
            orderDetailData.ctStatusTxt ?? "",
            style: TextStyle(
              fontWeight: FontWeight.w600,
              color: Colors.black,
              fontSize: Responsive.getFont(context, 15),
            ),
          ),
        ),
        // 상품 정보
        Padding(
          padding: const EdgeInsets.symmetric(vertical: 15.0),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // 상품 이미지
              Padding(
                padding: const EdgeInsets.only(right: 20.0),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(6.0),
                  child: Image.network(
                    orderDetailData.ptImg ?? "",
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
                      // order['items'][0]['store'] ?? "",
                      orderDetailData.stName ?? "",
                      style: TextStyle(
                          fontSize: Responsive.getFont(context, 12),
                          color: const Color(0xFF7B7B7B)),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(top: 4, bottom: 10),
                      child: Text(
                        orderDetailData.ptName ?? "",
                        style: TextStyle(
                          fontSize: Responsive.getFont(context, 14),
                        ),
                        overflow: TextOverflow.ellipsis,
                        maxLines: 2,
                      ),
                    ),
                    Text(
                      "${orderDetailData.ctOptValue} ${orderDetailData.ctOptQty}개",
                      style: TextStyle(
                        fontSize: Responsive.getFont(context, 13),
                        color: const Color(0xFF7B7B7B),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(top: 15),
                      child: Text(
                        "${Utils.getInstance().priceString(orderDetailData.ptPrice ?? 0)}원",
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
        OrderItemButton(orderDetailData: orderDetailData,),
      ],
    );
  }
}
