import 'package:BliU/data/cart_data.dart';
import 'package:BliU/data/cart_item_data.dart';
import 'package:BliU/data/coupon_data.dart';
import 'package:BliU/utils/responsive.dart';
import 'package:BliU/utils/utils.dart';
import 'package:flutter/material.dart';

class PaymentMoney extends StatelessWidget {
  final Function(int point) onResultTotalPrice;
  final List<CartData> cartList;
  final CouponData? discountCouponData;
  final int? discountPoint;

  const PaymentMoney(
      {super.key,
      required this.onResultTotalPrice,
      required this.cartList,
      this.discountCouponData,
      this.discountPoint});

  @override
  Widget build(BuildContext context) {
    // 선택된 항목들만 필터링하여 계산

    final totalAmount = _getTotalProductPrice();
    final shippingCost = _getTotalDeliveryPrice();

    int couponDiscount = 0;
    if (discountCouponData != null) {
      String couponDiscountStr = discountCouponData!.couponDiscount ?? "";
      int couponDiscountValue = discountCouponData!.couponPrice ?? 0;
      if (couponDiscountStr.contains("%")) {
        //할인율
        if (couponDiscountValue > 0) {
          double couponDiscountDouble = (couponDiscountValue / 100);
          couponDiscount = (totalAmount * couponDiscountDouble).toInt();
        }
      } else {
        couponDiscount = couponDiscountValue;
      }
    }
    final pointsDiscount = discountPoint ?? 0; // 포인트 할인
    final total = totalAmount + shippingCost - couponDiscount - pointsDiscount;

    onResultTotalPrice(total);

    return Container(
      margin: const EdgeInsets.symmetric(vertical: 20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildInfoRow('상품 금액',
              '${Utils.getInstance().priceString(totalAmount)}원', context),
          Container(
              margin: const EdgeInsets.symmetric(vertical: 15),
              child: _buildInfoRow(
                  '배송비',
                  '${Utils.getInstance().priceString(shippingCost)}원',
                  context)),
          Container(
              margin: const EdgeInsets.only(bottom: 15),
              child: _buildInfoRow(
                  '할인금액',
                  couponDiscount != 0
                      ? '- ${Utils.getInstance().priceString(couponDiscount)}원'
                      : '${Utils.getInstance().priceString(couponDiscount)}원', // 0이 아니면 '-' 추가
                  context)),
          _buildInfoRow(
              '포인트할인',
              pointsDiscount != 0
                  ? '- ${Utils.getInstance().priceString(pointsDiscount)}원'
                  : '${Utils.getInstance().priceString(pointsDiscount)}원', // 0이 아니면 '-' 추가
              context),
          Container(
            margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 20),
            child: const Divider(
              color: Color(0xFFEEEEEE),
            ),
          ),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  '결제 금액',
                  style: TextStyle(
                    fontFamily: 'Pretendard',
                    fontSize: Responsive.getFont(context, 14),
                    color: Colors.black,
                  ),
                ),
                Text(
                  '${Utils.getInstance().priceString(total)}원',
                  style: TextStyle(
                    fontFamily: 'Pretendard',
                    fontSize: Responsive.getFont(context, 14),
                    color: Colors.black,
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

  Widget _buildInfoRow(String title, String value, BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            title,
            style: TextStyle(
              fontFamily: 'Pretendard',
              fontSize: Responsive.getFont(context, 14),
              color: Colors.black,
            ),
          ),
          Text(
            value,
            style: TextStyle(
              fontFamily: 'Pretendard',
              fontSize: Responsive.getFont(context, 14),
              color: Colors.black,
            ),
          ),
        ],
      ),
    );
  }

  int _getTotalProductPrice() {
    // 선택된 기준으로 가격 가져오기
    int totalProductPrice = 0;
    for (var cartItem in cartList) {
      for (var product in cartItem.productList ?? [] as List<CartItemData>) {
        // if (product.isSelected) {
        //   totalProductPrice += ((product.ptPrice ?? 0) * (product.ptCount ?? 0));
        // }
        totalProductPrice += ((product.ptPrice ?? 0) * (product.ptCount ?? 0));
      }
    }
    return totalProductPrice;
  }

  int _getTotalDeliveryPrice() {
    int totalDeliveryPrice = 0;
    for (var cartItem in cartList) {
      //bool isAllCheck = true;
      // for(var product in cartItem.productList ?? [] as List<CartItemData>) {
      //   if (!product.isSelected) {
      //     isAllCheck = false;
      //   }
      // }
      // if (isAllCheck) {
      //   totalDeliveryPrice += cartItem.stDeliveryPrice ?? 0;
      // } else {
      //   for(var product in cartItem.productList ?? [] as List<CartItemData>) {
      //     // if (product.isSelected) {
      //     //   totalDeliveryPrice += product.ctDeliveryDefaultPrice ?? 0;
      //     // }
      //     totalDeliveryPrice += product.ctDeliveryDefaultPrice ?? 0;
      //   }
      // }
      totalDeliveryPrice += cartItem.stDeliveryPrice ?? 0;
    }
    return totalDeliveryPrice;
  }
}
