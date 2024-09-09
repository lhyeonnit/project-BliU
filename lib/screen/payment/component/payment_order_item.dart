import 'package:BliU/utils/responsive.dart';
import 'package:flutter/material.dart';

class PaymentOrderItem extends StatelessWidget {
  final Map<String, dynamic> item; // 단일 아이템을 받도록 변경

  const PaymentOrderItem({
    super.key,
    required this.item,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(bottom: 20),
      padding: const EdgeInsets.symmetric(horizontal: 16.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: 90,
            height: 90,
            margin: EdgeInsets.only(right: 20),
            decoration: const BoxDecoration(
              borderRadius: BorderRadius.all(Radius.circular(6)),
            ),
            child: ClipRRect(
              borderRadius: const BorderRadius.all(Radius.circular(6)),
              child: Image.asset(
                'assets/images/home/exhi.png', // 실제 이미지 경로로 변경
                fit: BoxFit.cover,
              ),
            ),
          ),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  '${item['productName']}', // 상품 이름
                  style: TextStyle(
                    fontSize: Responsive.getFont(context, 14),
                    color: Colors.black,
                  ),
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
                Container(
                  margin: EdgeInsets.only(top: 10,bottom: 15),
                  child: Row(
                    children: [
                      Text(
                        item['item'], // 아이템 설명
                        style: TextStyle(
                          fontSize: Responsive.getFont(context, 13),
                          color: const Color(0xFF7B7B7B),
                        ),
                      ),
                      Text(
                        '${item['quantity']}개', // 수량
                        style: TextStyle(
                          fontSize: Responsive.getFont(context, 13),
                          color: const Color(0xFF7B7B7B),
                        ),
                      ),
                    ],
                  ),
                ),
                Text(
                  '${item['price']}원', // 가격 정보
                  style: TextStyle(
                    fontSize: Responsive.getFont(context, 16),
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
