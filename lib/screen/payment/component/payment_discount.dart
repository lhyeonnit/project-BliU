import 'dart:convert';

import 'package:BliU/data/cart_data.dart';
import 'package:BliU/data/cart_item_data.dart';
import 'package:BliU/data/coupon_data.dart';
import 'package:BliU/screen/payment/component/payment_coupon.dart';
import 'package:BliU/screen/payment/viewmodel/payment_discount_view_model.dart';
import 'package:BliU/utils/responsive.dart';
import 'package:BliU/utils/shared_preferences_manager.dart';
import 'package:BliU/utils/utils.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_svg/flutter_svg.dart';

class PaymentDiscount extends ConsumerStatefulWidget {
  final Function(CouponData couponData) onCouponSelected; // 선택된 쿠폰 할인율을 전달할 콜백
  final Function(int point) onPointChanged;
  final List<CartData> cartList;

  const PaymentDiscount({
    super.key,
    required this.onCouponSelected,
    required this.onPointChanged,
    required this.cartList,
  });

  @override
  ConsumerState<PaymentDiscount> createState() => PaymentDiscountState();
}

class PaymentDiscountState extends ConsumerState<PaymentDiscount> {
  final TextEditingController _pointController = TextEditingController();
  String _couponText = "0원 할인 적용";
  List<CouponData> _couponList = [];
  int _point = 0;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _afterBuild(context);
    });
  }

  void _afterBuild(BuildContext context) {
    _getMy();
    _getOrderCoupon();
  }

  void _getMy() async {
    final pref = await SharedPreferencesManager.getInstance();
    Map<String, dynamic> requestData = {
      'mt_idx': pref.getMtIdx(),
    };

    final memberInfoResponseDTO = await ref.read(paymentDiscountViewModelProvider.notifier).getMy(requestData);
    setState(() {
      _point = memberInfoResponseDTO?.data?.myPoint ?? 0;
    });
  }

  void _getOrderCoupon() async {
    final pref = await SharedPreferencesManager.getInstance();

    List<Map<String, dynamic>> storeArr = [];
    for (var cartItem in widget.cartList) {
      Map<String, dynamic> storeMap = {
        'st_idx': cartItem.stIdx,
      };
      int productPrice = 0;
      for (var product in cartItem.productList ?? [] as List<CartItemData>) {
        productPrice += ((product.ptPrice ?? 0) * (product.ptCount ?? 0));
      }

      if (productPrice > 0) {
        storeMap['store_all_price'] = productPrice;
        storeArr.add(storeMap);
      }
    }

    Map<String, dynamic> requestData = {
      'mt_idx': pref.getMtIdx(),
      'store_arr': json.encode(storeArr),
      'all_price': _getTotalProductPrice(),
    };

    final couponResponseDTO = await ref.read(paymentDiscountViewModelProvider.notifier).getOrderCoupon(requestData);
    _couponList = couponResponseDTO?.list ?? [];
  }

  int _getTotalProductPrice() {
    // 선택된 기준으로 가격 가져오기
    int totalProductPrice = 0;
    for (var cartItem in widget.cartList) {
      for (var product in cartItem.productList ?? [] as List<CartItemData>) {
        totalProductPrice += ((product.ptPrice ?? 0) * (product.ptCount ?? 0));
      }
    }
    return totalProductPrice;
  }

  void _pointCheck(String point) {
    if (point.isNotEmpty) {
      int pointValue = int.parse(point);
      int totalProductPrice = _getTotalProductPrice();
      if (pointValue > totalProductPrice) {
        pointValue = totalProductPrice;
      }
      _pointController.text = pointValue.toString();
      widget.onPointChanged(pointValue);
    } else {
      widget.onPointChanged(0);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 20.0, horizontal: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                '쿠폰',
                style: TextStyle(
                  fontFamily: 'Pretendard',
                  fontSize: Responsive.getFont(context, 13),
                  fontWeight: FontWeight.w500,
                  color: Colors.black,
                  height: 1.2,
                ),
              ),
              Text(
                '보유 쿠폰 ${_couponList.length}장',
                style: TextStyle(
                  fontFamily: 'Pretendard',
                  fontSize: Responsive.getFont(context, 13),
                  color: const Color(0xFF7B7B7B),
                  height: 1.2,
                ),
              ),
            ],
          ),
          GestureDetector(
            onTap: () async {
              if (_couponList.isNotEmpty) {
                CouponData? selectedCoupon = await Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => PaymentCoupon(couponList: _couponList,)),
                );
                if (selectedCoupon != null) {
                  setState(() {
                    _couponText = "${selectedCoupon.couponDiscount} 할인 적용";
                  });
                  widget.onCouponSelected(selectedCoupon); // 부모로 할인율 전달
                }
              }
            },
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 14),
              margin: const EdgeInsets.only(top: 10, bottom: 20),
              decoration: BoxDecoration(
                borderRadius: const BorderRadius.all(Radius.circular(6)),
                border: Border.all(color: const Color(0xFFDDDDDD))
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    _couponText,
                    style: TextStyle(
                      fontFamily: 'Pretendard',
                      fontSize: Responsive.getFont(context, 14),
                      fontWeight: FontWeight.normal,
                      height: 1.2,
                    ),
                  ),
                  SvgPicture.asset(
                    'assets/images/ic_link.svg',
                    width: 14,
                    height: 14,
                    colorFilter: const ColorFilter.mode(
                      Color(0xFF7B7B7B),
                      BlendMode.srcIn,
                    ),
                  ),
                ],
              ),
            ),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                '포인트 사용',
                style: TextStyle(
                  fontFamily: 'Pretendard',
                  fontSize: Responsive.getFont(context, 13),
                  fontWeight: FontWeight.w500,
                  color: Colors.black,
                  height: 1.2,
                ),
              ),
              Text(
                '보유 포인트 ${Utils.getInstance().priceString(_point)}P',
                style: TextStyle(
                  fontFamily: 'Pretendard',
                  fontSize: Responsive.getFont(context, 13),
                  color: const Color(0xFF7B7B7B),
                  height: 1.2,
                ),
              ),
            ],
          ),
          Padding(
            padding: const EdgeInsets.only(top: 10.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  flex: 7,
                  child: Container(
                    margin: const EdgeInsets.only(right: 8),
                    decoration: BoxDecoration(
                      borderRadius: const BorderRadius.all(Radius.circular(6)),
                      border: Border.all(color: const Color(0xFFDDDDDD)),
                    ),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.baseline,
                      textBaseline: TextBaseline.alphabetic,
                      children: [
                        Expanded(
                          child: TextField(
                            controller: _pointController,
                            keyboardType: TextInputType.number,
                            // 숫자 입력만 가능하게 설정
                            decoration: InputDecoration(
                              border: InputBorder.none, // 테두리 제거
                              hintText: '0',
                              hintStyle: TextStyle(
                                fontFamily: 'Pretendard',
                                fontSize: Responsive.getFont(context, 14),
                                color: const Color(0xFF707070),
                              ),
                            ),
                            textAlign: TextAlign.right,
                            // 텍스트를 오른쪽 정렬
                            onChanged: (text) {
                              _pointCheck(text);
                            },
                          ),
                        ),
                        Container(
                          padding: const EdgeInsets.only(right: 15, left: 10),
                          child: Text(
                            'P',
                            style: TextStyle(
                              fontFamily: 'Pretendard',
                              fontSize: Responsive.getFont(context, 14),
                              fontWeight: FontWeight.normal,
                              height: 1.2,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                Expanded(
                  flex: 3,
                  child: Container(
                    padding: const EdgeInsets.symmetric(vertical: 14),
                    decoration: BoxDecoration(
                      borderRadius: const BorderRadius.all(Radius.circular(6)),
                      border: Border.all(color: const Color(0xFFDDDDDD))
                    ),
                    child: GestureDetector(
                      onTap: () {
                        if (_point > 0) {
                          _pointController.text = _point.toString();
                          _pointCheck(_point.toString());
                        }
                      },
                      child: Center(
                        child: Text(
                          '전액사용',
                          style: TextStyle(
                            fontFamily: 'Pretendard',
                            fontSize: Responsive.getFont(context, 14),
                            fontWeight: FontWeight.normal,
                            height: 1.2,
                          ),
                        ),
                      ),
                    ),
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
