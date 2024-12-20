class CancelData {
  final int? ctTotal;
  final int? ctPrice;
  final int? ctCoupon;
  final int? ctPoint;
  final int? ctDelivery;

  CancelData({
    required this.ctTotal,
    required this.ctPrice,
    required this.ctCoupon,
    required this.ctPoint,
    required this.ctDelivery,
  });

  // JSON to Object
  factory CancelData.fromJson(Map<String, dynamic> json) {
    return CancelData(
      ctTotal: json['ct_total'],
      ctPrice: json['ct_price'],
      ctCoupon: json['ct_coupon'],
      ctPoint: json['ct_point'],
      ctDelivery: json['ct_delivery'],
    );
  }

  // Object to JSOn
  Map<String, dynamic> toJson() {
    return {
      'ct_total': ctTotal,
      'ct_price': ctPrice,
      'ct_coupon': ctCoupon,
      'ct_point': ctPoint,
      'ct_delivery': ctDelivery,
    };
  }
}