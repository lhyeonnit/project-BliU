import 'package:BliU/data/change_order_detail_data.dart';
import 'package:BliU/data/order_data.dart';
import 'package:BliU/data/order_detail_data.dart';
import 'package:BliU/screen/mypage/component/top/component/order_item_button.dart';
import 'package:BliU/utils/responsive.dart';
import 'package:BliU/utils/utils.dart';
import 'package:flutter/material.dart';

class OrderItem extends StatelessWidget {
  final OrderData orderData;
  final OrderDetailData orderDetailData;
  final ChangeOrderDetailData? changeOrderDetailData;

  const OrderItem({super.key, required this.orderData, required this.orderDetailData, this.changeOrderDetailData});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          margin: const EdgeInsets.only(top: 10),
          child: Row(
            children: [
              Container(
                margin: const EdgeInsets.only(right: 7),
                child: Text(
                  orderDetailData.ctStatusTxt ?? "",
                  style: TextStyle(
                    fontFamily: 'Pretendard',
                    fontWeight: FontWeight.w600,
                    color: Colors.black,
                    fontSize: Responsive.getFont(context, 15),
                  ),
                ),
              ),
              Text(
                changeOrderDetailData?.octCancelMemo2 ?? changeOrderDetailData?.ortReturnMemo2 ?? "",
                style: TextStyle(
                  fontFamily: 'Pretendard',
                  color: Colors.black,
                  fontSize: Responsive.getFont(context, 15),
                ),
              ),
            ],
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
                    errorBuilder: (BuildContext context, Object exception, StackTrace? stackTrace) {
                      return const SizedBox();
                    }
                  ),
                ),
              ),
              // 상품 정보 텍스트
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      orderDetailData.stName ?? "",
                      style: TextStyle(
                        fontFamily: 'Pretendard',
                        fontSize: Responsive.getFont(context, 12),
                        color: const Color(0xFF7B7B7B)
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(top: 4, bottom: 8),
                      child: Text(
                        orderDetailData.ptName ?? "",
                        style: TextStyle(
                          fontFamily: 'Pretendard',
                          fontSize: Responsive.getFont(context, 14),
                        ),
                        overflow: TextOverflow.ellipsis,
                        maxLines: 2,
                      ),
                    ),
                    Text(
                      "${orderDetailData.ctOptValue} ${orderDetailData.ctOptQty}개",
                      style: TextStyle(
                        fontFamily: 'Pretendard',
                        fontSize: Responsive.getFont(context, 13),
                        color: const Color(0xFF7B7B7B),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(top: 10),
                      child: Text(
                        "${Utils.getInstance().priceString(orderDetailData.ptPrice ?? 0)}원",
                        style: TextStyle(
                          fontFamily: 'Pretendard',
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
        OrderItemButton(
          orderData: orderData,
          orderDetailData: orderDetailData,
        ),
      ],
    );
  }
}
