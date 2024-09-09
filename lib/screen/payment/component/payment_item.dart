import 'package:BliU/utils/responsive.dart';
import 'package:flutter/material.dart';

class PaymentItem extends StatelessWidget {
  final Map<String, dynamic> item; // 단일 아이템을 받도록 변경

  const PaymentItem({
    super.key,
    required this.item,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 16.0),
      child: Row(
        children: [
          Container(
            width: 90,
            height: 90,
            decoration: const BoxDecoration(
              borderRadius: BorderRadius.all(Radius.circular(6)),
            ),
            child: Image.asset(
              'assets/images/home/exhi.png', // 실제 이미지 경로로 변경
              fit: BoxFit.contain,
            ),
          ),
          SizedBox(width: Responsive.getWidth(context, 20)),
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
                const SizedBox(height: 10),
                Row(
                  children: [
                    Text(
                      item['item'], // 아이템 설명
                      style: TextStyle(
                        fontSize: Responsive.getFont(context, 13),
                        color: const Color(0xFF7B7B7B),
                      ),
                    ),
                    const SizedBox(width: 10),
                    Text(
                      '${item['quantity']}개', // 수량
                      style: TextStyle(
                        fontSize: Responsive.getFont(context, 13),
                        color: const Color(0xFF7B7B7B),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 10),
                Text(
                  '${item['price']}원', // 가격 정보
                  style: const TextStyle(
                    fontSize: 16.0,
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
