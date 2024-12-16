class CouponData {
  final String? coupon;
  final String? couponUsealbe;
  final int? couponIdx;
  final String? couponStatus;
  final String? couponName;
  final String? couponDiscount;
  final int? couponPrice;
  final int? couponMinPrice;
  final int? couponMaxPrice;
  final String? couponEnd;
  final int? couponUse;
  final String? ctName;
  final String? ctCode;
  final int? ctPrice;
  final int? ctMinPrice;
  final int? ctMaxPrice;
  final String? ctDate;
  final String? down;
  final String? downText;

  CouponData({
    required this.coupon,
    required this.couponUsealbe,
    required this.couponIdx,
    required this.couponStatus,
    required this.couponName,
    required this.couponDiscount,
    required this.couponPrice,
    required this.couponMinPrice,
    required this.couponMaxPrice,
    required this.couponEnd,
    required this.couponUse,
    required this.ctName,
    required this.ctCode,
    required this.ctPrice,
    required this.ctMinPrice,
    required this.ctMaxPrice,
    required this.ctDate,
    required this.down,
    required this.downText,
  });

  // JSON to Object
  factory CouponData.fromJson(Map<String, dynamic> json) {
    return CouponData(
      coupon: json['coupon'],
      couponUsealbe: json['coupon_usealbe'],
      couponIdx: json['coupon_idx'],
      couponStatus: json['coupon_status'],
      couponName: json['coupon_name'],
      couponDiscount: json['coupon_discount'],
      couponPrice: json['coupon_price'],
      couponMinPrice: json['coupon_min_price'],
      couponMaxPrice: json['coupon_max_price'],
      couponEnd: json['coupon_end'],
      couponUse: json['coupon_use'],
      ctName: json['ct_name'],
      ctCode: json['ct_code'],
      ctPrice: json['ct_price'],
      ctMinPrice: json['ct_min_price'],
      ctMaxPrice: json['ct_max_price'],
      ctDate: json['ct_date'],
      down: json['down'],
      downText: json['down_text'],
    );
  }

  // Object to JSOn
  Map<String, dynamic> toJson() {
    return {
      'coupon': coupon,
      'coupon_usealbe': couponUsealbe,
      'coupon_idx': couponIdx,
      'coupon_status': couponStatus,
      'coupon_name': couponName,
      'coupon_discount': couponDiscount,
      'coupon_price': couponPrice,
      'coupon_min_price': couponMinPrice,
      'coupon_max_price': couponMaxPrice,
      'coupon_end': couponEnd,
      'coupon_use': couponUse,
      'ct_name': ctName,
      'ct_code': ctCode,
      'ct_price': ctPrice,
      'ct_min_price': ctMinPrice,
      'ct_max_price': ctMaxPrice,
      'ct_date': ctDate,
      'down': down,
      'down_text': downText,
    };
  }
}