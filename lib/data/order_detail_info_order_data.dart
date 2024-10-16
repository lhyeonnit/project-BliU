import 'package:BliU/data/coupon_data.dart';

class OrderDetailInfoOrderData {
  final int? otDeliveryCharge;
  final int? otDeliveryChargeExtra;
  final String? otPayType;
  final int? otSprice;
  final int? otUsePoint;
  final int? otUseCoupon;
  final CouponData? otCouponInfo;

  OrderDetailInfoOrderData({
    required this.otDeliveryCharge,
    required this.otDeliveryChargeExtra,
    required this.otPayType,
    required this.otSprice,
    required this.otUsePoint,
    required this.otUseCoupon,
    required this.otCouponInfo,
  });

  // JSON to Object
  factory OrderDetailInfoOrderData.fromJson(Map<String, dynamic> json) {
    return OrderDetailInfoOrderData(
      otDeliveryCharge: json['ot_delivery_charge'],
      otDeliveryChargeExtra: json['ot_delivery_charge_extra'],
      otPayType: json['ot_pay_type'],
      otSprice: json['ot_sprice'],
      otUsePoint: json['ot_use_point'],
      otUseCoupon: json['ot_use_coupon'],
      otCouponInfo: CouponData.fromJson(json['ot_coupon_info']),
    );
  }

  // Object to JSOn
  Map<String, dynamic> toJson() {
    return {
      'ot_delivery_charge': otDeliveryCharge,
      'ot_delivery_charge_extra': otDeliveryChargeExtra,
      'ot_pay_type': otPayType,
      'ot_sprice': otSprice,
      'ot_use_point': otUsePoint,
      'ot_use_coupon': otUseCoupon,
      'ot_coupon_info': otCouponInfo?.toJson(),
    };
  }
}