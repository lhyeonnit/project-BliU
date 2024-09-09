import 'package:flutter/material.dart';
import '../../../utils/responsive.dart';

class PaymentMoney extends StatelessWidget {
  final List<Map<String, dynamic>> cartDetails;

  const PaymentMoney({super.key, required this.cartDetails});

  @override
  Widget build(BuildContext context) {
    // 선택된 항목들만 필터링하여 계산
    final Set<int> selectedStoreIds = {};

    final totalAmount = cartDetails.fold(0, (sum, item) => sum + (item['price'] as int) * (item['quantity'] as int));
    final shippingCost = cartDetails.where((item) => item['isSelected'] == true).fold(0, (sum, item) {
      if (!selectedStoreIds.contains(item['storeId'])) {
        selectedStoreIds.add(item['storeId']);
        return sum + (item['shippingCost'] as int);
      }
      return sum;
    });; // 예시 배송비
    final discount = 0; // 예시 할인금액
    final pointsDiscount = 0; // 포인트 할인
    final total = totalAmount+shippingCost-discount-pointsDiscount;

    return Container(
      margin: const EdgeInsets.only(top: 20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildInfoRow('상품 금액', '${totalAmount}원', context),
          _buildInfoRow('배송비', '${shippingCost}원', context),
          _buildInfoRow('할인금액', '${discount}원', context),
          _buildInfoRow('포인트할인', '${pointsDiscount}원', context),
          const Divider(
            color: Color(0xFFEEEEEE),
          ),
          _buildInfoRow('결제 금액', '${total}원', context),
        ],
      ),
    );
  }

  Widget _buildInfoRow(String title, String value, BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            title,
            style: TextStyle(
              fontSize: Responsive.getFont(context, 14),
              color: Colors.black,
            ),
          ),
          Text(
            value,
            style: TextStyle(
              fontSize: Responsive.getFont(context, 14),
              color: Colors.black,
            ),
          ),
        ],
      ),
    );
  }
}
