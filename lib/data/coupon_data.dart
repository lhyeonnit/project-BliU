class CouponData {
  final String? couponUsealbe;
  final int? couponIdx;
  final String? couponName;
  final String? couponDiscount;
  final int? couponPrice;
  final int? couponMinPrice;
  final int? couponMaxPrice;
  final String? couponEnd;

  CouponData({
    required this.couponUsealbe,
    required this.couponIdx,
    required this.couponName,
    required this.couponDiscount,
    required this.couponPrice,
    required this.couponMinPrice,
    required this.couponMaxPrice,
    required this.couponEnd,
  });

  // JSON to Object
  factory CouponData.fromJson(Map<String, dynamic> json) {
    return CouponData(
      couponUsealbe: json['coupon_usealbe'],
      couponIdx: json['coupon_idx'],
      couponName: json['coupon_name'],
      couponDiscount: json['coupon_discount'],
      couponPrice: json['coupon_price'],
      couponMinPrice: json['coupon_min_price'],
      couponMaxPrice: json['coupon_max_price'],
      couponEnd: json['coupon_end'],
    );
  }

  // Object to JSOn
  Map<String, dynamic> toJson() {
    return {
      'coupon_usealbe': couponUsealbe,
      'coupon_idx': couponIdx,
      'coupon_name': couponName,
      'coupon_discount': couponDiscount,
      'coupon_price': couponPrice,
      'coupon_min_price': couponMinPrice,
      'coupon_max_price': couponMaxPrice,
      'coupon_end': couponEnd,
    };
  }
}