import 'package:BliU/data/cart_data.dart';
import 'package:BliU/data/coupon_data.dart';

class PayOrderResultDetailData {
  final int? otIdx;
  final String? otCode;
  final int? otSprice;
  final int? otPrice;
  final int? allDeliveryPrice;
  final int? otUsePoint;
  final int? otUseCoupon;
  final CouponData? coupon;
  final List<CartData>? list;

  PayOrderResultDetailData({
    required this.otIdx,
    required this.otCode,
    required this.otSprice,
    required this.otPrice,
    required this.allDeliveryPrice,
    required this.otUsePoint,
    required this.otUseCoupon,
    required this.coupon,
    required this.list,
  });

  factory PayOrderResultDetailData.fromJson(Map<String, dynamic> json) {
    final product = List<CartData>.from((json['list'])?.map((item) {
      return CartData.fromJson(item as Map<String, dynamic>);
    }).toList());

    return PayOrderResultDetailData(
      otIdx: json['ot_idx'],
      otCode: json['ot_code'],
      otSprice: json['ot_sprice'],
      otPrice: json['ot_price'],
      allDeliveryPrice: json['all_delivery_price'],
      otUsePoint: json['ot_use_point'],
      otUseCoupon: json['ot_use_coupon'],
      coupon: CouponData.fromJson(json['coupon']),
      list: product,
    );
  }

  Map<String, dynamic> toJson() => {
    'ot_idx' : otIdx,
    'ot_code' : otCode,
    'ot_sprice' : otSprice,
    'ot_price' : otPrice,
    'all_delivery_price' : allDeliveryPrice,
    'ot_use_point' : otUsePoint,
    'ot_use_coupon' : otUseCoupon,
    'coupon' : coupon?.toJson(),
    'product_list' : list?.map((it) => it.toJson()).toList()
  };
}